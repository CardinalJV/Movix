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
                                                .bold()
                                                .background(Color(red: 40/250, green: 40/250, blue: 40/250).opacity(0.75), in: RoundedRectangle(cornerRadius: 5))
                                            }
                                            NavigationLink(destination: {
                                                
                                            }, label: {
                                                HStack{
                                                    Text("Film les mieux notés")
                                                    Image(systemName: "star")
                                                }
                                                .frame(width: 350, height: 50)
                                                .bold()
                                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5))
                                            }
                                        )}
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
                        Button {
                            
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
                }
                .onDisappear{
                    self.stopCaroussel()
                }
                .task {
                    await moviesController.fetchMoviesListsItems(page: 1)
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
