//
//  CircularProgressView.swift
//  Movix
//
//  Created by Viranaiken Jessy on 20/10/25.
//

import SwiftUI

struct CircularProgressView: View {
    
    let value: Double
    @State private var initialValue: Double = 0.0
    @State private var isAnimated: Bool = false
    
//    private func progressColor(value: Double) -> Color {
//        switch value {
//        case 0..<2.5:
//            return Color.red
//        case 2.5..<7.5:
//            return Color.yellow
//        case 7.5...:
//            return Color.green
//        default:
//            return Color.white
//        }
//    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.20)
                .foregroundStyle(Color.white)
            
            Circle()
                .trim(from: 0, to: self.isAnimated ? CGFloat(self.value / 10) : 0)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .foregroundStyle(.red)
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 0.5).delay(0.5), value: self.isAnimated)
            
            VStack(spacing: 0){
                Text("\(String(format: "%.1f", self.value))")
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .frame(width: 25, height: 2)
                Text("10")
            }
            .font(.caption)
            .bold()
            .foregroundStyle(.white)
        }
        .frame(width: 40, height: 40)
        .onAppear{
            self.isAnimated = true
        }
    }
}
//
//#Preview {
//    CircularProgressView()
//}
