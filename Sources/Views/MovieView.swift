  //
  //  MovieView.swift
  //  Movix
  //
  //  Created by Jessy Viranaiken on 01/01/2025.
  //

import SwiftUI
import TMDb

struct MovieView: View {
  
  @Environment(MoviesController.self) private var moviesController
  @Environment(\.dismiss) private var dismiss
  
  @State private var movie: Movie? = nil
  
  let id: Int
  
  var body: some View {
      VStack{
        ScrollView{
        if let movie = self.movie {
          ImageLoader(imageUrl: movie.backdropPath)
            .scaledToFit()
            .opacity(0.75)
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
          VStack{
            ImageLoader(imageUrl: movie.posterPath)
              .scaledToFit()
              .frame(width: 200)
              .clipShape(RoundedRectangle(cornerRadius: 5))
              .zIndex(1)
              .shadow(radius: 10)
            Text(movie.title)
              .font(.title)
              .bold()
              .foregroundStyle(.white)
              .multilineTextAlignment(.center)
          }
          .frame(width: 350)
          .offset(y: -125)
          Spacer()
        }
      }
      .background(content: {
        Color(red: 40/250, green: 40/250, blue: 40/250)
          .ignoresSafeArea(.all)
      })
      .navigationBarBackButtonHidden(true)
      .task {
        if let movie = await moviesController.fetchMovie(byId: self.id) {
          self.movie = movie
        }
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
