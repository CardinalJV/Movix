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
      return try await self.client.movies.details(forMovie: id, language: "fr")
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
    for item in self.moviesListsItems {
      if let posterPath = item.posterPath {
        self.posters.append(posterPath)
      }
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

