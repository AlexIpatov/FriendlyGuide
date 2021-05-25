//
//  SectionHeader.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 24.05.2021.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    // MARK: - Properties
    static let reuseId = "SectionHeader"
    // MARK: - UI components
    let title = UILabel()
    
    private(set) lazy var showMoreButton = UIButton(title: "Ещё...",
                                                             image: .none,
                                                             font: .smallButtonFont(),
                                                             cornerRadius: 0.0,
                                                             backgroundColor: .clear,
                                                             tintColor: .systemBlue)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration Methods
    func configure(text: String,
                   font: UIFont?,
                   textColor: UIColor) {
        title.textColor = textColor
        title.font = font
        title.text = text
    }
    func configureUI() {
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        addSubview(showMoreButton)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            showMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            showMoreButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
}
