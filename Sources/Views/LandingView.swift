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
    @Environment(DataController.self) private var dataController
    @Environment(\.modelContext) var context: ModelContext
    
    @State private var index: Int = 0
    @State private var timer: Timer? = nil
    
    private func startCarroussel() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            self.index = (self.index + 1) % moviesController.posters.count
        }
    }
    
    private func stopCaroussel() {
        self.timer?.invalidate()
    }
    
    var body: some View {
        NavigationStack{
                ZStack{
                    MovixTheme.background
                        .ignoresSafeArea(.all)
                    ScrollView{
                        VStack(spacing: 30){
                            /* Posters */
                            if moviesController.posters.isEmpty{
                                Text("Chargement en cours")
                            } else {
                                ImageLoader(imageUrl: moviesController.posters[self.index])
                                    .scaledToFit()
                                    .overlay(alignment: .center){
                                        VStack(spacing: 18){
                                            /* Text */
                                            VStack(alignment: .leading, spacing: 8){
                                                HStack{
                                                    Rectangle()
                                                        .frame(width: 50, height: 4)
                                                        .foregroundStyle(LinearGradient(colors: [.red, .white], startPoint: .leading, endPoint: .trailing))
                                                    Text("Never run out of ideas again")
                                                        .foregroundStyle(MovixTheme.accent)
                                                        .bold()
                                                }
                                                Text("The perfect movie in just a few clicks")
                                                    .font(.title2)
                                                    .bold()
                                                Text("Action, comedy, drama, or science fiction? Discover films that match your current interests.")
                                                    .font(.callout)
                                                    .foregroundStyle(MovixTheme.secondaryText)
                                                    .lineSpacing(3)
                                            }
                                            /* - */
                                            /* Button */
                                            VStack(spacing: 10){
                                                NavigationLink {
                                                    SearchMovieView()
                                                } label: {
                                                    HStack{
                                                        Text("Find my movie")
                                                        Spacer()
                                                        Image(systemName: "magnifyingglass")
                                                    }
                                                    .padding()
                                                    .frame(maxWidth: .infinity, minHeight: 50)
                                                    .bold()
                                                    .foregroundStyle(.white)
                                                    .movixProminentGlass(cornerRadius: 12.0, interactive: true)
                                                }
                                                NavigationLink {
                                                    TopRatedView()
                                                } label: {
                                                    HStack{
                                                        Text("Top Rated Movies")
                                                        Spacer()
                                                        Image(systemName: "star.fill")
                                                    }
                                                    .padding()
                                                    .frame(maxWidth: .infinity, minHeight: 50)
                                                    .bold()
                                                    .movixGlass(cornerRadius: 12.0, interactive: true)
                                                }
                                            }
                                            .padding(5)
                                            /* - */
                                        }
                                        .padding(20)
                                        .foregroundStyle(.primary)
                                        .movixClearGlass(cornerRadius: 20.0)
                                        .padding(.horizontal, 16.0)
                                    }
                            }
                            /* - */
                            /* Popular */
                            PopularMovies()
                            /* - */
                            Spacer()
                        }
                    }
                    /* Toolbar */
                    .toolbar {
                        ToolbarItem(placement: .title) {
                            GlowingAnimation()
                                .padding(.horizontal, 12.0)
                                .padding(.vertical, 6.0)
                        }
                        .sharedBackgroundVisibility(.hidden)
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                FavoritesView()
                            } label: {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.red)
                                    .bold()
                            }
                        }
                    }
                    .toolbarTitleDisplayMode(.inline)
                    /* - */
                    .onAppear{
                        self.startCarroussel()
                        self.dataController.configure(context: self.context)
                    }
                    .onDisappear{
                        self.stopCaroussel()
                    }
                    .task {
                        await moviesController.fetchMoviesListsItems(page: 1)
                        await self.dataController.loadFavoriteMovies(using: self.moviesController)
                    }
                }
        }
    }
}

#Preview {
    
    @Previewable var moviesController = MoviesController()
    @Previewable var dataController = DataController()
    
    ContentView()
        .modelContainer(for: DataItem.self, inMemory: true)
        .environment(moviesController)
        .environment(dataController)
}
