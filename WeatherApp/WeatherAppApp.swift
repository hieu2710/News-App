//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Tran  Hieu on 29/03/2023.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject var articleBookmarkVN = ArticleBookMarkViewModel.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(articleBookmarkVN)
        }
    }
}
