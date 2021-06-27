//
//  EventAgent.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

struct EventAgent: Codable, Hashable {
    let id: Int
    let title: String
    let slug: String
    let agentType: String
    let images: [String]
    let siteURL: String

    enum CodingKeys: String, CodingKey {
        case id, title, slug
        case agentType = "agent_type"
        case images
        case siteURL = "site_url"
    }
}
