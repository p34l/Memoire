//
//  CachedAsyncImage.swift
//  Memoire
//
//  Created by Misha Kandaurov on 19.04.2025.
//

import  SwiftUI

struct CachedAsyncImage: View {
    let url: URL
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: width, height: height)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .cornerRadius(8)
                    .clipped()
            case .failure:
                Image(systemName: "film")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
    }
}
