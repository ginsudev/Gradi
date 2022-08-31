//
//  Marquee.swift
//
//
//  Created by Noah Little on 2022/8/22.
//

import SwiftUI

enum AnimationState {
    case animating, idle
}

struct Marquee: View {
    
    @Binding var text: String
    @Binding var screenOn: Bool
    
    @State private var textWidth: CGFloat = 0
    @State private var scrollFrame = CGRect()
    @State private var offset: CGFloat = 0
    
    @State private var animationState: AnimationState = .idle
    @State private var animationPhases = [DispatchWorkItem]()

    var font: Font
    var animationTime: Double
    var delayTime: Double
    
    var body: some View {
        //Horizontal scrollview
        ScrollView(.horizontal, showsIndicators: false) {
            Text(text)
                .font(font)
                .lineLimit(1)
                .multilineTextAlignment(.leading)
                .offset(x: offset)
                .background(ViewGeometry())
                .onPreferenceChange(ViewSizeKey.self) {
                    textWidth = $0.width
                }
        }
        .disabled(true)
        .background(GeometryGetter(rect: $scrollFrame))
        
        .onAppear {
            DispatchQueue.main.async {
                animate()
            }
        }
        
        .onChange(of: textWidth) { _ in
            DispatchQueue.main.async {
                if animationState == .animating {
                    animationPhases.forEach { $0.cancel() }
                    animationPhases.removeAll()
                }
                
                offset = 0
                
                guard canAnimate() else {
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    animate()
                }
            }
        }
        
        .onChange(of: screenOn) { _ in
            DispatchQueue.main.async {
                if animationState == .animating {
                    animationPhases.forEach { $0.cancel() }
                    animationPhases.removeAll()
                }
                
                offset = 0
                animate()
            }
        }
    }
    
    private func animate() {
        animationState = .idle

        guard canAnimate() else {
            return
        }
        
        animationState = .animating
        
        let offLeft = DispatchWorkItem {
            withAnimation(.linear(duration: (animationTime / 0.5))) {
                offset = -textWidth
            }
        }
        
        let fullRightToZero = DispatchWorkItem {
            offset = scrollFrame.width

            withAnimation(.linear(duration: animationTime)) {
                offset = 0
            }
        }
        
        let resetAnimation = DispatchWorkItem {
            self.animate()
        }
        
        self.animationPhases.append(offLeft)
        self.animationPhases.append(fullRightToZero)
        self.animationPhases.append(resetAnimation)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime, execute: animationPhases[0])
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime + (animationTime / 0.5), execute: animationPhases[1])
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime + (animationTime / 0.5) + (animationTime), execute: animationPhases[2])
    }
    
    private func canAnimate() -> Bool {
        return (textWidth >= scrollFrame.width) && screenOn && Settings.scrollingLabels
    }
}
