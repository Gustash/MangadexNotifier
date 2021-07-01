//
//  Feed.swift
//  MangadexNotifier
//
//  Created by Gustavo Parreira on 15/06/2021.
//

import SwiftUI

struct Feed: View {
    @ObservedObject var dataStore: DataStore
    @EnvironmentObject var API: MangadexAPI
    @State var chapters: [ChapterResponse]
    @State var mangas: [MangaResponse]
    @State var covers: [CoverResponse]
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
        self.chapters = []
        self.mangas = []
        self.covers = []
    }
    
    init(dataStore: DataStore, chapters: [ChapterResponse]) {
        self.dataStore = dataStore
        self.chapters = chapters
        self.mangas = []
        self.covers = []
    }
    
    var body: some View {
        List(chapters, id: \.data.id) { chapter in
            if let manga = manga(of: chapter) {
                let cover = covers.first(where: {
                    let coverId = try? manga.coverId
                    return $0.data.id == coverId
                })?.data
                ChapterCard(chapter: chapter.data,
                            mangaId: manga.data.id,
                            cover: cover
                )
            }
        }
        .refreshable {
            await loadFeed()
        }
        .task {
            await loadFeed()
        }
    }
    
    func manga(of chapter: ChapterResponse) -> MangaResponse? {
        do {
            let mangaId = try chapter.mangaId
            guard let manga = mangas.first(where: {
                $0.data.id == mangaId
            }) else {
                return nil
            }
            
            return manga
        } catch MangaError.noManga {
            print("Chapter \(chapter.data.id) has no manga id")
            return nil
        } catch {
            print("Chapter \(chapter.data.id) had unknown error: \(error)")
            return nil
        }
    }
    
    func loadFeed() async {
        do {
            // Load Manga Feed
            let chapterRes = try await API.mangaFeed(auth: dataStore.auth)
            chapters = chapterRes.results.filter { $0.result == .ok }

            // Load mangas for every chapter
            var mangaIds: [String] = []
            for chapter in chapters {
                do {
                    let mangaId = try chapter.mangaId
                    
                    if mangaIds.contains(mangaId) {
                        continue
                    }
                    
                    mangaIds.append(mangaId)
                } catch MangaError.noCover {
                    print("Chapter \(chapter.data.id) has no manga id")
                }
            }
            let mangaList = try await API.mangas(ids: mangaIds,
                                                                auth: dataStore.auth)
            mangas = mangaList.results.filter { $0.result == .ok }
            
            // Load Covers for every Manga
            var coverIds: [String] = []
            for manga in mangas {
                do {
                    let coverId = try manga.coverId
                    
                    if coverIds.contains(coverId) {
                        continue
                    }
                    
                    coverIds.append(coverId)
                } catch MangaError.noCover {
                    print("Manga \(manga.data.id) has no cover id")
                }
            }
            let coverList = try await API.covers(ids: coverIds,
                                                                auth: dataStore.auth)
            covers = coverList.results
        } catch {
            print("Error fetching feed: \(error)")
        }
    }
}

struct Feed_Previews: PreviewProvider {
    static var previews: some View {
        let chapters = Chapter.previews.map {
            ChapterResponse(result: .ok,
                            data: $0,
                            relationships: [])
        }
        
        NavigationView {
            Feed(dataStore: DataStore.preview,
                 chapters: chapters)
                .environmentObject(MangadexAPI())
        }
    }
}
