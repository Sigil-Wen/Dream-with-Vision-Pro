//
//  LoadingView.swift
//  Dream
//
//  Created by Sigil Wen on 2023-07-15.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.blue, lineWidth: 5)
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear {
                    self.isAnimating = true
                }
        }
    }
}
