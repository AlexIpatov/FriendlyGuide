//
//  GetUserDialogsRequestFactory.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 09.06.2021.
//

import Foundation

protocol GetUserDialogsRequestFactory {
    func getDialogs(limit: Int,
                    skipFirst: Int,
                    completion: @escaping (_ dialogs: [Dialog], _ total: Int) -> Void)
}
