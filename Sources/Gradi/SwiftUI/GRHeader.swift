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
    @State var renderingMode: Image.TemplateRenderingMode = .original

    var body: some View {
        HStack {
            Button(action: {
                AVRoutePickerView()._routePickerButtonTapped(nil)
            }){
                HStack {
                    Image(uiImage: mediaModel.nowPlayingAppIcon)
                        .renderingMode(renderingMode)
                        .resizable()
                        .frame(alignment: .leading)
                        .scaledToFit()
                        .foregroundColor(Color(mediaModel.foregroundColour))
                        .onChange(of: mediaModel.nowPlayingAppIcon) { image in
                            renderingMode = image.isSymbolImage ? .template : .original
                        }
                    
                    Text(mediaModel.routeName.uppercased())
                        .font(Font.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(Color(mediaModel.foregroundColour))
                }
            }
            
            Spacer()
        }
    }
}
