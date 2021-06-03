//
//  TimeredErrorView.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 01.06.2021.
//

import UIKit

final class TimeredLableView: UIView {
    
    enum Position {
        case top, bottom
    }
    
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
        return lable
    }()

    private let style: Style
    
    private weak var view: UIView?
    
    init(style: Style) {
        self.style = style
        
        super.init(frame: .zero)
        infoLable.textColor = style.textColor
        addSubview(infoLable)
        
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
        
        
        setText(error.localizedDescription)
        setFrame(to: position, in: view)
        view.addSubview(self)
        
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
    
    private func setFrame(to position: CGFloat, in view: UIView) {
        let inset: CGFloat = 10
        
        infoLable.frame.origin.x = inset
        infoLable.frame.origin.y = inset
        
        let origin = CGPoint(x: (view.frame.maxX / 2) - (infoLable.frame.width / 2),
                             y: position)
        
        let size = CGSize(width: infoLable.frame.width + 2 * inset,
                          height: infoLable.frame.height + 2 * inset)
        
        frame = CGRect(origin: origin, size: size)
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
