//
//  GetExpandedEventsListFactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 04.07.2021.
//

import Foundation

protocol GetExpandedEventsListFactory {
    func load(cityTag: String,
              actualSince: String,
              completionHandler: @escaping (Result<EventsList, NetworkingError>) -> Void)
}
