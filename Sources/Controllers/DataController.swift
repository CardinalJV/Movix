//
//  DataController.swift
//  Movix
//
//  Created by Viranaiken Jessy on 28/10/25.
//

import Foundation
import SwiftData
import TMDb

@MainActor
@Observable
class DataController {
    
    var dataItems: [DataItem] = []
    var favoriteMovies: [Movie] = []
    var context: ModelContext?
    
    func configure(context: ModelContext) {
        self.context = context
        self.fetchData()
    }
    
    func addInFavorites(movie: Movie) {
        guard let context = self.context else {
            print("Context has a error")
            return
        }
        guard !self.dataItems.contains(where: { $0.targetId == movie.id }) else {
            if !self.favoriteMovies.contains(where: { $0.id == movie.id }) {
                self.favoriteMovies.insert(movie, at: 0)
            }
            return
        }
        
        let dataItem = DataItem(targetId: movie.id)
        
        if !self.favoriteMovies.contains(where: { $0.id == movie.id }) {
            self.favoriteMovies.insert(movie, at: 0)
        }
        do {
            context.insert(dataItem)
            try context.save()
            self.dataItems.insert(dataItem, at: 0)
        } catch {
            self.favoriteMovies.removeAll(where: { $0.id == movie.id })
            print("Error during adding in local storage: \(error.localizedDescription)")
        }
    }
    
    func deleteToFavorite(movieId: Int) {
        guard let context = self.context else {
            print("Context has a error")
            return
        }
        
        let itemsToDelete = self.dataItems.filter { $0.targetId == movieId }
        
        do {
            for dataItem in itemsToDelete {
                context.delete(dataItem)
            }
            try context.save()
            self.favoriteMovies.removeAll(where: { $0.id == movieId })
            self.dataItems.removeAll(where: { $0.targetId == movieId })
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
    
    func loadFavoriteMovies(using moviesController: MoviesController) async {
        self.fetchData()
        
        var loadedMovies: [Movie] = []
        var seenIds = Set<Int>()
        
        for item in self.dataItems.reversed() where !seenIds.contains(item.targetId) {
            if let movie = await moviesController.fetchMovie(byId: item.targetId) {
                loadedMovies.append(movie)
                seenIds.insert(item.targetId)
            }
        }
        
        self.favoriteMovies = loadedMovies
    }
}
