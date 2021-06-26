//
//  DialogsLoader.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 09.06.2021.
//

import Foundation


typealias GetUserDialogsResponse = (dialogs: [Dialog], totalCountOfDialogs: Int)

protocol DialogsLoader {
    func getDialogs(limit: Int,
                    skipFirst: Int,
                    completion: @escaping (Result<GetUserDialogsResponse, Error>) -> Void)
}
