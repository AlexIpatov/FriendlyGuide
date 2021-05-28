//
//  ChatTableVewCell.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import UIKit

protocol ChatTableVewCell: UITableViewCell {
    func fillIn(with dialod: Dialog)
}
