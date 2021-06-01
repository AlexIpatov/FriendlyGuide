//
//  GetEventsListFactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

protocol GetEventsListFactory {
    func getEventsList(cityTag: String,
                       actualSince: String,
                       completionHandler: @escaping (Result<EventsList, NetworkingError>) -> Void)
}
