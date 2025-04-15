//
//  OnboardingViewController.swift
//  djayFlow
//
//  Created by Denis.Morozov on 11.04.2025.
//

import UIKit

final class OnboardingViewController: UIViewController {
    private enum Style {
        static let horizontalMargin = 32.0
        
        static let actionButtonCornerRadius = 12.0
        static let actionButtonVerticalPadding = 12.0
        
        static let actionButtonBottomMargin = 24.0
        
        static let pageControlHeight = 26.0
        static let pageControlBottomMargin = 16.0
    }
    
    private var childViewController: UIViewController!
    
    private let actionButton: UIButton = {
        let actionButton = UIButton()
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        
        actionButton.setBackgroundImage(
            UIImage.resizableImage(
                of: UIColor(resource: .tint),
                cornerRadius: Style.actionButtonCornerRadius
            ),
            for: .normal
        )
        
        actionButton.layer.zPosition = 2
        
        return actionButton
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.45, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.45, y: 1.0)
        gradient.locations = [NSNumber(floatLiteral: 0.04), NSNumber(floatLiteral: 0.95)]
        gradient.colors = [
            UIColor(resource: .gradientTop).cgColor,
            UIColor(resource: .gradientBottom).cgColor
        ]
        return gradient
    }()
    
    private let viewModel: OnboardingViewModel
    private let stepViewControllerFactory: OnboardingStepViewControllerFactory
    private let stepTransitionAnimatorFactory: OnboardingStepTransitionAnimatorFactory
    
    // MARK: - Init
    
    init(
        viewModel: OnboardingViewModel,
        stepViewControllerFactory: OnboardingStepViewControllerFactory,
        stepTransitionAnimatorFactory: OnboardingStepTransitionAnimatorFactory
    ) {
        self.viewModel = viewModel
        self.stepViewControllerFactory = stepViewControllerFactory
        self.stepTransitionAnimatorFactory = stepTransitionAnimatorFactory
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupInitialStep()
        
        actionButton.addAction(UIAction { [weak self] _ in
            self?.viewModel.handleAction()
        }, for: .touchUpInside)
        
        var lastStep = viewModel.currentStep
        observe { [weak self] in
            guard let self, self.viewModel.currentStep != lastStep else { return }
            
            let currentStep = viewModel.currentStep
            
            if lastStep.id != currentStep.id {
                self.transition(from: lastStep, to: currentStep)
            } else {
                self.updateControls(for: currentStep)
            }
            
            lastStep = currentStep
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradient.frame = view.bounds
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        let pageControlWidth = pageControl.sizeThatFits(view.bounds.size).width
        
        pageControl.frame = .init(
            x: (width - pageControlWidth) * 0.5,
            y: height - view.safeAreaInsets.bottom - Style.pageControlHeight - Style.pageControlBottomMargin,
            width: pageControlWidth,
            height: Style.pageControlHeight
        ).ceilPixelRect()
        
        let actionButtonHeight = (actionButton.titleLabel?.font.lineHeight ?? 20) + Style.actionButtonVerticalPadding * 2
        
        actionButton.frame = .init(
            x: Style.horizontalMargin,
            y: (pageControl.frame.minY - Style.actionButtonBottomMargin - actionButtonHeight).ceilPixelValue(),
            width: width - Style.horizontalMargin * 2,
            height: actionButtonHeight
        ).ceilPixelRect()
        
        childViewController.view.frame = .init(
            x: 0,
            y: view.safeAreaInsets.top,
            width: width,
            height: actionButton.frame.minY - view.safeAreaInsets.top
        ).ceilPixelRect()
    }
    
    // MARK: - Private
    
    private func setupSubviews() {
        view.layer.addSublayer(gradient)
        
        view.addSubviews(
            actionButton,
            pageControl
        )
    }
    
    private func setupInitialStep() {
        childViewController = stepViewControllerFactory.createViewController(
            for: viewModel.currentStep.id
        )
        
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        
        pageControl.numberOfPages = viewModel.totalNumberOfSteps
        
        updateControls(for: viewModel.currentStep)
    }
    
    private func transition(from: OnboardingViewModel.Step, to: OnboardingViewModel.Step) {
        let newVC = stepViewControllerFactory.createViewController(for: to.id)
        let oldVC = childViewController!
        
        childViewController = newVC
        
        oldVC.willMove(toParent: nil)
        addChild(newVC)
        
        let animator = stepTransitionAnimatorFactory.createAnimatorForTransition(from: from.id, to: to.id)
        
        animator.run(from: oldVC, to: newVC) { ctx in
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            ctx.preparations()
            CATransaction.commit()
            
            transition(
                from: oldVC,
                to: newVC,
                duration: ctx.duration,
                animations: {
                    ctx.animations()
                    
                    UIView.transition(
                        with: self.actionButton,
                        duration: 0.0,
                        options: .transitionCrossDissolve
                    ) {
                        self.actionButton.setTitle(to.actionTitle, for: .normal)
                        self.actionButton.isEnabled = to.isActionEnabled
                    }
                    
                    self.pageControl.currentPage = to.stepNumber
                },
                completion: { _ in
                    oldVC.removeFromParent()
                    newVC.didMove(toParent: self)
                }
            )
        }
    }
    
    func updateControls(for step: OnboardingViewModel.Step) {
        pageControl.currentPage = step.stepNumber
        
        actionButton.isEnabled = step.isActionEnabled
        actionButton.setTitle(step.actionTitle, for: .normal)
    }
}
