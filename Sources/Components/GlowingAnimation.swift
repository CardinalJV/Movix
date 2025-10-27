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
                .frame(width: 75, height: 25)
                .blur(radius: 40)
            HStack(spacing: 0){
                HStack{
                    Image(systemName: "popcorn")
                        .font(.title3)
                    Text("Mov")
                }
                .foregroundStyle(.red)
                Text("ix")
                    .foregroundStyle(.white)
            }
            .font(.system(size: 30))
            .fontDesign(.rounded)
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
