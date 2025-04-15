//
//  SkillLevelStepViewModel.swift
//  djayFlow
//
//  Created by Denis.Morozov on 13.04.2025.
//

import Observation

@MainActor
@Observable
final class SkillLevelStepViewModel {
    let skillLevels: [SkillLevel] = [.newbie, .amateur, .pro]
    private(set) var selectedSkillLevel: SkillLevel?
    
    private let onboardingFlowModel: OnboardingFlowModel
    
    init(onboardingFlowModel: OnboardingFlowModel) {
        self.onboardingFlowModel = onboardingFlowModel
    }
    
    func selectSkillLevel(_ skillLevel: SkillLevel) {
        guard selectedSkillLevel != skillLevel else { return }
        selectedSkillLevel = skillLevel
        onboardingFlowModel.notifyOfSelectedSkillLevel(skillLevel)
    }
}
