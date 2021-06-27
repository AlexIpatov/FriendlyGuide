//
//  EndPointType.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 24.05.2021.
//

import Foundation

protocol EndPointType {
    associatedtype ModelType: Decodable
    var host      : BaseURL    { get }
    var path      : Path       { get }
    var httpMethod: HTTPMethod { get }
    var parameters: Parameters { get }
    var queryItems: [URLQueryItem] { get }
}

extension EndPointType {
    func url() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host.baseURL
        components.path = path.path
        components.queryItems = queryItems
        guard let url = components.url else { return nil }
        return url
    }
}

enum BaseURL {
    case kudago
}

extension BaseURL {
    var baseURL: String {
        switch self {
        case .kudago:
            return "kudago.com"
        }
    }
}

enum Path {
    case cities
    case events
    case eventsOfTheDay
    case places
    case news
    case search
}

extension Path {
    var path: String {
        switch self {
        case .cities:
            return "/public-api/v1.4/locations"
        case .events:
            return "/public-api/v1.4/events"
        case .eventsOfTheDay:
            return "/public-api/v1.4/events-of-the-day"
        case .places:
            return "/public-api/v1.4/places"
        case .news:
            return "/public-api/v1.4/news"
        case .search:
            return "/public-api/v1.4/search"
        }
    }
}
