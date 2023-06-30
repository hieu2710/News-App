//
//  NewsTabView.swift
//  WeatherApp
//
//  Created by Tran  Hieu on 16/04/2023.
//

import SwiftUI

struct NewsTabView: View {
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    
    var body: some View {
        
        NavigationView {
            ArticleListView(articles: aritcles)
                .overlay(overlayView)
                .task(id: articleNewsVM.fetchTaskToken, loadTasks)
                .refreshable(action: refreshText)
                .navigationTitle(articleNewsVM.fetchTaskToken.category.text)
                .navigationBarItems(trailing: menu)
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch articleNewsVM.phase {
        case .empty:
            ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No Articles", image: nil)
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: refreshText)
        default: EmptyView()
        }
    }
    
    private var aritcles:[Article] {
        if case let .success(articles) = articleNewsVM.phase {
            return articles
        } else {
            return []
        }
    }
    private func loadTasks() async {
        await articleNewsVM.loadArticles()
    }
    
    @Sendable
    private func refreshText() {
        DispatchQueue.main.async {
            articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
        }
    }
    private var menu: some View {
        Menu {
            Picker("Category", selection: $articleNewsVM.fetchTaskToken.category){
                ForEach(Category.allCases){
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "fiberchannel")
                .imageScale(.large)
        }
    }
}



struct NewsTabView_Previews: PreviewProvider {
    @StateObject static var articleBookmarkVM = ArticleBookMarkViewModel.shared
    static var previews: some View {
        NewsTabView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData))
            .environmentObject(articleBookmarkVM)
    }
}
