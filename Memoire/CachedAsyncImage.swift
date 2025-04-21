//
//  CachedAsyncImage.swift
//  Memoire
//
//  Created by Misha Kandaurov on 19.04.2025.
//

import SwiftUI
import Kingfisher

struct CachedAsyncImage: View {
    let url: URL
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        KFImage(url)
            .placeholder {
                ProgressView()
                    .frame(width: width, height: height)
            }
            .retry(maxCount: 3, interval: .seconds(2))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
            .cornerRadius(8)
            .clipped()
    }
}
