//
//  TopRatedMovies.swift
//  Movix
//
//  Created by Viranaiken Jessy on 26/10/25.
//

import SwiftUI
import TMDb

struct TopRatedMovies: View {
    
    @Environment(MoviesController.self) private var moviesController
    
    @Namespace private var namespace
    
    @State private var topRatedMovies: [MovieListItem] = []
    
    var body: some View {
        VStack(alignment: .center, spacing: 15){
            if !self.topRatedMovies.isEmpty {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15){
                    ForEach(self.topRatedMovies.prefix(10)) { topRatedMovie in
                        NavigationLink {
                            MovieView(targetId: topRatedMovie.id)
                                .navigationTransition(.zoom(sourceID: "zoom", in: self.namespace))
                        } label: {
                            VStack{
                                ImageLoader(imageUrl: topRatedMovie.posterPath)
                                    .scaledToFit()
                                    .frame(height: 250)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            //              .animation(.bouncy, value: self.showAllMovies)
                        }
                        
                    }
                }
            } else {
                Text("No movie found on the database")
            }
        }
        .frame(width: 350)
        .task {
            if let movies = await self.moviesController.fetchTopRatedMovies() {
                self.topRatedMovies = movies
            }
        }
    }
}
//
//#Preview {
//    TopRatedMovies()
//}
