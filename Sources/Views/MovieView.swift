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
        GeometryReader{ geo in
            ScrollView{
                VStack(spacing: 0){
                    if let movie = self.movie {
                        if let posterPath = movie.posterPath, let backdropPath = movie.backdropPath {
                            ZStack{
                                ZStack{
                                    /* BackPoster */
                                    ImageLoader(imageUrl: backdropPath)
                                        .frame(width: geo.size.width, height: geo.size.height * 0.30)
                                        .opacity(0.75)
                                        .overlay(alignment: .center){
                                            HStack{
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
                                            //                                            .border(.white)
                                        }
                                    /* - */
                                    /* Main poster */
                                    ImageLoader(imageUrl: posterPath)
                                        .position(x: geo.size.width * 0.25, y: geo.size.height * 0.35)
                                        .frame(width: geo.size.width / 2, height: geo.size.height * 0.35)
                                        .shadow(radius: 10)
                                    /* - */
                                }
                                .frame(width: geo.size.width, height: geo.size.height * 0.10)
                            }
                            .frame(width: geo.size.width, height: geo.size.height * 0.425, alignment: .top)
                        }
                        VStack(spacing: 10){
                            /* Title */
                            Text(movie.title)
                                .bold()
                                .foregroundStyle(.white)
                                .fontDesign(.rounded)
                                .font(.title)
                                .multilineTextAlignment(.center)
                            /* - */
                            /* Genres */
                            if let genres = movie.genres {
                                HStack{
                                    ForEach(genres) { genre in
                                        HStack(spacing: 0){
                                            Text("#")
                                                .bold()
                                                .foregroundStyle(.red)
                                            Text(genre.name)
                                        }
                                    }
                                }
                                .foregroundStyle(.white)
                                .fontDesign(.rounded)
                            }
                            /* - */
                            /* SpokenLanguages */
                            if let spokenLanguages = movie.spokenLanguages {
                                HStack{
                                    ForEach(spokenLanguages) { language in
                                        Text(language.name)
                                            .bold()
                                            .padding(6)
                                            .font(.subheadline)
                                            .foregroundStyle(.white)
                                            .background{
                                                RoundedRectangle(cornerRadius: 6)
                                                    .fill(.red)
                                            }
                                    }
                                }
                            }
                            /* - */
                            /* Overview */
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(red: 40/250, green: 40/250, blue: 40/250))
                                    .shadow(color: Color(red: 90/250, green: 90/250, blue: 90/250), radius: 25)
                                    .blur(radius: 1)
                                if let overview = movie.overview {
                                    Text(overview)
                                        .padding()
                                        .cornerRadius(12)
                                        .foregroundStyle(.white)
                                        .font(.callout)
                                } else {
                                    Text("Overview not available")
                                        .padding()
                                        .cornerRadius(12)
                                        .foregroundStyle(.white)
                                        .font(.callout)
                                }
                            }
                            /* - */
                            /* Rating */
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(red: 40/250, green: 40/250, blue: 40/250))
                                    .shadow(color: Color(red: 90/250, green: 90/250, blue: 90/250), radius: 25)
                                    .blur(radius: 1)
                                HStack{
                                    Text("Rating")
                                    Spacer()
                                    if let voteAverage = movie.voteAverage {
                                        CircularProgressView(value: voteAverage)
                                    }
                                }
                                .foregroundStyle(.white)
                                .padding()
                            }
                            /* - */
                            /* Runtime */
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(red: 40/250, green: 40/250, blue: 40/250))
                                    .shadow(color: Color(red: 90/250, green: 90/250, blue: 90/250), radius: 25)
                                    .blur(radius: 1)
                                HStack{
                                    if let runtime = movie.runtime {
                                        Text("Durée")
                                        Spacer()
                                        Text(String(runtime) + " minutes")
                                    }
                                }
                                .padding()
                                .foregroundStyle(.white)
                                .fontDesign(.rounded)
                            }
                            /* - */
                            /* Production companies */
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(red: 40/250, green: 40/250, blue: 40/250))
                                    .shadow(color: Color(red: 90/250, green: 90/250, blue: 90/250), radius: 25)
                                    .blur(radius: 1)
                                HStack{
                                    Text("Production companies")
                                        .fontDesign(.rounded)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    VStack{
                                        if let productionCompanies = movie.productionCompanies {
                                            ForEach(productionCompanies) { company in
                                                Text(company.name)
                                                    .fontDesign(.rounded)
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                    }
                                }
                                .padding()
                            }
                            /* - */
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(red: 40/250, green: 40/250, blue: 40/250))
                                    .shadow(color: Color(red: 90/250, green: 90/250, blue: 90/250), radius: 25)
                                    .blur(radius: 1)
                                HStack{
                                    Text("Budget")
                                        .fontDesign(.rounded)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    if let budget = movie.budget {
                                        Text("\(budget) $")
                                            .fontDesign(.rounded)
                                            .foregroundStyle(.white)
                                    }
                                    
                                }
                                .padding()
                            }
                        }
                        /* - */
                        .padding()
                        /* - */
                    }
                }
                .navigationBarBackButtonHidden(true)
                .task {
                    if let movie = await moviesController.fetchMovie(byId: self.id) {
                        self.movie = movie
                    }
                }
            }
            .background(content: {
                Color(red: 40/250, green: 40/250, blue: 40/250)
                    .ignoresSafeArea(.all)
            })
        }
    }
}

#Preview {
    
    @Previewable var moviesController = MoviesController()
    
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
        .environment(moviesController)
}
