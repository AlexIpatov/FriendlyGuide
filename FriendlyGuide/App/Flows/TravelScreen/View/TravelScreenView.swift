//
//  TravelScreenView.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 24.05.2021.
//

import UIKit

class TravelScreenView: UIView, UIComponentsMakeable {
    // MARK: - UI components
    private(set) lazy var scrollView: UIScrollView = {
        makeScrollView()
    }()
    
    private(set) lazy var logoTravelScreenLabel: UILabel = {
        makeLabel(text: "There will be a Travel",
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
        scrollView.addSubview(logoTravelScreenLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(
                equalTo: safeAreaLayoutGuide.rightAnchor),
            
            logoTravelScreenLabel.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: 100.0),
            logoTravelScreenLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor)
        ])
    }
}
