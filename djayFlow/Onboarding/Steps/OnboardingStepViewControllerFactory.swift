//
//  OnboardingStepViewControllerFactory.swift
//  djayFlow
//
//  Created by Denis.Morozov on 13.04.2025.
//

import UIKit

@MainActor
protocol OnboardingStepViewControllerFactory {
    func createViewController(for step: OnboardingStep) -> UIViewController
}
