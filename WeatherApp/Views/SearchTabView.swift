//
//  SearchTabView.swift
//  WeatherApp
//
//  Created by Tran  Hieu on 03/05/2023.
//

import SwiftUI

struct SearchTabView: View {
    
    @StateObject var searchVM = ArticleSearchViewModel.shared
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .navigationTitle("Search")
        }
        .searchable(text: $searchVM.searchQuery) { suggestionsView }
        .onChange(of: searchVM.searchQuery) { newValue in
            if newValue.isEmpty {
                searchVM.phase = .empty
            }
        }
        .onSubmit(of: .search, search)
    }
    
    private var articles: [Article] {
        if case .success(let articles) = searchVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch searchVM.phase {
        case .empty:
            if !searchVM.searchQuery.isEmpty {
                ProgressView()
            } else if !searchVM.history.isEmpty {
                SearchHistoryListView(searchVM: searchVM) { newValue in
                    // Need to be handled manually as it doesn't trigger default onSubmit modifier
                    searchVM.searchQuery = newValue
                    search()
                }
            } else {
                EmptyPlaceholderView(text: "Type your query to search from NewsAPI", image: Image(systemName: "magnifyingglass"))
            }
            
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No search results found", image: Image(systemName: "magnifyingglass"))
            
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: search)
            
        default: EmptyView()
            
        }
    }
    
    @ViewBuilder
    private var suggestionsView: some View {
        ForEach(["Swift", "Covid-19", "BTC", "PS5", "iOS 15"], id: \.self) { text in
            Button {
                searchVM.searchQuery = text
            } label: {
                Text(text)
            }
        }
    }
    
    private func search() {
        let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchQuery.isEmpty {
            searchVM.addHistory(searchQuery)
        }
        
        Task {
            await searchVM.searchArticle()
        }
    }
}

struct SearchTabView_Previews: PreviewProvider {
    
    @StateObject static var bookmarkVM = ArticleBookMarkViewModel.shared
    
    static var previews: some View {
        SearchTabView()
            .environmentObject(bookmarkVM)
    }
}


//import SwiftUI
//
//struct SearchTabView: View {
//    @StateObject var searchVM = ArticleSearchViewModel()
//    var body: some View {
//        NavigationView{
//            ArticleListView(articles: articles)
//                .overlay(overlayView)
//                .navigationTitle("Search")
//        }
//        .searchable(text: $searchVM.searchQuery) { suggestionView }
//        .onChange(of: searchVM.searchQuery) { newValue in
//            if newValue.isEmpty {
//                searchVM.phase = .empty
//            }
//        }
//        .onSubmit(of: .search, search)
//    }
//    private var articles: [Article] {
//        if case .success(let articles) = searchVM.phase {
//            return articles
//        } else {
//            return []
//        }
//    }
//
//
//    @ViewBuilder
//    private var overlayView: some View {
//        switch searchVM.phase {
//        case .empty:
//            if !searchVM.searchQuery.isEmpty {
//                ProgressView()
//            } else if !searchVM.searchQuery.isEmpty {
//                SearchHistoryListView(searchVM: searchVM) { newValue in
//                    searchVM.searchQuery = newValue
//                    search()
//                }
//            } else {
//                EmptyPlaceholderView(text: "Type your query to search from NewsAPI", image: Image(systemName: "magnifyingglass"))
//            }
//        case .success(let articles) where articles.isEmpty:
//            EmptyPlaceholderView(text: "No search results found", image: Image(systemName: "magnifyingglass"))
//        case .failure(let error):
//            RetryView(text: error.localizedDescription, retryAction: search)
//        default: EmptyView()
//        }
//    }
//    @ViewBuilder
//    private var suggestionView: some View {
//        ForEach(["Swift", "Apple", "BTC", "PS5", "Covid-19", "iOS15"], id: \.self) { text in
//            Button {
//                searchVM.searchQuery = text
//            } label: {
//                Text(text)
//            }
//        }
//    }
//    private func search() {
//        let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
//        if !searchQuery.isEmpty {
//            searchVM.addHistory(searchQuery)
//        }
//        Task {
//            await searchVM.searchArticle()
//        }
//    }
//}
//
//struct SearchTabView_Previews: PreviewProvider {
//
//    @StateObject static var bookmarkVM = ArticleBookMarkViewModel.shared
//
//    static var previews: some View {
//        SearchTabView()
//            .environmentObject(bookmarkVM)
//    }
//}
