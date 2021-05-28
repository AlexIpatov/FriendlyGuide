//
//  SliderTransition.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 26.05.2021.
//

import UIKit

class SliderTransition: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SliderWithDimmingViewController(presentedViewController: presented, presenting: presenting ?? source)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimation()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimation()
    }
}
