//
//  EventParticipant.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

struct EventParticipant: Codable, Hashable {
    let role: EventLocation
    let agent: EventAgent
}
