//
//  Frames.swift
//  
//
//  Created by Noah Little on 30/8/2022.
//

import SwiftUI

struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ViewGeometry: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ViewSizeKey.self, value: geometry.size)
        }
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
