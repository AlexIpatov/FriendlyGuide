//
//  TimeredErrorView.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 01.06.2021.
//

import UIKit

fileprivate struct Constants {
    static let infoLableInsets: CGFloat = 15
}

final class TimeredLableView: UIView {
    struct Style {
        let backgroundColor: UIColor
        let textColor: UIColor
        
        static let error = Style(backgroundColor: .systemRed,
                                 textColor: .white)
        static let normal = Style(backgroundColor: .white,
                                  textColor: .black)
    }
    
    
    private lazy var infoLable: UILabel = {
        let lable = UILabel()
        lable.layer.cornerRadius = 10
        lable.textColor = style.textColor
        lable.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(lable)
        return lable
    }()

    private let style: Style
    private var yInset: CGFloat?
    
    private weak var view: UIView?
    
    init(style: Style) {
        self.style = style
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = style.backgroundColor
        isUserInteractionEnabled = false
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(in view: UIView,
              y position: CGFloat,
              with error: Error,
              duration: TimeInterval) {
        show(in: view, y: position, with: error.localizedDescription, duration: duration)
    }
    
    func show(in view: UIView,
              y position: CGFloat,
              with error: String,
              duration: TimeInterval) {
        
        setText(error)
        view.addSubview(self)

        removeConstraints(constraints)
        NSLayoutConstraint.activate([
            infoLable.topAnchor.constraint(equalTo: topAnchor),
            infoLable.bottomAnchor.constraint(equalTo: bottomAnchor),
            infoLable.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoLable.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topAnchor.constraint(equalTo: view.topAnchor, constant: position),
            widthAnchor.constraint(equalToConstant: infoLable.frame.width + Constants.infoLableInsets),
            heightAnchor.constraint(equalToConstant: infoLable.frame.height + Constants.infoLableInsets)
        ])
        
        dismiss(after: duration)
    }
    
    private func setText(_ error: String) {
        infoLable.attributedText = NSAttributedString(string: error,
                                                      attributes: [
                                                        .font: UIFont.boldSystemFont(ofSize: 11),
                                                        .foregroundColor: style.textColor
                                                      ])
        infoLable.frame.size.width = 200
        infoLable.numberOfLines = 0
        infoLable.textAlignment = .center
        infoLable.lineBreakMode = .byWordWrapping
        infoLable.sizeToFit()
    }
        
    private func dismiss(after delay: TimeInterval) {
        UIView.animate(withDuration: 1, delay: delay, options: .curveLinear) { [weak self] in
            self?.alpha = 0
        } completion: { [weak self] _ in
            self?.alpha = 1
            self?.view = nil
            self?.removeFromSuperview()
        }
    }
}
