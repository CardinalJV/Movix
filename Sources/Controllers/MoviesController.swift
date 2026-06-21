//
//  MoviesController.swift
//  Movix
//
//  Created by Jessy Viranaiken on 19/12/2024.
//

import TMDb
import Foundation

@Observable
class MoviesController {
    
    var moviesListsItems: [MovieListItem] = []
    var genres: [Genre] = []
    var posters: [URL] = []
//    var favoriteMovies: [Movie] = []
    
    private let apiKey = "b5d8017e240d54c376f083183218e549"
    private let client = TMDbClient(apiKey: "b5d8017e240d54c376f083183218e549")
    
    func fetchMoviesListsItems(page: Int) async {
        do {
            self.moviesListsItems = try await client.discover.movies(page: page).results
            self.getPostersForLandingView()
        } catch {
            print("Error during fetching moviesListsItems: \(error.localizedDescription)")
        }
    }
    
    func fetchMovie(byId id: Int) async -> Movie? {
        do {
            return try await self.client.movies.details(forMovie: id, language: "en")
        } catch{
            print(error)
            return nil
        }
    }
    
    func fetchPopularMovies() async -> [MovieListItem]? {
        do {
            return try await self.client.movies.popular(page: 1, language: "en").results
        } catch {
            print("Error during fetching popular movies: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchMoviesGenres() async {
        do {
            self.genres = try await client.genres.movieGenres(language: "fr")
        } catch {
            print("Error during fetching movies genre: \(error.localizedDescription)")
        }
    }
    
    private func getPostersForLandingView() {
        self.posters = []
        
        for item in self.moviesListsItems {
            if let imagePath = item.posterPath ?? item.backdropPath {
                self.posters.append(imagePath)
            }
        }
    }
    
    func fetchTopRatedMovies() async -> [MovieListItem]? {
        do {
            return try await self.client.movies.topRated(page: 1, country: "EN", language: "en").results
        } catch {
            print("Error during fetching top rated movies: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchMovieByName(name: String, filter: MovieSearchFilter? = nil) async -> [MovieListItem]? {
        do {
            return try await self.client.search.searchMovies(
                query: name,
                filter: filter,
                page: 1,
                language: "en"
            ).results
        } catch {
            print("Error during fetching top rated movies: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchMovieTrailerURL(byId id: Int) async -> URL? {
        do {
            let videos = try await self.client.movies.videos(forMovie: id)
            let youtubeVideos = videos.results.filter { $0.site == "YouTube" }
            let trailer = youtubeVideos.first { $0.type == .trailer } ?? youtubeVideos.first { $0.type == .teaser }
            
            guard let trailer else {
                return nil
            }
            
            return URL(string: "https://www.youtube.com/watch?v=\(trailer.key)")
        } catch {
            print("Error during fetching movie trailer: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchMovieWatchProviders(byId id: Int, country: String) async -> ShowWatchProvider? {
        do {
            return try await self.client.movies.watchProviders(forMovie: id, country: country)
        } catch {
            print("Error during fetching movie watch providers: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    //  func sortByGenre() -> [MovieListItem]? {
    //    guard self.selectedGenre != nil else {
    //      print("Catégories non selectionner")
    //      return nil
    //    }
    //    return self.moviesListsItems.filter{ $0.genreIDs[0] == self.selectedGenre!.id }
    //  }
    
    //  func fetchMovieVideo(by movieId: Int) async -> Video? {
    //    let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(self.apiKey)&language=en-US"
    //
    //    guard let url = URL(string: urlString) else { return nil }
    //
    //    do {
    //      let (data, _) = try await URLSession.shared.data(from: url)
    //      let result = try JSONDecoder().decode(VideoResponse.self, from: data)
    //      if let youtubeVideo = result.results.first(where: {$0.site == "YouTube"}) {
    //        return youtubeVideo
    //      } else {
    //        return nil
    //      }
    //    } catch {
    //      print("Error fetching video: \(error)")
    //      return nil
    //    }
    //  }
    
}
