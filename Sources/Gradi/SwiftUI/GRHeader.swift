//
//  GRHeader.swift
//  
//
//  Created by Noah Little on 21/7/2022.
//

import SwiftUI
import GradiC
import AVKit

struct GRHeader: View {
    
    @EnvironmentObject var mediaModel: GRMediaModel

    var body: some View {
        HStack {
            Button(action: {
                AVRoutePickerView()._routePickerButtonTapped(nil)
            }){
                HStack {
                    Image(uiImage: mediaModel.nowPlayingAppIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(alignment: .leading)
                    
                    Text(mediaModel.routeName.uppercased())
                        .font(Font.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(Color(mediaModel.foregroundColour))
                }
            }
            
            Spacer()
        }
    }
}
