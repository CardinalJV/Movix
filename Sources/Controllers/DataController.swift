//
//  DataController.swift
//  Movix
//
//  Created by Viranaiken Jessy on 28/10/25.
//

import Foundation
import SwiftData
import TMDb

@Observable
class DataController{
    
    var dataItems: [DataItem] = []
    var context: ModelContext?
    var favoriteMovies: [Movie] = []
    
    func addInFavorites(movie: Movie){
        self.favoriteMovies.append(movie)
    }
    
    func deleteToFavorite(movieId: Int){
        self.favoriteMovies.removeAll(where: { $0.id == movieId })
    }
    
    func isInFavorites(movieId: Int) -> Bool {
        if self.favoriteMovies.firstIndex(where: { $0.id == movieId }) != nil {
            return true
        } else {
            return false
        }
    }
    
    func fetchData() {
      guard let context = self.context else {
        return
      }
      let request = FetchDescriptor<DataItem>()
      do {
          self.dataItems = try context.fetch(request)
      } catch {
        print("Error during fetching data: \(error.localizedDescription)")
      }
    }
}
