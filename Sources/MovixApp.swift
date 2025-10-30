//
//  MovixApp.swift
//  Movix
//
//  Created by Jessy Viranaiken on 16/12/2024.
//

import SwiftUI
import SwiftData

@main
struct MovixApp: App {
    
    @State private var moviesController = MoviesController()
    @State private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(moviesController)
                .environment(dataController)
        }
        .modelContainer(for: DataItem.self)
    }
}
