//
//  ArticleBookMarkViewModel.swift
//  WeatherApp
//
//  Created by Tran  Hieu on 29/04/2023.
//

import SwiftUI

@MainActor
class ArticleBookMarkViewModel: ObservableObject {
    
    @Published private (set) var bookmarks: [Article] = []
    private let bookmarkStore = PlistDataStore<[Article]>(filename: "bookmarks")
    
    static let shared = ArticleBookMarkViewModel()
    private init () {
        async {
            await load()
        }
    }
    
    private func load() async{
        bookmarks = await bookmarkStore.load() ?? []
    }
    
    
    func isBookmarke(for article: Article) -> Bool {
        bookmarks.first { article.id == $0.id } != nil
    }
    
    func addBookmark(for article: Article) {
        guard !isBookmarke(for: article) else {
            return
        }
        bookmarks.insert(article, at: 0)
        bookmarkUpdated()
    }
    func removeBookmark(for article: Article) {
        guard let index = bookmarks.firstIndex(where: {$0.id == article.id }) else {
            return
        }
        bookmarks.remove(at: index)
        bookmarkUpdated()
    }
    private func bookmarkUpdated() {
        let bookmarks = self.bookmarks
        async {
            await bookmarkStore.save(bookmarks)
        }
    }
}
