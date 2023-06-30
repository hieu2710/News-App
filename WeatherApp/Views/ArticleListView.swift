//
//  ArticleListView.swift
//  WeatherApp
//
//  Created by Tran  Hieu on 13/04/2023.
//

import SwiftUI

struct ArticleListView: View {
    let articles: [Article]
    @State private var selectedArticle: Article?
 
    var body: some View {
        List{
            ForEach(articles) { article in
                ArticleRowView(article: article)
                    .onTapGesture {
                        selectedArticle = article
                    }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .fullScreenCover(item: $selectedArticle){
            SafariView(url: $0.articleURL)
                .edgesIgnoringSafeArea(.bottom)
        }
        
    }
}

struct ArticleListView_Previews: PreviewProvider {
    @StateObject static var articleBookmarkVM = ArticleBookMarkViewModel.shared
    static var previews: some View {
        NavigationView{
            ArticleListView(articles: Article.previewData)
                .environmentObject(articleBookmarkVM)
        }
        
    }
}
