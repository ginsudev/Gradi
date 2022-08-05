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
                Marquee {
                    Text(mediaModel.trackName)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 15, weight: .bold, design: Settings.fontType))
                }
                .marqueeDuration(5)
                .marqueeIdleAlignment(.leading)
                .marqueeDirection(UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? .right2left : .left2right)
                .marqueeAutoreverses(false)
                .marqueeWhenNotFit(true)
                
                Marquee {
                    Text(mediaModel.artistName)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 14, weight: .regular, design: Settings.fontType))
                }
                .marqueeDuration(4)
                .marqueeIdleAlignment(.leading)
                .marqueeDirection(UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? .right2left : .left2right)
                .marqueeAutoreverses(false)
                .marqueeWhenNotFit(true)
            }
        }
    }
}
