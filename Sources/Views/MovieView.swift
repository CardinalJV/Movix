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
                            }
                            .position(x: geo.size.width * 0.5, y: geo.size.height * -0.01)
                            .frame(width: geo.size.width, height: geo.size.height * 0.375, alignment: .top)
                        }
                        /* - */
                        VStack(spacing: 10){
                            /* Title */
                            if !movie.title.isEmpty {
                                Text(movie.title)
                                    .bold()
                                    .foregroundStyle(.white)
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
                                            .bold()
                                        Spacer()
                                        CircularProgressView(value: voteAverage)
                                    }
                                    .padding()
                                    .foregroundStyle(.white)
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
                                    VStack(alignment: .leading, spacing: 10){
                                        Text("Overview")
                                            .bold()
                                        Text(overview)
                                            .font(.callout)
                                    }
                                    .padding()
                                    .foregroundStyle(.white)
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
                                        Text("Duration")
                                            .bold()
                                        Spacer()
                                        Text(String(runtime) + " minutes")
                                    }
                                    .padding()
                                    .foregroundStyle(.white)
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
                                            .bold()
                                        Spacer()
                                        VStack{
                                            ForEach(productionCompanies) { company in
                                                Text(company.name)
                                            }
                                        }
                                    }
                                    .padding()
                                    .foregroundStyle(.white)
                                }
                            }
                            /* - */
                            /* Budget */
                            if let budget = movie.getFormattedBudget() {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(red: 40/250, green: 40/250, blue: 40/250))
                                        .shadow(color: Color(red: 90/250, green: 90/250, blue: 90/250), radius: 25)
                                        .blur(radius: 1)
                                    HStack{
                                        Text("Budget")
                                            .bold()
                                        Spacer()
                                        Text(budget)
                                    }
                                    .padding()
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.white)
                                }
                            }
                            /* - */
                            /* Web Site */
                            if let homepage = movie.homepageURL {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(red: 40/250, green: 40/250, blue: 40/250))
                                        .shadow(color: Color(red: 90/250, green: 90/250, blue: 90/250), radius: 25)
                                        .blur(radius: 1)
                                    HStack{
                                        Text("Release date")
                                            .bold()
                                        Spacer()
                                        Text("\(homepage.absoluteString)")
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding()
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.white)
                                }
                            }
                            /* - */
                            /* Youtube video */
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
        .fontDesign(.rounded)
    }
}

#Preview {
    
    @Previewable var moviesController = MoviesController()
    
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
        .environment(moviesController)
}
