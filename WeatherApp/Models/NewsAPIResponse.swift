//
//  NewsAPIResponse.swift
//  WeatherApp
//
//  Created by Tran  Hieu on 12/04/2023.
//

import Foundation
struct NewsAPIResponse: Decodable{
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String?
}
