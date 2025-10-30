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
            Color(red: 40/250, green: 40/250, blue: 40/250)
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
                            .foregroundStyle(.white)
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
                                    ImageLoader(imageUrl: favoriteMovie.posterPath)
                                        .scaledToFit()
                                        .frame(height: 250)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                            }
                        }
                    }
                    /* - */
                }
                .frame(width: 350)
                /* - */
            }
            .padding()
        }
        .tint(.red)
        .onAppear{
            self.dataController.fetchData()
        }
    }
}

//#Preview {
//    FavoritesView()
//}
