//
//  ImageLoader.swift
//  Movix
//
//  Created by Jessy Viranaiken on 19/12/2024.
//

import SwiftUI

struct ImageLoader: View {
    
    let imageUrl: URL?
    
    var body: some View {
        if self.imageUrl != nil {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/" + self.imageUrl!.relativeString)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    VStack{
                        Text("Erreur lors du chargement de l'image")
                        Image(systemName: "xmark.circle")
                    }
                    .tint(.red)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "xmark")
                .foregroundStyle(.gray)
        }
    }
}
//
//#Preview {
//    ImageLoader()
//}
