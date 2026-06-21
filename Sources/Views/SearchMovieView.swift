//
//  SearchMovieView.swift
//  Movix
//
//  Created by Viranaiken Jessy on 26/10/25.
//

import SwiftUI
import TMDb

struct SearchMovieView: View {
    
    @Environment(MoviesController.self) private var moviesController
    
    @Namespace private var namespace
    
    @State private var query: String = ""
    @State private var searchedMovies: [MovieListItem] = []
    
    private var trimmedQuery: String {
        self.query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func getSearchedMovies() async {
        guard !self.trimmedQuery.isEmpty else {
            withAnimation(.bouncy(duration: 0.35)) {
                self.searchedMovies = []
            }
            return
        }
        
        if let movies = await self.moviesController.fetchMovieByName(name: self.trimmedQuery) {
            withAnimation(.bouncy(duration: 0.55)) {
                self.searchedMovies = movies
            }
        }
    }
    
    var body: some View {
        ZStack {
            MovixTheme.background
                .ignoresSafeArea()
            
            if self.trimmedQuery.isEmpty {
                VStack(spacing: 8.0) {
                    Text("Type something below to search for a movie")
                    Image(systemName: "arrow.down")
                }
                .font(.callout)
                .foregroundStyle(MovixTheme.secondaryText)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 20.0) {
                        if !self.searchedMovies.isEmpty {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 15),
                            GridItem(.flexible(), spacing: 15)
                        ], spacing: 15) {
                            ForEach(self.searchedMovies.prefix(10)) { searchedMovie in
                                NavigationLink {
                                    MovieView(targetId: searchedMovie.id)
                                        .navigationTransition(.zoom(sourceID: "zoom", in: self.namespace))
                                } label: {
                                    ImageLoader(imageUrl: searchedMovie.posterPath ?? searchedMovie.backdropPath)
                                        .scaledToFit()
                                        .frame(height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .movixGlass(cornerRadius: 8.0, interactive: true)
                                }
                                .transition(.scale(scale: 0.92).combined(with: .opacity))
                            }
                        }
                        .animation(.bouncy(duration: 0.55), value: self.searchedMovies.count)
                    } else {
                        Text("No movie found on the database")
                            .foregroundStyle(MovixTheme.secondaryText)
                            .fontDesign(.rounded)
                    }
                    }
                    .frame(width: 350)
                    .padding(.vertical)
                }
            }
        }
        .searchable(text: self.$query, placement: .toolbar, prompt: "Search movie")
        .searchPresentationToolbarBehavior(.avoidHidingContent)
        .font(.system(.body, design: .rounded))
        .task {
            await self.getSearchedMovies()
        }
        .onChange(of: query) {
            Task {
                await self.getSearchedMovies()
            }
        }
    }
}

//#Preview {
//    SearchMovieView()
//}
