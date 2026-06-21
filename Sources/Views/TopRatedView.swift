//
//  TopRatedView.swift
//  Movix
//
//  Created by Viranaiken Jessy on 21/10/25.
//

import SwiftUI

struct TopRatedView: View {
    
    
    var body: some View {
        ZStack{
            MovixTheme.background
                .ignoresSafeArea(.all)
            ScrollView{
                /* Header */
                VStack(alignment: .leading, spacing: 0){
                    Rectangle()
                        .frame(width: 50, height: 4)
                        .foregroundStyle(LinearGradient(colors: [.red, .white], startPoint: .leading, endPoint: .trailing))
                    Text("Top rated")
                        .font(.largeTitle)
                        .foregroundStyle(MovixTheme.primaryText)
                        .bold()
                }
                .frame(width: 350, alignment: .leading)
                /* - */
                /* TopRatedMovies */
                TopRatedMovies()
                /* - */
            }
        }
        .tint(.red)
    }
}

//#Preview {
//    TopRatedView()
//}
