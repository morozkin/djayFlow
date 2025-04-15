//
//  Observation.swift
//  djayFlow
//
//  Created by Denis.Morozov on 12.04.2025.
//

import UIKit

@MainActor
func observe(
    apply: @escaping @MainActor @Sendable () -> Void
) {
    onChange(apply: apply)
}

@MainActor
func onChange(
    apply: @escaping @MainActor @Sendable () -> Void
) {
    withObservationTracking {
        apply()
    } onChange: {
        Task { @MainActor in
            onChange(apply: apply)
        }
  }
}

extension NSObject {
    @MainActor
    func observe(
        apply: @escaping @MainActor @Sendable () -> Void
    ) {
        djayFlow.observe(apply: apply)
    }
}
