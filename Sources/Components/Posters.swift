//
//  Posters.swift
//  Movix
//
//  Created by Viranaiken Jessy on 17/10/25.
//

import SwiftUI

struct Posters: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let posterPath: URL
    let backdropPath: URL
    
    
    var body: some View {
        GeometryReader{ geo in
                ZStack{
                    /* BackPoster */
                    ImageLoader(imageUrl: backdropPath)
//                        .frame(width: geo.size.width, height: geo.size.height)
                        .opacity(0.75)
                        .border(.green)
                        .overlay(alignment: .topLeading){
                            VStack{
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "xmark")
                                        .padding(8)
                                        .font(.title3)
                                        .bold()
                                        .foregroundStyle(.white)
                                        .background(Color(red: 40/250, green: 40/250, blue: 40/250), in: Circle())
                                }
                                Spacer()
                            }
                            .padding(10)
                        }
                    /* - */
                    /* Main poster and title */
                    ImageLoader(imageUrl: posterPath)
                        .border(.blue)
                        .frame(width: geo.size.width * 0.5, height: geo.size.height * 0.25)
                        .position(x: geo.size.width * 0.5, y: geo.size.height * 25)
                        .shadow(radius: 10)
                    /* - */
                    Color.clear
                        .frame(width: geo.size.width, height: geo.size.height)
                }
                .border(.red)
        }
        .border(.yellow)
    }
}

//#Preview {
//
//}
