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
    @State private var popularMovies: [MovieListItem] = []
    
    var body: some View {
        VStack(alignment: .center, spacing: 15){
            /* Title */
            VStack(alignment: .leading, spacing: 0){
                Rectangle()
                    .frame(width: 50, height: 4)
                    .foregroundStyle(LinearGradient(colors: [.red, .white], startPoint: .leading, endPoint: .trailing))
                Text("Populars")
                    .font(.largeTitle)
                    .foregroundStyle(MovixTheme.primaryText)
                    .bold()
            }
            .frame(width: 350, alignment: .leading)
            /* - */
            /* Popular grid movies */
            if !self.popularMovies.isEmpty {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
                    ForEach(self.popularMovies.prefix(self.showAllMovies ? self.popularMovies.count : 10)) { popularMovie in
                        NavigationLink {
                            MovieView(targetId: popularMovie.id)
                                .navigationTransition(.zoom(sourceID: "zoom", in: self.namespace))
                        } label: {
                            VStack{
                                ImageLoader(imageUrl: popularMovie.posterPath ?? popularMovie.backdropPath)
                                    .scaledToFit()
                                    .frame(height: 250)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .movixGlass(cornerRadius: 8.0, interactive: true)
                            }
                        }
                        .transition(.scale(scale: 0.92).combined(with: .opacity))
                    }
                }
                .animation(.bouncy(duration: 0.55), value: self.popularMovies.count)
                .animation(.bouncy(duration: 0.55), value: self.showAllMovies)
                Button {
                    withAnimation(.bouncy(duration: 0.55)) {
                        self.showAllMovies.toggle()
                    }
                } label: {
                    HStack{
                        Image(systemName: (self.showAllMovies ? "arrow.up.square.fill" : "arrow.down.square.fill"))
                            .tint(.white)
                            .bold()
                            .contentTransition(.symbolEffect(.replace))
                        Text(self.showAllMovies ? "Voir moins" : "Voir plus")
                            .bold()
                            .foregroundStyle(.white)
                            .contentTransition(.opacity)
                        Image(systemName: (self.showAllMovies ? "arrow.up.square.fill" : "arrow.down.square.fill"))
                            .tint(.white)
                            .bold()
                            .contentTransition(.symbolEffect(.replace))
                        
                    }
                    .frame(width: 350, height: 50)
                    .movixProminentGlass(cornerRadius: 12.0, interactive: true)
                }
            } else {
                Text("No movie found on the database")
            }
            /* - */
        }
        .frame(width: 350)
        /* Task */
        .task {
            if let movies = await self.moviesController.fetchPopularMovies() {
                withAnimation(.bouncy(duration: 0.55)) {
                    self.popularMovies = movies
                }
            }
        }
        /* - */
    }
}
