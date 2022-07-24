//
//  GRTrackLabels.swift
//  
//
//  Created by Noah Little on 22/7/2022.
//

import SwiftUI

struct GRTrackLabels: View {
    
    @EnvironmentObject var mediaModel: GRMediaModel
    
    var body: some View {
        Button(action: {
            GRManager.sharedInstance.openNowPlayingApp()
        }){
            VStack(alignment: .leading) {
                Text(mediaModel.trackName)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 15, weight: .bold, design: Settings.fontType))
                    
                Text(mediaModel.artistName)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 14, weight: .regular, design: Settings.fontType))
            }
        }
    }
}
