//
//  ChapterCard.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 15/06/2021.
//

import SwiftUI

struct ChapterCard: View {
    var chapter: Chapter
    var mangaId: String
    var cover: Cover?
    
    var body: some View {
        HStack {
            if let cover = cover {
                AsyncImage(url: cover.url(mangaId: mangaId)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(30)
            }
            
            VStack(alignment: .leading) {
                if !chapter.attributes.title.isEmpty {
                    Text(chapter.attributes.title)
                        .font(.title3)
                }
                
                if let volume = chapter.attributes.volume {
                    Text("Volume: \(volume)")
                }
                
                if let chapter = chapter.attributes.chapter {
                    Text("Chapter: \(chapter)")
                }
            }
            .font(.footnote)
            .padding()
        }
    }
}

struct ChapterCard_Previews: PreviewProvider {
    static var previews: some View {
        ChapterCard(chapter: Chapter.previews[3],
                    mangaId: "304ceac3-8cdb-4fe7-acf7-2b6ff7a60613",
                    cover: Cover.preview)
            .previewLayout(.sizeThatFits)
    }
}
