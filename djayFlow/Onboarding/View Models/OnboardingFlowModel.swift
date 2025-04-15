//
//  OnboardingFlowModel.swift
//  djayFlow
//
//  Created by Denis.Morozov on 13.04.2025.
//

import Observation

@MainActor
@Observable
final class OnboardingFlowModel {
    private(set) var hasSelectedSkill = false
    
    func notifyOfSelectedSkillLevel(_ skillLevel: SkillLevel) {
        guard !hasSelectedSkill else { return }
        hasSelectedSkill = true
    }
}
