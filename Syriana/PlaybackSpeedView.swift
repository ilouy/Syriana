//
//  PlaybackSpeedView.swift
//  Syriana
//
//  Created by Fady Basem on 9/17/22.
//

import SwiftUI

struct PlaybackSpeedView: View {
    @Binding var playbackSpeed: Float
    var body: some View {
        List {
            Text("0.5x" + (playbackSpeed == 0.5 ? " ✓" : ""))
                .onTapGesture {
                    playbackSpeed = 0.5
                }
            Text("0.75x" + (playbackSpeed == 0.75 ? " ✓" : ""))
                .onTapGesture {
                    playbackSpeed = 0.75
                }
            Text("1.0x" + (playbackSpeed == 1.0 ? " ✓" : ""))
                .onTapGesture {
                    playbackSpeed = 1.0
                }
            Text("1.25x" + (playbackSpeed == 1.25 ? " ✓" : ""))
                .onTapGesture {
                    playbackSpeed = 1.25
                }
            Text("1.5x" + (playbackSpeed == 1.5 ? " ✓" : ""))
                .onTapGesture {
                    playbackSpeed = 1.5
                }
            Text("1.75x" + (playbackSpeed == 1.75 ? " ✓" : ""))
                .onTapGesture {
                    playbackSpeed = 1.75
                }
            Text("2.0x" + (playbackSpeed == 2.0 ? " ✓" : ""))
                .onTapGesture {
                    playbackSpeed = 2.0
                }

        }.cornerRadius(50).frame(width: 150, height: 400)
    }
}

struct PlaybackSpeedView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackSpeedView(playbackSpeed: .constant(1.0))
    }
}
