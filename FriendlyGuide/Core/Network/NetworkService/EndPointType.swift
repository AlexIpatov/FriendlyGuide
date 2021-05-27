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

enum BaseURL {
    case kudago
    case someChatByValera
}
extension BaseURL {
    var baseURL: String {
        switch self {
        case .kudago:
            return "kudago.com"
        case .someChatByValera:
            return "somechat.com"
        }
    }
}

enum Path {
    case cities
    case events
}
extension Path {
    var path: String {
        switch self {
        case .cities:
            return "/public-api/v1.4/locations"
        case .events:
            return "/public-api/v1.4/events"
        }
    }
}
