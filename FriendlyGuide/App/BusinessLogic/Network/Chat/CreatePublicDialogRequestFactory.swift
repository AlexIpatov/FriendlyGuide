//
//  CreatePublicDialogRequestFactory.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 27.05.2021.
//

import Foundation

protocol CreatePublicDialogRequestFactory {
    func createDialog(withName name: String,
                      photo: String?,
                      completion: @escaping (_ dialog: Dialog?) -> Void)
}

