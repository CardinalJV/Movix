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
                    Color(red: 40/250, green: 40/250, blue: 40/250)
                        .ignoresSafeArea(.all)
                    ScrollView{
                        VStack(spacing: 30){
                            /* Posters */
                            if moviesController.posters.isEmpty{
                                Text("Chargement en cours")
                            } else {
                                ImageLoader(imageUrl: moviesController.posters[self.index])
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
                                                    Text("Never run out of ideas again")
                                                        .foregroundStyle(.red)
                                                        .bold()
                                                }
                                                Text("The perfect movie in just a few clicks")
                                                    .font(.title)
                                                    .bold()
                                                Text("Action, comedy, drama, or science fiction? Discover films that match your current interests.")
                                                    .font(.title3)
                                            }
                                            .padding(1)
                                            /* - */
                                            /* Button */
                                            VStack{
                                                NavigationLink {
                                                    SearchMovieView()
                                                } label: {
                                                    HStack{
                                                        Text("Find my movie")
                                                        Spacer()
                                                        Image(systemName: "magnifyingglass")
                                                    }
                                                    .padding()
                                                    .frame(width: .infinity, height: 50)
                                                    .bold()
                                                    .background(Color(red: 40/250, green: 40/250, blue: 40/250).opacity(0.75), in: RoundedRectangle(cornerRadius: 5))
                                                }
                                                NavigationLink {
                                                    TopRatedView()
                                                } label: {
                                                    HStack{
                                                        Text("Top Rated Movies")
                                                        Spacer()
                                                        Image(systemName: "star")
                                                    }
                                                    .padding()
                                                    .frame(width: .infinity, height: 50)
                                                    .bold()
                                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5))
                                                }
                                            }
                                            .padding(5)
                                            /* - */
                                        }
                                        .padding()
                                        .foregroundStyle(.white)
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
                        }
                        .sharedBackgroundVisibility(.hidden)
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                FavoritesView()
                            } label: {
                                Image(systemName: "heart.fill")
                                    .font(.title3)
                                    .foregroundStyle(.red)
                                    .bold()
                            }
                        }
                        .sharedBackgroundVisibility(.hidden)
                    }
                    .toolbarTitleDisplayMode(.inline)
                    /* - */
                    .onAppear{
                        self.startCarroussel()
                        self.dataController.context = self.context
                    }
                    .onDisappear{
                        self.stopCaroussel()
                    }
                    .task {
                        await moviesController.fetchMoviesListsItems(page: 1)
                        if self.dataController.context != nil {
                            for item in self.dataController.dataItems {
                                if let movie = await self.moviesController.fetchMovie(byId: item.targetId ) {
                                    self.dataController.favoriteMovies.append(movie)
                                }
                            }
                        }
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
