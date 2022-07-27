//
//  GRMediaContainer.swift
//  
//
//  Created by Noah Little on 20/7/2022.
//

import SwiftUI

struct GRMediaContainer: View {
    
    @StateObject var mediaModel = GRMediaModel.sharedInstance
    private var padding = Settings.cornerRadius * 2
    
    var body: some View {
        ZStack {
            GRArtworkGradient()
                .frame(maxWidth: .infinity)
            VStack {
                GRHeader()
                    .frame(maxWidth: .infinity, maxHeight: 18)
                    .padding(.trailing, Settings.height - padding)
                
                GRBody()
                    .padding(.trailing, Settings.height - 17 - padding)
                
                if Settings.showTimeline {
                    GRTimeline()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, Settings.height - 17 - padding)
                }

                Spacer()
            }
            .padding(padding)
        }
        .environmentObject(mediaModel)
        .background(Color(mediaModel.artworkColour))
    }
}

var child = GRHostingController(rootView: GRMediaContainer())
