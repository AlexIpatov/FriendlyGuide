//
//  ChatListViewEmptyCell.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 07.06.2021.
//

import UIKit

final class ChatListViewEmptyCell: UITableViewCell {
    static let identifier = "ChatListEmptyTableViewCell"
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.frame = bounds
        startAnimation()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        addSubview(emptyView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.autoreverse, .repeat]) { [weak self] in
            self?.emptyView.backgroundColor = .black
        }
    }
    
    private func stopAnimation() {
        emptyView.layer.removeAllAnimations()
    }
    
    deinit {
        stopAnimation()
    }
}
