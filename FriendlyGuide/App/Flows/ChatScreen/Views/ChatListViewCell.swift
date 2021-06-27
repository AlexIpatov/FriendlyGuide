//
//  ChatListViewCell.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 07.06.2021.
//

import UIKit

final class ChatListViewCell: UITableViewCell {
    static let identifier = "ChatListTableViewCell"
    
    private lazy var nameLable: UILabel = {
        let lable = UILabel()
        return lable
    }()
    private lazy var lastMessageTextLable: UILabel = {
        let lable = UILabel()
        return lable
    }()
    private lazy var dialogImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let lablesStackView = UIStackView(arrangedSubviews: [
                                            nameLable,
                                            lastMessageTextLable ],
                                          axis: .vertical,
                                          spacing: 20)
        
        let mainStackView = UIStackView(arrangedSubviews: [
                                            dialogImageView,
                                            lablesStackView ],
                                        axis: .horizontal,
                                        spacing: 10)
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            dialogImageView.widthAnchor.constraint(equalToConstant: self.frame.height)
        ])
    }
    
    weak var dialogDataLoaader: DialogDataLoader?
    
    func setUp(with dialog: Dialog) {
        nameLable.attributedText = NSAttributedString(string: dialog.dialogName,
                                                      attributes: [.font: UIFont.systemFont(ofSize: 23)])
        
        dialogDataLoaader?.getLastMessageText(for: dialog, completion: { [weak self ] result in
            switch result {
            case .success(let dialogLastMessageText):
                DispatchQueue.main.async { [weak self] in
                    self?.lastMessageTextLable.attributedText = NSAttributedString(string: dialogLastMessageText,
                                                                                   attributes: [.font: UIFont.systemFont(ofSize: 14)])
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        })
        
        dialogDataLoaader?.getDialogImageURL(for: dialog, completion: { [weak self] result in
            switch result {
            case .success(let url):
                url.map { [weak self] in self?.imageView?.downloaded(from: $0,contentMode: .scaleAspectFit) }
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        })
    }
}
