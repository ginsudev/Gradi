//
//  GRTimeline.swift
//  
//
//  Created by Noah Little on 26/7/2022.
//

import SwiftUI

struct GRTimeline: View {
    
    @EnvironmentObject var mediaModel: GRMediaModel

    var sliderHeight = 5.0
    @State private var rect = CGRect() //Outer width
    @State var width: Float = 0.0 //Inner width.
    @State var elapsedText = "0:00"
    @State var totalTimeText = "0:00"
    
    var body: some View {
        
        HStack {
            //Min time label
            Text(elapsedText)
                .foregroundColor(Color(mediaModel.foregroundColour))
                .font(.caption2)
            
            ZStack(alignment: .leading) {
                
                //Background of bar
                Rectangle()
                    .frame(height: sliderHeight)
                    .background(GeometryGetter(rect: $rect))
                    .foregroundColor(.gray)
                    .gesture(DragGesture(minimumDistance: 1)
                        .onChanged({ value in
                            
                            if value.location.x < 0 {
                                width = 0
                            } else if value.location.x > rect.width {
                                width = Float(rect.width)
                            } else {
                                width = Float(value.location.x)
                            }
                            
                        })
                        
                        .onEnded({ value in
                            let progress = (mediaModel.trackLength / Float(rect.width)) * Float(width)
                            GRManager.sharedInstance.setElapsedTime(Double(progress))
                        }))
                
                //Foreground of bar
                Rectangle()
                    .frame(width: CGFloat(width), height: sliderHeight)
                    .foregroundColor(Color(mediaModel.foregroundColour))
                    .allowsHitTesting(false)
                    .onChange(of: mediaModel.elapsedTime) { newValue in
                        width = (Float(rect.width) / mediaModel.trackLength) * mediaModel.elapsedTime
                        elapsedText = timeFormatted(Int(mediaModel.elapsedTime))
                        totalTimeText = timeFormatted(Int(mediaModel.trackLength))
                    }
            }
            .cornerRadius(sliderHeight/2)
            
            //Max time label
            Text(totalTimeText)
                .foregroundColor(Color(mediaModel.foregroundColour))
                .font(.caption2)
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        var seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        
        seconds = seconds <= 0 ? 0 : seconds
        
        guard hours <= 0 else {
            return String(format: "%02d:%02d:%02d", arguments: [hours, minutes, seconds])
        }
        
        return String(format: "%02d:%02d", arguments: [minutes, seconds])
    }
}

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { (g) -> Path in
            DispatchQueue.main.async {
                self.rect = g.frame(in: .global)
            }
            return Path()
        }
    }
}
