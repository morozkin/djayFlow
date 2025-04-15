//
//  AwardsTransitionAnimator.swift
//  djayFlow
//
//  Created by Denis.Morozov on 13.04.2025.
//

import UIKit

enum AwardsTransitionTags: Int {
    case introLogo = 12
    case introInfoLabel = 13
    
    case awardsLogo = 34
    case awardsDevices = 35
    case awardsText = 36
    case awardsAda = 37
    
}

struct AwardsTransitionAnimator: OnboardingStepTransitionAnimator {
    func run(
        from: UIViewController,
        to: UIViewController,
        transition: (Context) -> Void)
    {
        guard
            let introInfoLabel = from.view.viewWithTag(AwardsTransitionTags.introInfoLabel.rawValue),
            let awardsLogo = to.view.viewWithTag(AwardsTransitionTags.awardsLogo.rawValue),
            let awardsDevices = to.view.viewWithTag(AwardsTransitionTags.awardsDevices.rawValue),
            let awardsText = to.view.viewWithTag(AwardsTransitionTags.awardsText.rawValue),
            let awardsAda = to.view.viewWithTag(AwardsTransitionTags.awardsAda.rawValue)
        else {
            transition(Context.Empty)
            return
        }
        
        let introInfoLabelCopy = introInfoLabel.snapshotView(afterScreenUpdates: false) ?? UIView()
        
        let context = Context(
            duration: 0.5,
            preparations: {
                introInfoLabelCopy.frame = introInfoLabel.frame
                introInfoLabelCopy.layer.zPosition = -1
                to.view.addSubview(introInfoLabelCopy)
                
                awardsLogo.transform = CGAffineTransform.identity
                    .translatedBy(x: 0.0, y: (from.view.bounds.height * 0.21).ceilPixelValue())
                
                awardsDevices.alpha = 0.0
                awardsDevices.transform = CGAffineTransform.identity
                    .translatedBy(x: 0.0, y: 60.0)
                    .scaledBy(x: 0.8, y: 0.8)
                awardsDevices.anchorPoint = CGPoint(x: 0.5, y: 1.0)
                
                awardsText.alpha = 0.0
                awardsText.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
                awardsText.anchorPoint = CGPoint(x: 0.5, y: 1.0)
                
                awardsAda.alpha = 0.0
                awardsAda.transform = CGAffineTransform.identity
                    .translatedBy(x: 0.0, y: -40.0)
                    .scaledBy(x: 0.8, y: 0.8)
                awardsAda.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            },
            animations: {
                UIView.animateKeyframes(withDuration: 0.0, delay: 0.0, animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6) {
                        introInfoLabelCopy.alpha = 0.0
                        introInfoLabelCopy.transform = CGAffineTransform.identity.translatedBy(x: 0.0, y: 50.0)
                    }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                        awardsLogo.transform = CGAffineTransform.identity
                    }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3) {
                        awardsDevices.alpha = 1.0
                        awardsText.alpha = 1.0
                        awardsAda.alpha = 1.0
                    }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8) {
                        awardsDevices.transform = CGAffineTransform.identity
                        awardsText.transform = CGAffineTransform.identity
                        awardsAda.transform = CGAffineTransform.identity
                    }
                }) { _ in
                    introInfoLabelCopy.removeFromSuperview()
                    
                    awardsDevices.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    awardsText.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    awardsAda.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                }
            }
        )
        
        transition(context)
    }
}
