//
//  DialogDataLoader.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 26.06.2021.
//

import Foundation

protocol DialogDataLoader: AnyObject {
    func getDialogImageURL(for dialog: Dialog,
                           completion: @escaping (Result<URL?, Error>) -> Void)
 
    func getLastMessageText(for dialog: Dialog,
                            completion: @escaping (Result<String, Error>) -> Void)
}
