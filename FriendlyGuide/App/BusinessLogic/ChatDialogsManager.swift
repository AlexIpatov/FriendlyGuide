//
//  ChatDialogsManager.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 27.05.2021.
//

import Foundation

protocol ChatDialogsManager {
    func getAllDialogs(limit: Int,
                       skipFirst: Int,
                       complition: @escaping (_ dialog: Dialog?) -> Void)
    
    func createGroupDialog(withName name: String,
                           photo: String?,
                           occupants: [ChatUser],
                           completion: @escaping (_ dialog: Dialog?) -> Void)
}
