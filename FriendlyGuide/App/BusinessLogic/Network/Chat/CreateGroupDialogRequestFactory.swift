//
//  CreateGroupDialogRequestFactory.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 27.05.2021.
//

import Foundation

protocol CreateGroupDialogRequestFactory {
    func createGroupDialog(withName name: String,
                           photo: String?,
                           occupants: [ChatConnectable],
                           completion: @escaping (_ dialog: Dialog?) -> Void)
}

