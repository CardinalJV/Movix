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
  
  @Namespace private var namespace
  
  @State private var showAllMovies = false
  @State private var movies: [MovieListItem] = []
  
  var body: some View {
    VStack(alignment: .center, spacing: 15){
      /* Title */
      VStack(alignment: .leading, spacing: 0){
        Rectangle()
          .frame(width: 50, height: 4)
          .foregroundStyle(LinearGradient(colors: [.red, .white], startPoint: .leading, endPoint: .trailing))
        Text("Populaires")
          .font(.largeTitle)
          .foregroundStyle(.white)
          .bold()
      }
      .frame(width: 350, alignment: .leading)
      /* - */
      if self.movies.isEmpty {
        Text("No movie found on the database")
      } else {
        /* Grid */
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15){
          ForEach(self.movies.prefix(self.showAllMovies ? self.movies.count : 10)) { movie in
            NavigationLink {
              MovieView(id: movie.id)
                .navigationTransition(.zoom(sourceID: "zoom", in: self.namespace))
            } label: {
              VStack{
                ImageLoader(imageUrl: movie.posterPath)
                  .scaledToFit()
                  .frame(height: 250)
                  .clipShape(RoundedRectangle(cornerRadius: 5))
              }
              .animation(.bouncy, value: self.showAllMovies)
            }

          }
        }
        // Show more/less
        Button {
          self.showAllMovies.toggle()
        } label: {
          HStack{
            Image(systemName: (self.showAllMovies ? "arrow.up.square.fill" : "arrow.down.square.fill"))
              .tint(.white)
              .bold()
              .animation(.bouncy, value: self.showAllMovies)
            Text(self.showAllMovies ? "Voir moins" : "Voir plus")
              .bold()
              .foregroundStyle(.white)
            Image(systemName: (self.showAllMovies ? "arrow.up.square.fill" : "arrow.down.square.fill"))
              .tint(.white)
              .bold()
              .animation(.bouncy, value: self.showAllMovies)
            
          }
          .frame(width: 350, height: 50)
          .background(.red, in: RoundedRectangle(cornerRadius: 5))
        }
        /* - */
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
