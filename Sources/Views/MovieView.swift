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
    @Environment(DataController.self) private var dataController
    @Environment(\.dismiss) private var dismiss
    
    @State private var movie: Movie? = nil
    @State private var trailerURL: URL? = nil
    @State private var watchProvider: ShowWatchProvider? = nil
    @State private var isTrailerPresented: Bool = false
    
    let targetId: Int
    
    private var currentRegionCode: String {
        Locale.current.region?.identifier ?? "US"
    }
    
    private func glassCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(MovixTheme.primaryText)
            .movixGlass(cornerRadius: 16.0)
    }
    
    private func availableProviders(from watchProvider: ShowWatchProvider) -> [WatchProvider] {
        var insertedIds = Set<Int>()
        let providers = (watchProvider.flatRate ?? [])
            + (watchProvider.free ?? [])
            + (watchProvider.rent ?? [])
            + (watchProvider.buy ?? [])
        
        return providers.filter { provider in
            insertedIds.insert(provider.id).inserted
        }
    }
    
    var body: some View {
        GeometryReader{ geo in
            if let movie = self.movie {
                ScrollView{
                    VStack(spacing: 0){
                        /* Posters */
                        if let backdropPath = movie.backdropPath ?? movie.posterPath {
                            let backdropHeight = geo.size.height * 0.30
                            let posterWidth = min(geo.size.width * 0.46, 180.0)
                            let posterHeight = posterWidth * 1.5
                            
                            ZStack(alignment: .top) {
                                /* BackPoster */
                                ImageLoader(imageUrl: backdropPath)
                                    .frame(width: geo.size.width, height: backdropHeight)
                                    .clipped()
                                /* - */
                                /* Main poster */
                                if let posterPath = movie.posterPath ?? movie.backdropPath {
                                    ImageLoader(imageUrl: posterPath)
                                        .frame(width: posterWidth, height: posterHeight)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .shadow(radius: 10)
                                        .offset(y: backdropHeight - (posterHeight / 2))
                                }
                                /* - */
                            }
                            .frame(width: geo.size.width, height: backdropHeight + (posterHeight / 2), alignment: .top)
                        }
                        /* - */
                        VStack(spacing: 10){
                            /* Title */
                            if !movie.title.isEmpty {
                                Text(movie.title)
                                    .bold()
                                    .foregroundStyle(MovixTheme.primaryText)
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
                                                .foregroundStyle(MovixTheme.accent)
                                            Text(genre.name)
                                        }
                                    }
                                }
                                .foregroundStyle(MovixTheme.primaryText)
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
                                            .movixProminentGlass(cornerRadius: 8.0)
                                    }
                                }
                            }
                            /* - */
                            /* Rating */
                            if let voteAverage = movie.voteAverage {
                                glassCard {
                                    HStack{
                                        Text("Rating")
                                            .bold()
                                        Spacer()
                                        CircularProgressView(value: voteAverage)
                                    }
                                }
                            }
                            /* - */
                            /* Overview */
                            if let overview = movie.overview, !overview.isEmpty {
                                glassCard {
                                    VStack(alignment: .leading, spacing: 10){
                                        Text("Overview")
                                            .bold()
                                        Text(overview)
                                            .font(.callout)
                                    }
                                }
                            }
                            /* - */
                            /* Runtime */
                            if let runtime = movie.runtime {
                                glassCard {
                                    HStack{
                                        Text("Duration")
                                            .bold()
                                        Spacer()
                                        Text(String(runtime) + " minutes")
                                    }
                                }
                            }
                            /* - */
                            /* Production companies */
                            if let productionCompanies = movie.productionCompanies, !productionCompanies.isEmpty {
                                glassCard {
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
                                }
                            }
                            /* - */
                            /* Budget */
                            if let budget = movie.getFormattedBudget() {
                                glassCard {
                                    HStack{
                                        Text("Budget")
                                            .bold()
                                        Spacer()
                                        Text(budget)
                                    }
                                    .fontDesign(.rounded)
                                }
                            }
                            /* - */
                            /* Web Site */
                            if let homepage = movie.homepageURL {
                                glassCard {
                                    HStack{
                                        Text("Website")
                                            .bold()
                                        Spacer()
                                        Text("\(homepage.absoluteString)")
                                            .multilineTextAlignment(.leading)
                                    }
                                    .fontDesign(.rounded)
                                }
                            }
                            /* - */
                            /* Watch Providers */
                            if let watchProvider = self.watchProvider {
                                let providers = self.availableProviders(from: watchProvider)
                                
                                if !providers.isEmpty {
                                    glassCard {
                                        VStack(alignment: .leading, spacing: 12.0) {
                                            HStack {
                                                Text("Available on")
                                                    .bold()
                                                Spacer()
                                                Text(self.currentRegionCode)
                                                    .font(.caption)
                                                    .foregroundStyle(MovixTheme.secondaryText)
                                            }
                                            
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: 12.0) {
                                                    ForEach(providers) { provider in
                                                        VStack(spacing: 6.0) {
                                                            ImageLoader(imageUrl: provider.logoPath)
                                                                .frame(width: 48.0, height: 48.0)
                                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                            
                                                            Text(provider.name)
                                                                .font(.caption2)
                                                                .lineLimit(1)
                                                        }
                                                        .frame(width: 64.0)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            /* - */
                            /* Trailer */
                            if self.trailerURL != nil {
                                Button {
                                    self.isTrailerPresented = true
                                } label: {
                                    HStack {
                                        Text("Watch trailer on Youtube")
                                            .bold()
                                        Spacer()
                                        Image(systemName: "play.fill")
                                    }
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(MovixTheme.accent, in: RoundedRectangle(cornerRadius: 16.0))
                            }
                            /* - */
                            /* Release date */
                            /* - */
                        }
                        /* - */
                        .padding()
                        /* - */
                    }
                }
                .ignoresSafeArea(edges: .top)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            self.dataController.isInFavorites(movieId: movie.id) ? self.dataController.deleteToFavorite(movieId: movie.id) : self.dataController.addInFavorites(movie: movie)
                        } label: {
                            self.dataController.isInFavorites(movieId: movie.id) ?
                            Image(systemName: "heart.fill") :
                            Image(systemName: "heart")
                        }
                        .animation(.bouncy, value: self.dataController.favoriteMovies)
                    }
                }
            } else {
                ProgressView()
            }
        }
        .fontDesign(.rounded)
        .movixAppBackground()
        .task {
            if let movie = await moviesController.fetchMovie(byId: self.targetId) {
                self.movie = movie
            }
            self.watchProvider = await moviesController.fetchMovieWatchProviders(
                byId: self.targetId,
                country: self.currentRegionCode
            )
            self.trailerURL = await moviesController.fetchMovieTrailerURL(byId: self.targetId)
        }
        .sheet(isPresented: self.$isTrailerPresented) {
            if let trailerURL = self.trailerURL {
                SafariView(url: trailerURL)
            }
        }
    }
}
//
//#Preview {
//
//    @Previewable var moviesController = MoviesController()
//
//    ContentView()
//        .modelContainer(for: DataItem.self, inMemory: true)
//        .environment(moviesController)
//}
