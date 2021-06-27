//
//  DialogCreator.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 27.05.2021.
//

import Foundation

protocol DialogCreator {
    func createDialog(id: String,
                      name: String,
                      photo: String?,
                      completion: @escaping (_ result: Result<Dialog, Error>) -> Void)
}

