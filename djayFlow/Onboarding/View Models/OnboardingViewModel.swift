//
//  OnboardingViewModel.swift
//  djayFlow
//
//  Created by Denis.Morozov on 13.04.2025.
//

import Observation

@MainActor
@Observable
final class OnboardingViewModel {
    struct Step: Equatable {
        let id: OnboardingStep
        let stepNumber: Int
        let isActionEnabled: Bool
        let actionTitle: String
        
        func withIsActionEnabled(_ isActionEnabled: Bool) -> Step {
            Step(id: id, stepNumber: stepNumber, isActionEnabled: isActionEnabled, actionTitle: actionTitle)
        }
    }
    
    private(set) var currentStep: Step = Step(id: .intro, stepNumber: 0, isActionEnabled: true, actionTitle: "Continue")
    
    let totalNumberOfSteps: Int = OnboardingStep.allCases.count
    
    private let onboardingFlowModel: OnboardingFlowModel
    
    init(onboardingFlowModel: OnboardingFlowModel) {
        self.onboardingFlowModel = onboardingFlowModel
        
        setupBindings()
    }
    
    func handleAction() {
        guard currentStep.isActionEnabled else { return }
        
        switch currentStep.id {
        case .intro:
            currentStep = Step(id: .awards, stepNumber: 1, isActionEnabled: true, actionTitle: "Continue")
        case .awards:
            currentStep = Step(
                id: .skillLevelSelection,
                stepNumber: 2,
                isActionEnabled: onboardingFlowModel.hasSelectedSkill,
                actionTitle: "Let's go"
            )
        case .skillLevelSelection:
            currentStep = Step(
                id: .final,
                stepNumber: 3,
                isActionEnabled: false,
                actionTitle: "Done"
            )
        case .final:
            print("Done")
        }
    }
    
    private func setupBindings() {
        observe { [weak self] in
            guard let self else { return }
            
            if
                self.onboardingFlowModel.hasSelectedSkill,
                self.currentStep.id == .skillLevelSelection,
                !self.currentStep.isActionEnabled
            {
                self.currentStep = self.currentStep.withIsActionEnabled(true)
            }
        }
    }
}
