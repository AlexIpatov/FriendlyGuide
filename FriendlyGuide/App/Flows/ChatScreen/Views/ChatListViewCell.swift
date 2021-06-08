//
//  ChatListViewCell.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 07.06.2021.
//

import UIKit

final class ChatListViewCell: UITableViewCell {
    static let identifier = "ChatListTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(with dialog: Dialog) {
        textLabel?.text = dialog.dialogName
        detailTextLabel?.text = dialog.dialogLastMessageText
        
        if let imageUrl = dialog.dialogImageURL {
            imageView?.downloaded(from: imageUrl)
        }
    }
}
