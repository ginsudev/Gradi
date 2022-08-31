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
            VStack(alignment: .leading, spacing: 0) {
                Marquee(text: $mediaModel.trackName,
                        screenOn: $mediaModel.screenOn,
                        font: .system(size: 15, weight: .bold, design: Settings.fontType),
                        animationTime: 3.0,
                        delayTime: 1.0)
                
                Marquee(text: $mediaModel.artistName,
                        screenOn: $mediaModel.screenOn,
                        font: .system(size: 14, weight: .regular, design: Settings.fontType),
                        animationTime: 3.0,
                        delayTime: 1.0)
            }
        }
    }
}
