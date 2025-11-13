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
class DataController {
    
    var dataItems: [DataItem] = []
    var favoriteMovies: [Movie] = []
    var context: ModelContext?
    
    func addInFavorites(movie: Movie) {
        guard let context = self.context else {
            print("Context has a error")
            return
        }
        if !self.favoriteMovies.contains(where: { $0.id == movie.id }) {
            self.favoriteMovies.append(movie)
        }
        do {
            context.insert(DataItem(tmdbID: movie.id))
            try context.save()
        } catch {
            print("Error during adding in local storage: \(error.localizedDescription)")
        }
    }
    
    func deleteToFavorite(movieId: Int) {
        guard let context = self.context else {
            print("Context has a error")
            return
        }
        if self.favoriteMovies.contains(where: { $0.id == movieId }) {
            self.favoriteMovies.removeAll(where: { $0.id == movieId})
            self.dataItems.removeAll(where: { $0.tmdbID == movieId})
        }
        do {
            for dataItem in dataItems {
                if dataItem.tmdbID == movieId {
                    context.delete(dataItem)
                    try context.save()
                }
            }
        } catch {
            print("Error during deleting in local storage: \(error.localizedDescription)")
        }
    }
    
    
    func isInFavorites(movieId: Int) -> Bool {
        self.favoriteMovies.contains(where: { $0.id == movieId })
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
