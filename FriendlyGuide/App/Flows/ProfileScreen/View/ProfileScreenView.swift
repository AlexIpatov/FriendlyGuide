//
//  ProfileScreenView.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 24.05.2021.
//

import UIKit

class ProfileScreenView: UIView, UIComponentsMakeable {
    // MARK: - UI components
    private(set) lazy var scrollView: UIScrollView = {
        makeScrollView()
    }()
    
    private(set) lazy var logoProfileScreenLabel: UILabel = {
        makeLabel(text: "There will be a Profile",
                       textColor: .systemBlue,
                       font: .boldSystemFont(ofSize: 30.0))
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration Methods
    func configureUI() {
        addSubview(scrollView)
        scrollView.addSubview(logoProfileScreenLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(
                equalTo: safeAreaLayoutGuide.rightAnchor),
            
            logoProfileScreenLabel.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: 100.0),
            logoProfileScreenLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor)
        ])
    }
}
