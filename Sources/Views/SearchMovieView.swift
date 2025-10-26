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
    
    private func getSearchedMovies() async {
        guard !self.query.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.searchedMovies = []
            return
        }
        
        if let movies = await self.moviesController.fetchMovieByName(name: self.query) {
            self.searchedMovies = movies
        }
    }
    
    var body: some View {
        ZStack{
            Color(red: 40/250, green: 40/250, blue: 40/250)
                .ignoresSafeArea(.all)
            /* SerachedMovies grid */
            VStack(spacing: 20){
                if !self.searchedMovies.isEmpty {
                    ScrollView{
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15){
                            ForEach(self.searchedMovies.prefix(10)) { searchedMovie in
                                NavigationLink {
                                    MovieView(targetId: searchedMovie.id)
                                        .navigationTransition(.zoom(sourceID: "zoom", in: self.namespace))
                                } label: {
                                    VStack{
                                        ImageLoader(imageUrl: searchedMovie.posterPath)
                                            .scaledToFit()
                                            .frame(height: 250)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                } else if !self.query.isEmpty {
                    Text("No movie found on the database")
                        .foregroundStyle(.white)
                        .fontDesign(.rounded)
                } else {
                    EmptyView()
                }
            }
            .padding()
            /* - */
        }
        .task {
            await self.getSearchedMovies()
        }
        .onChange(of: query) {
            Task {
                await self.getSearchedMovies()
            }
        }
        .searchable(text: self.$query)
    }
}

//#Preview {
//    SearchMovieView()
//}
