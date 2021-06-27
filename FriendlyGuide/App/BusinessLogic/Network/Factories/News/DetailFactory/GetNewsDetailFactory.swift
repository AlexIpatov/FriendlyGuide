//
//  GetNewsDetailFactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 10.06.2021.
//

import Foundation

protocol GetNewsDetailFactory {
    func load(id: Int, completionHandler: @escaping (Result<NewsDetail, NetworkingError>) -> Void)
}
