//
//  ChatScreenView.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 24.05.2021.
//

import UIKit

class ChatScreenView: UIView {
    // MARK: - UI components
    private(set) lazy var scrollView: UIScrollView = {
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        return scrollView
    }()
    
    private(set) lazy var logoChatScreenLabel = UILabel(text: "There will be a Chat",
                                                        font: .smallTitleFont(),
                                                        textColor: .systemBlue,
                                                        numberOfLines: 1,
                                                        textAlignment: .center,
                                                        adjustsFontSizeToFitWidth: false)
    
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
        scrollView.addSubview(logoChatScreenLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(
                equalTo: safeAreaLayoutGuide.rightAnchor),
            
            logoChatScreenLabel.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: 100.0),
            logoChatScreenLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor)
        ])
    }
}
