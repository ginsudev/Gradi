//
//  GRMediaContainer.swift
//  
//
//  Created by Noah Little on 20/7/2022.
//

import SwiftUI

struct GRMediaContainer: View {
    
    @StateObject var mediaModel = GRMediaModel.sharedInstance
    
    var body: some View {
        ZStack {
            GRArtworkGradient()
                .frame(maxWidth: .infinity)
            VStack {
                if !Settings.showNPInfo && Settings.showTimeline {
                    Spacer()
                }
                
                if Settings.showNPInfo {
                    Spacer()
                    GRHeader()
                        .frame(maxWidth: .infinity, maxHeight: 18)
                        .padding(.trailing, Settings.height - Settings.cornerRadius)
                }
                
                GRBody()
                    .padding(.trailing, Settings.height - 17.0 - Settings.cornerRadius)
                
                if Settings.showTimeline {
                    GRTimeline()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, Settings.height - 17.0 - Settings.cornerRadius)
                    Spacer()
                }
                
                if !Settings.showTimeline && Settings.showNPInfo {
                    Spacer()
                }

            }
            .padding(Settings.cornerRadius)
        }
        .environmentObject(mediaModel)
        .background(Color(mediaModel.artworkColour))
    }
}

var child = GRHostingController(rootView: GRMediaContainer())
