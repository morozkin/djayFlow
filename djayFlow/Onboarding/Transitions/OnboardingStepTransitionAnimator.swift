//
//  OnboardingStepTransitionAnimator.swift
//  djayFlow
//
//  Created by Denis.Morozov on 13.04.2025.
//

import UIKit

final class OnboardingStepTransitionContext {
    typealias Preparations = () -> Void
    typealias Animations = () -> Void
    
    static let Empty = OnboardingStepTransitionContext(duration: 0.25, preparations: {}, animations: {})
    
    let preparations: Preparations
    let animations: Animations
    let duration: TimeInterval
    
    init(
        duration: TimeInterval,
        preparations: @escaping Preparations,
        animations: @escaping Animations
    ) {
        self.duration = duration
        self.preparations = preparations
        self.animations = animations
    }
}

protocol OnboardingStepTransitionAnimator {
    typealias Context = OnboardingStepTransitionContext
    
    func run(from: UIViewController, to: UIViewController, transition: (Context) -> Void)
}
