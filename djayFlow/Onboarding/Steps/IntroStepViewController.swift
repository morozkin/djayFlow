//
//  IntroStepViewController.swift
//  djayFlow
//
//  Created by Denis.Morozov on 12.04.2025.
//

import UIKit

final class IntroStepViewController: UIViewController {
    private enum Style {
        static let logoSize = CGSize(width: 213, height: 64)
        
        static let infoLabelHorizontalMargin = 32.0
        static let infoLabelBottomMargin = 24.0
    }
    
    private let logoImageView: UIImageView = {
        let logoImageView = UIImageView(image: UIImage(resource: .djay))
        logoImageView.tag = AwardsTransitionTags.introLogo.rawValue
        return logoImageView
    }()
    
    private let infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        infoLabel.numberOfLines = 1
        infoLabel.text = "Welcome to djay!"
        infoLabel.textAlignment = .center
        infoLabel.textColor = .white
        infoLabel.tag = AwardsTransitionTags.introInfoLabel.rawValue
        return infoLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.addSubviews(
            infoLabel,
            logoImageView
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        logoImageView.frame = .init(
            x: width * 0.5 - Style.logoSize.width * 0.5,
            y: height * 0.40,
            width: Style.logoSize.width,
            height: Style.logoSize.height
        ).ceilPixelRect()
        
        let infoLabelHeight = infoLabel.font.lineHeight
        
        infoLabel.frame = .init(
            x: Style.infoLabelHorizontalMargin,
            y: height - Style.infoLabelBottomMargin - infoLabelHeight,
            width: width - Style.infoLabelHorizontalMargin * 2,
            height: infoLabelHeight
        ).ceilPixelRect()
    }
}
