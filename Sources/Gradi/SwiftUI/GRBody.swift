//
//  GRBody.swift
//  
//
//  Created by Noah Little on 22/7/2022.
//

import SwiftUI

struct GRBody: View {
    
    @EnvironmentObject var mediaModel: GRMediaModel

    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                HStack {
                    GRTrackLabels()
                    Spacer()
                    GRControls()
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(width: 112, height: 44, alignment: .trailing)
                        .padding(.leading, 5)
                        .environment(\.layoutDirection, .leftToRight)
                }
            }
            .foregroundColor(Color(mediaModel.foregroundColour))
            
            Spacer()
        }
    }
}
