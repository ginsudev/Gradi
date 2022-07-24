//
//  SwiftUIView.swift
//  
//
//  Created by Noah Little on 23/7/2022.
//

import SwiftUI

struct GRArtworkGradient: View {
    
    @EnvironmentObject var mediaModel: GRMediaModel
    
    var body: some View {
        HStack {
            Spacer()
            ZStack {
                Image(uiImage: mediaModel.albumArtwork)
                    .resizable()
                    .frame(width: Settings.height, height: Settings.height, alignment: .trailing)
                    .aspectRatio(contentMode: .fit)
                
                LinearGradient(colors: [Color(mediaModel.artworkColour), Color(mediaModel.artworkColour).opacity(0.0)],
                               startPoint: UnitPoint(x: 0.1, y: 0.5),
                               endPoint: UnitPoint(x: 1.0, y: 0.5))
                .frame(width: Settings.height, height: Settings.height, alignment: .trailing)
            }
        }
    }
}
