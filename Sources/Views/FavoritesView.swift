//
//  FavoritesView.swift
//  Movix
//
//  Created by Viranaiken Jessy on 28/10/25.
//

import SwiftUI

struct FavoritesView: View {
    
    @Environment(DataController.self) private var dataController
    @Environment(MoviesController.self) private var moviesController
    
    @Namespace private var namespace
    
    var body: some View {
        ZStack{
            MovixTheme.background
                .ignoresSafeArea(.all)
            ScrollView{
                VStack(alignment: .leading, spacing: 15){
                    /* Header */
                    VStack(alignment: .leading, spacing: 0){
                        Rectangle()
                            .frame(width: 50, height: 4)
                            .foregroundStyle(LinearGradient(colors: [.red, .white], startPoint: .leading, endPoint: .trailing))
                        Text("Favorites")
                            .font(.largeTitle)
                            .foregroundStyle(MovixTheme.primaryText)
                            .bold()
                    }
                    /* - */
                    /* TopRatedMovies */
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15){
                        ForEach(self.dataController.favoriteMovies) { favoriteMovie in
                            NavigationLink {
                                MovieView(targetId: favoriteMovie.id)
                                    .navigationTransition(.zoom(sourceID: "zoom", in: self.namespace))
                            } label: {
                                VStack{
                                    ImageLoader(imageUrl: favoriteMovie.posterPath ?? favoriteMovie.backdropPath)
                                        .scaledToFit()
                                        .frame(height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .movixGlass(cornerRadius: 8.0, interactive: true)
                                }
                            }
                            .transition(.scale(scale: 0.92).combined(with: .opacity))
                        }
                    }
                    .animation(.bouncy(duration: 0.55), value: self.dataController.favoriteMovies.count)
                    /* - */
                }
                .frame(width: 350)
                /* - */
            }
            .padding()
        }
        .tint(.red)
        .task {
            await self.dataController.loadFavoriteMovies(using: self.moviesController)
        }
    }
}

//#Preview {
//    FavoritesView()
//}
