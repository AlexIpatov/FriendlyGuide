//
//  ChatDialogsManager.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 27.05.2021.
//

import Foundation

protocol ChatDialogsManager {
    func getDialogs(limit: Int,
                    skipFirst: Int,
                    complition: @escaping (_ dialogs: [Dialog], _ total: Int) -> Void)
    
    func createGroupDialog(withName name: String,
                           photo: String?,
                           occupants: [ChatConnectable],
                           completion: @escaping (_ dialog: Dialog?) -> Void)
}
