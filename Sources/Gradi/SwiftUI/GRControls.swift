//
//  SwiftUIView.swift
//  
//
//  Created by Noah Little on 23/7/2022.
//

import SwiftUI
import GradiC

struct GRControls: View {
    
    @EnvironmentObject var mediaModel: GRMediaModel

    var body: some View {
        HStack {
            
            Button(action: {
                SBMediaController.sharedInstance().changeTrack(-1, eventSource: 0)
            }){
                Image(uiImage: UIImage(named: "/Library/Application Support/Gradi/previous.png")!)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 34, height: 34)
                    .aspectRatio(contentMode: .fit)
            }
            .buttonStyle(ScaleButtonStyle())
            
            Button(action: {
                SBMediaController.sharedInstance().togglePlayPause(forEventSource: 0)
            }){
                Image(uiImage: mediaModel.playPauseIcon!)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 44, height: 44)
                    .aspectRatio(contentMode: .fit)
            }
            .buttonStyle(ScaleButtonStyle())
            
            Button(action: {
                SBMediaController.sharedInstance().changeTrack(1, eventSource: 0)
            }){
                Image(uiImage: UIImage(named: "/Library/Application Support/Gradi/next.png")!)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 34, height: 34)
                    .aspectRatio(contentMode: .fit)
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.7 : 1)
    }
}
