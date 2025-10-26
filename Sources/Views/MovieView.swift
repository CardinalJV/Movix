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
    
    let targetId: Int
    
    var body: some View {
        GeometryReader{ geo in
            ScrollView{
                VStack(spacing: 0){
                    if let movie = self.movie {
                        /* Posters */
                        if let posterPath = movie.posterPath, let backdropPath = movie.backdropPath {
                            ZStack{
                                ZStack{
                                    /* BackPoster */
                                    ImageLoader(imageUrl: backdropPath)
                                        .frame(width: geo.size.width, height: geo.size.height * 0.30)
                                        .opacity(0.75)
                                    /* - */
                                    /* Main poster */
                                    ImageLoader(imageUrl: posterPath)
                                        .position(x: geo.size.width * 0.25, y: geo.size.height * 0.35)
                                        .frame(width: geo.size.width / 2, height: geo.size.height * 0.35)
                                        .shadow(radius: 10)
                                    /* - */
                                }
                                .frame(width: geo.size.width, height: geo.size.height * 0.10)
                                //                                .border(.green)
                            }
                            .position(x: geo.size.width * 0.5, y: geo.size.height * -0.01)
                            .frame(width: geo.size.width, height: geo.size.height * 0.375, alignment: .top)
                            //                            .border(.red)
                        }
                        /* - */
                        VStack(spacing: 10){
                            /* Title */
                            if !movie.title.isEmpty {
                                Text(movie.title)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .fontDesign(.rounded)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            /* - */
                            /* Genres */
                            if let genres = movie.genres, !genres.isEmpty {
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
                            if let spokenLanguages = movie.spokenLanguages, !spokenLanguages.isEmpty {
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
                            /* Rating */
                            if let voteAverage = movie.voteAverage {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(red: 40/250, green: 40/250, blue: 40/250))
                                        .shadow(color: Color(red: 90/250, green: 90/250, blue: 90/250), radius: 25)
                                        .blur(radius: 1)
                                    HStack{
                                        Text("Rating")
                                        Spacer()
                                        CircularProgressView(value: voteAverage)
                                    }
                                    .foregroundStyle(.white)
                                    .padding()
                                }
                            }
                            /* - */
                            /* Overview */
                            if let overview = movie.overview, !overview.isEmpty {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(red: 40/250, green: 40/250, blue: 40/250))
                                        .shadow(color: Color(red: 90/250, green: 90/250, blue: 90/250), radius: 25)
                                        .blur(radius: 1)
                                    Text(overview)
                                        .padding()
                                        .cornerRadius(12)
                                        .foregroundStyle(.white)
                                        .font(.callout)
                                }
                            }
                            /* - */
                            /* Runtime */
                            if let runtime = movie.runtime {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(red: 40/250, green: 40/250, blue: 40/250))
                                        .shadow(color: Color(red: 90/250, green: 90/250, blue: 90/250), radius: 25)
                                        .blur(radius: 1)
                                    HStack{
                                        Text("Durée")
                                        Spacer()
                                        Text(String(runtime) + " minutes")
                                    }
                                    .padding()
                                    .foregroundStyle(.white)
                                    .fontDesign(.rounded)
                                }
                            }
                            /* - */
                            /* Production companies */
                            if let productionCompanies = movie.productionCompanies, !productionCompanies.isEmpty {
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
                                            ForEach(productionCompanies) { company in
                                                Text(company.name)
                                                    .fontDesign(.rounded)
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                    }
                                    .padding()
                                }
                            }
                            /* - */
                            /* Budget */
                            if let budget = movie.budget {
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
                                        Text("\(budget) $")
                                            .fontDesign(.rounded)
                                            .foregroundStyle(.white)
                                    }
                                    .padding()
                                }
                            }
                            /* - */
                        }
                        /* - */
                        .padding()
                        /* - */
                    }
                }
            }
            .background(content: {
                Color(red: 40/250, green: 40/250, blue: 40/250)
                    .ignoresSafeArea(.all)
            })
            .task {
                if let movie = await moviesController.fetchMovie(byId: self.targetId) {
                    self.movie = movie
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
