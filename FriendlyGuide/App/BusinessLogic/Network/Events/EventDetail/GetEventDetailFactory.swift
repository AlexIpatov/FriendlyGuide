//
//  GetEventDetailFactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

protocol GetEventDetailFactory {
    func getEventDetail(eventID: Int, completionHandler: @escaping (Result<EventDetail, NetworkingError>) -> Void)
}
