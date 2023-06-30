//
//  Category.swift
//  WeatherApp
//
//  Created by Tran  Hieu on 15/04/2023.
//

import Foundation

enum Category: String, CaseIterable {
    case general
    case business
    case technology
    case entertainment
    case sports
    case science
    case health
    
    var text: String {
        if self == .general {
            return "Home"
        }
        return rawValue.capitalized
    }
}
extension Category: Identifiable {
    var id: Self {self}
}
