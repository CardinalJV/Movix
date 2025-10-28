//
//  TypingAnimation.swift
//  Movix
//
//  Created by Viranaiken Jessy on 27/10/25.
//

import SwiftUI

struct TypingAnimation: View {
    
    //    ["Spider-Man", "Avengers", "Fury", "Fast and furious"]
    @State private var text: String = ""
    @State private var textIndex: Int = 0
    @State private var typedText: String = ""
    let arrayOfText: [String]
    
    private func getTypingAnimation(at position: Int = 0) {
        guard textIndex < arrayOfText.count else { return }
        let typedText = arrayOfText[textIndex]
        
        if position < typedText.count {
            let index = typedText.index(typedText.startIndex, offsetBy: position)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.text.append(typedText[index])
                self.getTypingAnimation(at: position + 1)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.deleteTypingAnimation(at: typedText.count - 1)
            }
        }
    }

    private func deleteTypingAnimation(at position: Int) {
        if position >= 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.text.removeLast()
                self.deleteTypingAnimation(at: position - 1)
            }
        } else {
            self.textIndex += 1
            self.getTypingAnimation(at: 0)
        }
    }
    
    var body: some View {
        VStack(spacing: 16.0) {
            Text("'" + text + "...'")
                .foregroundStyle(.red)
                .opacity(0.5)
                .bold()
                .fontDesign(.rounded)
                .font(.title)
        }
        .onAppear{
            getTypingAnimation()
        }
    }
}

//#Preview {
//    TypingAnimation()
//}
