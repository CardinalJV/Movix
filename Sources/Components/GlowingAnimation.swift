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
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color(red: 40/250, green: 40/250, blue: 40/250))
//                .frame(width: 125, height: 50)
            HStack(spacing: -2){
                HStack{
                    Image(systemName: "popcorn")
                        .font(.title3)
                    Text("Mov")
                }
                .foregroundStyle(.red)
                Text("ix")
                    .foregroundStyle(.white)
            }
            .font(.custom("PermanentMarker-Regular", size: 28))
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
