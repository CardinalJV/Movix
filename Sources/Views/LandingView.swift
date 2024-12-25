  //
  //  ContentView.swift
  //  Movix
  //
  //  Created by Jessy Viranaiken on 16/12/2024.
  //

import SwiftUI
import SwiftData

struct ContentView: View {
  
  @Environment(MoviesController.self) private var moviesController
  @State private var posters: [URL] = []
  @State private var index: Int = 0
  
  var body: some View {
    NavigationStack{
      ZStack{
        Color(red: 40/250, green: 40/250, blue: 40/250)
          .ignoresSafeArea(.all)
        VStack{
          if self.posters.isEmpty{
            Text("Chargement en cours")
          } else {
            ImageLoader(imageUrl: self.posters[self.index])
              .scaledToFit()
              .opacity(0.25)
              .overlay(alignment: .center){
                VStack(spacing: 10){
                  /* Text */
                  VStack(alignment: .leading){
                    HStack{
                      Rectangle()
                        .frame(width: 50, height: 4)
                        .foregroundStyle(LinearGradient(colors: [.red, .white], startPoint: .leading, endPoint: .trailing))
                      Text("Plus jamais a court d'idées")
                        .foregroundStyle(.red)
                        .bold()
                    }
                    Text("Le film parfait en quelques clics")
                      .font(.title)
                      .bold()
                    Text("Action, comédie, drame ou science-fiction ? Découvrez des films qui correspondent à vos envies du moment.")
                      .font(.title3)
                  }
                  /* - */
                  /* Button */
                  VStack{
                    Button {
                      
                    } label: {
                      HStack{
                        Text("Trouver mon film")
                        Image(systemName: "magnifyingglass")
                      }
                      .frame(width: 350, height: 50)
                      .background(Color(red: 40/250, green: 40/250, blue: 40/250).opacity(0.75))
                      .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    Button {
                      
                    } label: {
                      HStack{
                        Text("Film les mieux notés")
                        Image(systemName: "star")
                      }
                      .frame(width: 350, height: 50)
                      .background(.ultraThinMaterial.opacity(0.25))
                      .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                  }
                  /* - */
                }
                .padding()
                .foregroundStyle(.white)
              }
          }
          Spacer()
        }
      }
      /* Toolbar */
      .toolbar{
        ToolbarItem(placement: .topBarLeading) {
          HStack{
            Image(systemName: "popcorn")
              .font(.title3)
              .foregroundStyle(.red)
            HStack(spacing: 0){
              Text("Mov")
                .foregroundStyle(.white)
              Text("ix")
                .foregroundStyle(.red)
                .shadow(color: .red, radius: 10)
            }
            .font(.title)
            .bold()
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            
          } label: {
            Image(systemName: "heart")
              .font(.title3)
              .foregroundStyle(.red)
              .bold()
          }

        }
      }
      /* - */
      .onAppear{
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
          if self.index < self.posters.count - 1 {
            self.index += 1
          } else {
            self.index = 0
          }
        }
      }
      .task {
        await moviesController.fetchMoviesListsItems(page: 1)
        for item in moviesController.moviesListsItems {
          if let posterPath = item.posterPath {
            self.posters.append(posterPath)
          }
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
