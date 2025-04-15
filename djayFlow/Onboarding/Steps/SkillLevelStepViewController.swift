//
//  SkillLevelStepViewController.swift
//  djayFlow
//
//  Created by Denis.Morozov on 12.04.2025.
//

import UIKit

final class SkillLevelStepViewController: UIViewController {
    private enum Style {
        static let horizontalMargin = 32.0
        static let titleTopMargin = 40.0
        static let subtitleTopMargin = 8.0
        static let interItemSpacing = 8.0
        static let skillLevelsTopMargin = 40.0
        static let skillLevelHeight = 48.0
    }
    
    private let headImageView: UIImageView = UIImageView(image: UIImage(resource: .head))
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Welcome DJ"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = "What's your DJ skill level?"
        subtitleLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor(resource: .secondaryText)
        subtitleLabel.numberOfLines = 1
        return subtitleLabel
    }()
    
    private var skillLevelViews: [SkillLevelView] = []
    
    private var feedbackGenerator: UISelectionFeedbackGenerator!
    
    private let viewModel: SkillLevelStepViewModel
    
    init(viewModel: SkillLevelStepViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        feedbackGenerator = UISelectionFeedbackGenerator(view: view)
        
        setupSubviews()
        setupObservation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height = view.bounds.height
        let width = view.bounds.width
        
        let headSize = headImageView.intrinsicContentSize
        
        headImageView.frame = .init(
            x: width * 0.5 - headSize.width * 0.5,
            y: height * 0.19,
            width: headSize.width,
            height: headSize.height
        ).ceilPixelRect()
        
        titleLabel.frame = .init(
            x: Style.horizontalMargin,
            y: headImageView.frame.maxY + Style.titleTopMargin,
            width: width - Style.horizontalMargin * 2,
            height: titleLabel.font.lineHeight
        ).ceilPixelRect()
        
        subtitleLabel.frame = .init(
            x: Style.horizontalMargin,
            y: titleLabel.frame.maxY + Style.subtitleTopMargin,
            width: width - Style.horizontalMargin * 2,
            height: subtitleLabel.font.lineHeight
        ).ceilPixelRect()
        
        var levelY = subtitleLabel.frame.maxY + Style.skillLevelsTopMargin
        skillLevelViews.forEach { skillLevelView in
            skillLevelView.frame = .init(
                x: Style.horizontalMargin,
                y: levelY,
                width: width - Style.horizontalMargin * 2,
                height: Style.skillLevelHeight
            ).ceilPixelRect()
            
            levelY = skillLevelView.frame.maxY + Style.interItemSpacing
        }
    }
    
    private func setupSubviews() {
        view.addSubviews(
            headImageView,
            titleLabel,
            subtitleLabel
        )
        
        viewModel.skillLevels.forEach { level in
            let skillLevelView = SkillLevelView(level: level.description) { [weak self] in
                self?.viewModel.selectSkillLevel(level)
            }
            view.addSubview(skillLevelView)
            skillLevelViews.append(skillLevelView)
        }
    }
    
    private func setupObservation() {
        observe { [weak self] in
            guard let self else { return }
            
            for (skillLevelView, skillLevel) in zip(skillLevelViews, viewModel.skillLevels) {
                skillLevelView.update(level: skillLevel.description, selected: skillLevel == viewModel.selectedSkillLevel)
            }
            
            if viewModel.selectedSkillLevel != nil {
                feedbackGenerator.selectionChanged()
            }
        }
    }
}

// MARK: - SkillLevelView

private final class SkillLevelView: UIView {
    private enum Style {
        static let horizontalMargin = 16.0
        static let checkmarkSize = 24.0
        static let levelLabelHorizontalMargin = 16.0
    }
    
    static let unselectedImage = UIImage(
        systemName: "circle",
        withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor()
            .applying(UIImage.SymbolConfiguration(weight: .light))
    )!
    
    static let selectedImage = UIImage(
        systemName: "checkmark.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration.preferringMulticolor()
            .applying(UIImage.SymbolConfiguration(weight: .medium))
    )!
    
    static let unselectedBackgroundImage = UIImage.resizableImage(
        of: UIColor(resource: .quaternary),
        cornerRadius: 12.0
    )
    
    static let selectedBackgroundImage = UIImage.resizableImage(
        of: UIColor(resource: .quaternary),
        borderColor: UIColor(resource: .tint),
        cornerRadius: 12.0
    )
    
    private let backgroundImageView: UIImageView = UIImageView(image: unselectedBackgroundImage)
    
    private let checkmarkImageView: UIImageView = UIImageView(image: SkillLevelView.unselectedImage)
    
    
    private let levelLabel: UILabel = {
        let levelLabel = UILabel()
        levelLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        levelLabel.textColor = .white
        levelLabel.numberOfLines = 1
        return levelLabel
    }()
    
    private var isSelected = false
    
    private let tapHandler: () -> Void
    
    // MARK: Init
    
    init(level: String, tapHandler: @escaping () -> Void) {
        self.tapHandler = tapHandler
        
        super.init(frame: .zero)
        
        levelLabel.text = level
        
        addSubviews(
            backgroundImageView,
            checkmarkImageView,
            levelLabel
        )
        
        setupTapGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = bounds.width
        let height = bounds.height
        
        backgroundImageView.frame = bounds
        
        checkmarkImageView.frame = .init(
            x: Style.horizontalMargin,
            y: height * 0.5 - Style.checkmarkSize * 0.5,
            width: Style.checkmarkSize,
            height: Style.checkmarkSize
        ).ceilPixelRect()
        
        let levelLabelHeight = levelLabel.font.lineHeight
        
        levelLabel.frame = .init(
            x: checkmarkImageView.frame.maxX + Style.levelLabelHorizontalMargin,
            y: height * 0.5 - levelLabelHeight * 0.5,
            width: width - checkmarkImageView.frame.maxX - Style.levelLabelHorizontalMargin * 2,
            height: levelLabelHeight
        ).ceilPixelRect()
    }
    
    // MARK: Public
    
    func update(level: String, selected: Bool) {
        levelLabel.text = level
        setSelected(selected)
    }
    
    // MARK: Private
    
    private func setSelected(_ selected: Bool) {
        guard selected != isSelected else { return }
        
        isSelected = selected
        
        CATransaction.begin()
        
        UIView.transition(with: backgroundImageView, duration: 0.25, options: .transitionCrossDissolve) {
            self.backgroundImageView.image = selected
                ? Self.selectedBackgroundImage : Self.unselectedBackgroundImage
        }
        
        checkmarkImageView.setSymbolImage(
            selected ? Self.selectedImage : Self.unselectedImage,
            contentTransition: .replace.magic(fallback: .downUp.byLayer),
            options: .nonRepeating
        )
        
        CATransaction.commit()
    }
    
    private func setupTapGestureRecognizer() {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    @objc
    private func handleTap() {
        tapHandler()
    }
}
