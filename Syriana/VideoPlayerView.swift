//
//  VideoView.swift
//  Syriana
//
//  Created by Fady Basem on 9/12/22.
//

import SwiftUI
import AVKit
import Amplify

struct VideoPlayerView: View {
    @State var player: AVPlayer?
    @State var videoZoom = 1.0
    @State var controlsAreVisible = false
    @Binding var videoURL: String
    @Binding var videoPlayerShown: Bool
    @State var playbackSpeed: Float = 1.0
    @State var playbackSpeedShown = false
    @State private var offset = CGSize.zero

    var body: some View {
        ZStack {
            Group{
                if player != nil {
                    ZStack(alignment: .topLeading) {
                        VideoPlayer(player: player)
                            .edgesIgnoringSafeArea(.all)
                            .scaleEffect(videoZoom < 1.0 ? 1.0 : videoZoom)
                            .offset(x: offset.width * 2.5, y: 0)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if videoZoom == 1.0 {
                                            offset = CGSize.zero
                                        } else {
                                            offset = gesture.translation

                                        }
                                    }
                            ).gesture(
                                MagnificationGesture().onChanged({ scale in
                                    videoZoom = scale
                                    offset = CGSize.zero
                                })
                            ).onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in
                                
                                print("Screenshot taken")
                                disableUser()
                                videoPlayerShown = false
                                AppDelegate.isBlocked = true
                            }.onReceive(NotificationCenter.default.publisher(for: UIScreen.capturedDidChangeNotification)) { value in

                                print(value)
                                disableUser()
                                videoPlayerShown = false
                                AppDelegate.isBlocked = true
                            }.onChange(of: controlsAreVisible) { newValue in
                                print(newValue)
                            }.overlay {
                                if !controlsAreVisible {
                                    Rectangle()
                                        .opacity(0.01)
                                        .propotionalFrame(width: 1.0, height: 1.0)
                                        .onTapGesture {
                                            controlsAreVisible = true
                                        }
                                }
                            }
                        
                        if controlsAreVisible {
                            VStack(alignment: .leading) {
                                HStack{
                                    Button(action: {
                                        player?.pause()
                                        videoPlayerShown = false
                                    }) {
                                        Image(systemName: "xmark")
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(.gray)
                                            .cornerRadius(20)
                                            .padding()
                                    }
                                    
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        playbackSpeedShown = true
                                    }) {
                                        Image(systemName: "speedometer")
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(.gray)
                                            .cornerRadius(20)
                                            .padding()
                                    }
                                    
                                }.offset(x: 0, y: 60)
                                
                            }.onAppear {
                                Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { _ in
                                    controlsAreVisible = false
                                }
                            }
                        }
                        
                    }
                } else {
                    ProgressView()
                        .onAppear {
                            player = AVPlayer(url: URL(string: videoURL)!)
                        }
                }
            }.blur(radius: playbackSpeedShown ? 30 : 0)
            .navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onChange(of: playbackSpeed) { newValue in
                player?.rate = playbackSpeed
                playbackSpeedShown = false
            }
            
            if playbackSpeedShown {
                PlaybackSpeedView(playbackSpeed: $playbackSpeed)
            }
        }.onAppear{
            if AppDelegate.screenRecordingInProgress {
                disableUser()
                videoPlayerShown = false
                AppDelegate.isBlocked = true
            }
        }
            
    }
    
    func disableUser () {
        let username = Amplify.Auth.getCurrentUser()!.username
        let body: [String: String] = ["username": username]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
                
        let url = URL(string: "https://xh3dd7corr3lbc5b5fns34hklq0eytlc.lambda-url.us-east-1.on.aws/")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { _, _, _ in }

        task.resume()
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView(videoURL: .constant("https://amplify-syriana-dev-10930-deployment.s3.amazonaws.com/Data/Instructors/Mazen+Shaalan/Videos/Geology/Presentation.mp4"), videoPlayerShown: .constant(true))
    }
}
