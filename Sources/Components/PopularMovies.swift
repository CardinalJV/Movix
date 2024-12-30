//
//  PopularMovies.swift
//  Movix
//
//  Created by Jessy Viranaiken on 30/12/2024.
//

import SwiftUI
import TMDb

struct PopularMovies: View {
  
  @Environment(MoviesController.self) private var moviesController
  
  @State var movies: [MovieListItem] = []
  
    var body: some View {
      VStack{
        VStack(alignment: .leading, spacing: 0){
          Rectangle()
            .frame(width: 50, height: 4)
            .foregroundStyle(LinearGradient(colors: [.red, .white], startPoint: .leading, endPoint: .trailing))
          Text("Popular")
            .font(.largeTitle)
            .foregroundStyle(.white)
            .bold()
        }
        .frame(width: 350, alignment: .leading)
        if self.movies.isEmpty {
          Text("No movie found on the database")
        } else {
          ScrollView{
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15){
              ForEach(self.movies) { movie in
                VStack{
                  ImageLoader(imageUrl: movie.posterPath)
                    .scaledToFit()
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                }
              }
            }
          }
        }
      }
      .frame(width: 350)
      .task {
        if let movies = await moviesController.fetchPopularMovies() {
          self.movies = movies
        }
      }
    }
}

#Preview {
  
  @Previewable var moviesController = MoviesController()
  
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
    .environment(moviesController)
}
