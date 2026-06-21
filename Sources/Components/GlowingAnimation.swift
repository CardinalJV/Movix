//
//  GlowingAnimation.swift
//  Movix
//
//  Created by Viranaiken Jessy on 17/10/25.
//

import SwiftUI

struct GlowingAnimation: View {
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AngularGradient(colors: [.red], center: .center, angle: .degrees(self.isAnimating ? 360 : 0)))
                .frame(width: 34, height: 24)
                .blur(radius: 18)
            Image(systemName: "popcorn")
                .font(.system(size: 20))
                .foregroundStyle(MovixTheme.accent)
            .bold()
        }
        .onAppear{
            withAnimation(Animation.linear(duration: .infinity).repeatForever(autoreverses: false)) {
                self.isAnimating = true
            }
        }
        .onDisappear{
            self.isAnimating = false
        }
    }
}

#Preview {
    GlowingAnimation()
}
