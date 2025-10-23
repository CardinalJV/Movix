//
//  TopRatedView.swift
//  Movix
//
//  Created by Viranaiken Jessy on 21/10/25.
//

import SwiftUI

//struct TopRatedView: View {
//    var body: some View {
//        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15){
//          ForEach(self.movies.prefix(self.showAllMovies ? self.movies.count : 10)) { movie in
//            NavigationLink {
//              MovieView(id: movie.id)
//                .navigationTransition(.zoom(sourceID: "zoom", in: self.namespace))
//            } label: {
//              VStack{
//                ImageLoader(imageUrl: movie.posterPath)
//                  .scaledToFit()
//                  .frame(height: 250)
//                  .clipShape(RoundedRectangle(cornerRadius: 5))
//              }
//              .animation(.bouncy, value: self.showAllMovies)
//            }
//
//          }
//        }
//    }
//}
//
//#Preview {
//    TopRatedView()
//}
