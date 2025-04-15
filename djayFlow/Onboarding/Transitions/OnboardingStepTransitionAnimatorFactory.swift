//
//  OnboardingStepTransitionAnimatorFactory.swift
//  djayFlow
//
//  Created by Denis.Morozov on 13.04.2025.
//

@MainActor
protocol OnboardingStepTransitionAnimatorFactory {
    func createAnimatorForTransition(
        from: OnboardingStep,
        to: OnboardingStep
    ) -> OnboardingStepTransitionAnimator
}
