//
//  AppComponent.swift
//  djayFlow
//
//  Created by Denis.Morozov on 13.04.2025.
//

import UIKit

@MainActor
final class AppComponent {
    private lazy var onboardingFlowModel = OnboardingFlowModel()
    
    func createOnboardingViewController() -> UIViewController {
        OnboardingViewController(
            viewModel: OnboardingViewModel(onboardingFlowModel: onboardingFlowModel),
            stepViewControllerFactory: self,
            stepTransitionAnimatorFactory: self
        )
    }
}

extension AppComponent: OnboardingStepViewControllerFactory {
    func createViewController(for step: OnboardingStep) -> UIViewController {
        switch step {
        case .intro:
            IntroStepViewController()
        case .awards:
            AwardsStepViewController()
        case .skillLevelSelection:
            SkillLevelStepViewController(
                viewModel: SkillLevelStepViewModel(onboardingFlowModel: onboardingFlowModel)
            )
        case .final:
            FinalStepViewController()
        }
    }
}

extension AppComponent: OnboardingStepTransitionAnimatorFactory {
    func createAnimatorForTransition(
        from: OnboardingStep,
        to: OnboardingStep
    ) -> any OnboardingStepTransitionAnimator {
        switch (from, to) {
        case (.intro, .awards):
            AwardsTransitionAnimator()
        default:
            SlidingTransitionAnimator()
        }
    }
}
