//
//  SwiftUIView.swift
//  
//
//  Created by Noah Little on 23/7/2022.
//

import SwiftUI

struct GRArtworkGradient: View {
    
    @EnvironmentObject var mediaModel: GRMediaModel
    private var startX = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? 0.1 : 1.0
    private var endX = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? 1.0 : 0.1

    var body: some View {
        HStack {
            Spacer()
            ZStack {
                Image(uiImage: mediaModel.albumArtwork)
                    .resizable()
                    .frame(width: Settings.height, height: Settings.height, alignment: .trailing)
                    .aspectRatio(contentMode: .fit)
                
                LinearGradient(colors: [Color(mediaModel.artworkColour), Color(mediaModel.artworkColour).opacity(0.0)],
                               startPoint: UnitPoint(x: startX, y: 0.5),
                               endPoint: UnitPoint(x: endX, y: 0.5))
                .frame(width: Settings.height, height: Settings.height, alignment: .trailing)
            }
        }
    }
}
