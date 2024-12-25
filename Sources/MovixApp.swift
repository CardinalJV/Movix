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
  
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environment(moviesController)
        }
        .modelContainer(for: Item.self)
    }
}
