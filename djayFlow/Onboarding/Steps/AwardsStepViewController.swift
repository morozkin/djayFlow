//
//  AwardsStepViewController.swift
//  djayFlow
//
//  Created by Denis.Morozov on 12.04.2025.
//

import UIKit

final class AwardsStepViewController: UIViewController {
    private enum Style {
        static let interItemSpacing = 32.0
        static let textHorizontalMargin = 32.0
        
        static let devicesImageHeight = 140.0
    }
    
    private let logoImageView: UIImageView = {
        let logoImageView = UIImageView(image: UIImage(resource: .djay))
        logoImageView.tag = AwardsTransitionTags.awardsLogo.rawValue
        return logoImageView
    }()
    
    private let devicesImageView: UIImageView = {
        let devicesImageView = UIImageView(image: UIImage(resource: .hero))
        devicesImageView.contentMode = .scaleAspectFill
        devicesImageView.tag = AwardsTransitionTags.awardsDevices.rawValue
        return devicesImageView
    }()
    
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Mix Your \nFavorite Music"
        textLabel.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 11 / 34
        textLabel.tag = AwardsTransitionTags.awardsText.rawValue
        return textLabel
    }()
    
    private let adaImageView: UIImageView = {
        let adaImageView = UIImageView(image: UIImage(resource: .ada))
        adaImageView.tag = AwardsTransitionTags.awardsAda.rawValue
        return adaImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.addSubviews(
            logoImageView,
            devicesImageView,
            textLabel,
            adaImageView
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height = view.bounds.height
        let width = view.bounds.width
        
        let logoSize = logoImageView.intrinsicContentSize
        
        logoImageView.frame = .init(
            x: width * 0.5 - logoSize.width * 0.5,
            y: height * 0.19,
            width: logoSize.width,
            height: logoSize.height
        ).ceilPixelRect()
        
        let devicesSize = devicesImageView.intrinsicContentSize
        
        devicesImageView.frame = .init(
            x: width * 0.5 - devicesSize.width * 0.5,
            y: logoImageView.frame.maxY + Style.interItemSpacing,
            width: devicesSize.width,
            height: Style.devicesImageHeight
        ).ceilPixelRect()
        
        let adaSize = adaImageView.intrinsicContentSize
        
        let remainingHeightForText = height - devicesImageView.frame.maxY - Style.interItemSpacing
            - adaSize.height - Style.interItemSpacing * 2
        
        let textSize = getSizeThatFits(
            textLabel.text!,
            font: textLabel.font,
            textAlignment: textLabel.textAlignment,
            maxWidth: width - Style.textHorizontalMargin * 2
        )
        
        textLabel.frame = .init(
            x: width * 0.5 - textSize.width * 0.5,
            y: devicesImageView.frame.maxY + Style.interItemSpacing,
            width: textSize.width,
            height: min(remainingHeightForText, textSize.height)
        ).ceilPixelRect()
        
        adaImageView.frame = .init(
            x: width * 0.5 - adaSize.width * 0.5,
            y: textLabel.frame.maxY + Style.interItemSpacing,
            width: adaSize.width,
            height: adaSize.height
        ).ceilPixelRect()
    }
}
