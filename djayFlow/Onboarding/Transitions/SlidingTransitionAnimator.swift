//
//  SlidingTransitionAnimator.swift
//  djayFlow
//
//  Created by Denis.Morozov on 13.04.2025.
//

import UIKit

struct SlidingTransitionAnimator: OnboardingStepTransitionAnimator {
    func run(from: UIViewController, to: UIViewController, transition: (Context) -> Void) {
        let width = from.view.bounds.width
        
        let context = Context(
            duration: 0.45,
            preparations: {
                to.view.transform = CGAffineTransform.identity.translatedBy(x: width, y: 0.0)
            },
            animations: {
                from.view.transform = CGAffineTransform.identity.translatedBy(x: -width, y: 0.0)
                to.view.transform = .identity
            }
        )
        
        transition(context)
    }
}
