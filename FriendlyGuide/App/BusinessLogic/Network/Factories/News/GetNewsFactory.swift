//
//  GetNewsFactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 01.06.2021.
//

import Foundation

protocol GetNewsFactory {
    func getNews(cityTag: String,
                 completionHandler: @escaping (Result<NewsList, NetworkingError>) -> Void)
}
