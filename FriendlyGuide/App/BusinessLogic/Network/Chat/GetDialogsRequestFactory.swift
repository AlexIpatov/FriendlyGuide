//
//  GetDialogsRequestFactory.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 09.06.2021.
//

import Foundation

protocol GetDialogsRequestFactory {
    func getDialogs(limit: Int,
                    skipFirst: Int,
                    complition: @escaping (_ dialogs: [Dialog], _ total: Int) -> Void)
}
