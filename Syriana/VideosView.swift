//
//  VideosView.swift
//  Syriana
//
//  Created by Fady Basem on 9/7/22.
//

import SwiftUI
import Combine
import Amplify

struct VideosView: View {
    @State var videosSubscriber: AnyCancellable!
    @State var videos: [VideoData] = []
    @State var videoURL = ""
    @State var videoPlaying = false
    @State var loading = true
    @Binding var instructor: String
    @Binding var course: String
    @Binding var type: VideosViewType
    @Binding var noInternet: Bool
    @Binding var noInternetAction: () -> ()
    @Binding var errorOccurred: Bool
    @Binding var errorMessage: String

    var body: some View {
        ZStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 125))]) {
                ForEach($videos, id: \.wrappedValue.name.hashValue) { video in
                    let name = video.name.wrappedValue
                    let displayName = String(name[..<name.range(of: ".mp4")!.lowerBound])
                    
                    GridItemView(image: .constant(nil), imageURL: .constant(video.thumbnail.wrappedValue.replacingOccurrences(of: " ", with: "%20")), text: .constant(type == .previewShown ? (video.isPreview.wrappedValue ? displayName.appending("\nPreview Available") : displayName) : displayName))
                        .onTapGesture {
                            print(video.name.wrappedValue)
                            getVideoURL(for: video.name.wrappedValue, completionHandler: { url in
                                videoURL = url
                                
                                if (type == .previewShown && video.isPreview.wrappedValue) || type == .previewNotShown {
                                    
                                    videoPlaying = true
                                }
                            })
                    }

                }
                
            }.onAppear {
                videosSubscriber = getVideos()

            }
            
            if loading {
                ProgressView()
            }
            
            NavigationLink(destination: VideoPlayerView(videoURL: $videoURL, videoPlayerShown: $videoPlaying), isActive: $videoPlaying) { EmptyView() }

        }
    }
    
    func getVideos () -> AnyCancellable {
        let request = RESTRequest(path: "/videos", queryParameters: ["instructor": instructor, "course": course])

        let sink = Amplify.API.get(request: request)
            .resultPublisher
            .sink {
                loading = false
                
                if case let .failure(apiError) = $0 {
                    //TODO: error handling
                    if apiError.errorDescription.localizedStandardContains("timed out"){
                        
                        noInternetAction = {
                            videosSubscriber = getVideos()
                            noInternet = false
                        }
                        noInternet = true
                    } else {
                        errorOccurred = true
                        errorMessage = apiError.errorDescription + apiError.recoverySuggestion
                    }
                }
            }
            receiveValue: { data in
                loading = false
                print("received videos")
                
                do {
                    let decoder = JSONDecoder()
                    self.videos = try decoder.decode(VideosJSONResponse.self, from: data).videos
                } catch {
                    
                }
            }
        return sink
    }
    
    func getVideoURL (for video: String, completionHandler: @escaping (String) -> ()) {
        SyrianaApp.getAccessToken { accessToken in
            let request = RESTRequest.init(path: "/video", headers: ["Authorization": accessToken], queryParameters: ["instructor": instructor, "course": course, "video": video])
            
            Amplify.API.get(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        videoURL = try decoder.decode(VideoURLResponse.self, from: data).url
                        
                        completionHandler(videoURL)
                    } catch {
                        
                    }
                case .failure(let apiError):
                    //TODO: error handling
                    errorOccurred = true
                    errorMessage = apiError.errorDescription + apiError.recoverySuggestion
                }
            }
            
        } errorHandler: { error in
            //TODO: Error Handling
            print(error)
        }
        
    }
}

struct VideosView_Previews: PreviewProvider {
    static var previews: some View {
        VideosView(instructor: .constant(""), course: .constant(""), type: .constant(.previewShown), noInternet: .constant(false), noInternetAction: .constant {}, errorOccurred: .constant(false), errorMessage: .constant(""))
    }
}

enum VideosViewType {
    case previewShown
    case previewNotShown
}
