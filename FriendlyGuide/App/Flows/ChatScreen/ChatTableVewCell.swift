//
//  ChatTableVewCell.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 24.05.2021.
//

import UIKit

class ChatTableVewCell: UITableViewCell {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var niknameLable: UILabel = {
        let lable = UILabel()
        return lable
    }()
    
    
    init(style: UITableViewCell.CellStyle? = nil, reuseIdentifier: String?, chatBuilder: String) {
        super.init(style: style ?? .default, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
    }
    
    func setUp(with chatInfo: ChatInformationRepresentable) {
        
    }
}
