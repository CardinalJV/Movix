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
        if let resolvedURL {
            AsyncImage(url: resolvedURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    self.placeholder
                @unknown default:
                    self.placeholder
                }
            }
        } else {
            self.placeholder
        }
    }
    
    private var resolvedURL: URL? {
        guard let imageUrl else {
            return nil
        }
        
        if imageUrl.scheme != nil {
            return imageUrl
        }
        
        let imagePath = imageUrl.relativeString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard !imagePath.isEmpty else {
            return nil
        }
        
        return URL(string: "https://image.tmdb.org/t/p/w500/\(imagePath)")
    }
    
    private var placeholder: some View {
        ZStack {
            MovixTheme.elevatedBackground
            Image(systemName: "photo")
                .font(.title2)
                .foregroundStyle(MovixTheme.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
//
//#Preview {
//    ImageLoader()
//}
