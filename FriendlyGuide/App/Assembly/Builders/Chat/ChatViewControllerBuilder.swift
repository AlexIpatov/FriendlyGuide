//
//  ChatViewControllerBuilder.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 18.06.2021.
//

import UIKit

protocol ChatViewControllerBuilder {
    func build(for dialog: Dialog, with user: User) -> (UIViewController &
                                                        ChatViewModelDelegate)
}
