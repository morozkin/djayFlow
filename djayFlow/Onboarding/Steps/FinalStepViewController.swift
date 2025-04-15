//
//  FinalStepViewController.swift
//  djayFlow
//
//  Created by Denis.Morozov on 14.04.2025.
//

import UIKit

final class FinalStepViewController: UIViewController {
    fileprivate enum Style {
        static let centerCircleSize = 6.0 * 3
        static let innerCircleSize = 20.0 * 3
        static let outerCircleSize = 48.0 * 3
        static let textLabelMargin = 32.0
    }
    
    // UIView can be replaced by CAShaperLayer, but then the animation must be adjusted
    // because SwiftUI animation does not use CA, and so CALayers are not animated
    private let centerCircle = UIView()
    private let innerCircle = UIView()
    private let outerCircle = UIView()
    private let gradient = CAGradientLayer()
    
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "We are all set!"
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 1
        return textLabel
    }()
    
    private let confettiView = ConfettiView()
    
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator!
    private var successFeedbackGenerator: UINotificationFeedbackGenerator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews(
            confettiView,
            outerCircle,
            innerCircle,
            centerCircle,
            textLabel
        )
        
        centerCircle.backgroundColor = .white
        centerCircle.layer.cornerRadius = Style.centerCircleSize * 0.5
        centerCircle.isHidden = true
        
        innerCircle.backgroundColor = UIColor(resource: .baseOrange)
        innerCircle.layer.cornerRadius = Style.innerCircleSize * 0.5
        innerCircle.isHidden = true
        
        outerCircle.layer.cornerRadius = Style.outerCircleSize * 0.5
        outerCircle.clipsToBounds = true
        outerCircle.isHidden = true
        outerCircle.layer.addSublayer(gradient)
        
        gradient.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradient.colors = [
            UIColor(resource: .circleGradientTop).cgColor,
            UIColor(resource: .circleGradientBottom).cgColor
        ]
        
        textLabel.alpha = 0.0
        textLabel.transform = CGAffineTransform.identity.translatedBy(x: 0.0, y: -Style.textLabelMargin)
        
        
        innerCircle.transform = CGAffineTransform.identity.scaledBy(x: .ulpOfOne, y: .ulpOfOne)
        outerCircle.transform = CGAffineTransform.identity.scaledBy(x: .ulpOfOne, y: .ulpOfOne)
        
        impactFeedbackGenerator = UIImpactFeedbackGenerator(view: view)
        successFeedbackGenerator = UINotificationFeedbackGenerator(view: view)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        centerCircle.transform = CGAffineTransform.identity
            .translatedBy(
                x: 0.0,
                y: -view.bounds.height * 0.5 - Style.centerCircleSize
            )
        CATransaction.commit()
        
        successFeedbackGenerator.prepare()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        centerCircle.isHidden = false
        innerCircle.isHidden = false
        outerCircle.isHidden = false
        
        UIView.animate(.bouncy(duration: 0.7, extraBounce: 0.1)) {
            centerCircle.transform = .identity
        }
                       
        UIView.animate(
            .snappy(duration: 0.55, extraBounce: 0.1).delay(0.9),
            changes: {
                innerCircle.transform = .identity
            },
            completion: {
                self.confettiView.emit(
                    with: [
                        .shape(.circle, color: .baseOrange),
                        .shape(.circle, color: .white),
                        .shape(.circle, color: .circleGradientTop),
                        .shape(.square, color: .white),
                        .shape(.square, color: .secondaryText),
                    ]
                )
                
                self.successFeedbackGenerator.notificationOccurred(.success)
            }
        )
        
        UIView.animate(.snappy(duration: 0.55, extraBounce: 0.25).delay(1.4)) {
            outerCircle.transform = .identity
        }
        
        UIView.animate(.snappy(duration: 0.45, extraBounce: 0).delay(1.5)) {
            textLabel.transform = .identity
            textLabel.alpha = 1.0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        centerCircle.frame = .init(
            x: width * 0.5 - Style.centerCircleSize * 0.5,
            y: height * 0.5 - Style.centerCircleSize * 0.5,
            width: Style.centerCircleSize,
            height: Style.centerCircleSize
        ).ceilPixelRect()
        
        innerCircle.frame = .init(
            x: width * 0.5 - Style.innerCircleSize * 0.5,
            y: height * 0.5 - Style.innerCircleSize * 0.5,
            width: Style.innerCircleSize,
            height: Style.innerCircleSize
        ).ceilPixelRect()
        
        outerCircle.frame = .init(
            x: width * 0.5 - Style.outerCircleSize * 0.5,
            y: height * 0.5 - Style.outerCircleSize * 0.5,
            width: Style.outerCircleSize,
            height: Style.outerCircleSize
        ).ceilPixelRect()
        
        gradient.frame = .init(origin: .zero, size: CGSize(width: Style.outerCircleSize, height: Style.outerCircleSize))
        
        textLabel.frame = .init(
            x: Style.textLabelMargin,
            y: height * 0.5 + Style.outerCircleSize * 0.5 + Style.textLabelMargin,
            width: width - Style.textLabelMargin * 2,
            height: textLabel.font.lineHeight
        ).ceilPixelRect()
        
        confettiView.frame = view.bounds
    }
}

// MARK: - Confetti

// Slightly modified version of https://github.com/NSHipster/ConfettiView

private let kAnimationLayerKey = "com.nshipster.animationLayer"

/// A view that emits confetti.
private final class ConfettiView: UIView {
    public init() {
        super.init(frame: .zero)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        isUserInteractionEnabled = false
    }

    // MARK: -

    /**
     Emits the provided confetti conten.

     - Parameters:
        - contents: The contents to be emitted as confetti.
        - completion: A block called once after the confetti is done emitting.
                      This block takes a single Boolean argument
                      denoting whether the transition animation has completed
                      by reaching the end of its duration.
    */
    public func emit(with contents: [Content], completion: ((Bool) -> Void)? = nil) {
        let layer = Layer()
        layer.configure(with: contents)
        layer.frame = self.bounds
        layer.needsDisplayOnBoundsChange = true
        layer.completion = completion
        self.layer.addSublayer(layer)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let transition = CATransition()
            transition.delegate = self
            transition.type = .fade
            transition.duration = 1
            transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
            transition.setValue(layer, forKey: kAnimationLayerKey)
            transition.isRemovedOnCompletion = false

            layer.add(transition, forKey: nil)

            layer.opacity = 0
        }
        
        let birthRateAnimation = CABasicAnimation()
        birthRateAnimation.duration = 1
        birthRateAnimation.fromValue = 1
        birthRateAnimation.toValue = 0
        
        layer.add(birthRateAnimation, forKey: "birthRate")
        layer.birthRate = 0.0

        let animation = CAKeyframeAnimation()
        animation.duration = 4.0
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 1]
        animation.values = [10, 20, 40, 80, 4000]
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)

        for content in contents {
            layer.add(animation, forKey: "emitterCells.\(content.id).yAcceleration")
        }
        CATransaction.commit()
    }

    // MARK: UIView

    override public func willMove(toSuperview newSuperview: UIView?) {
        guard let superview = newSuperview else {
            self.layer.removeAllAnimations()
            return
        }

        frame = superview.bounds
        isUserInteractionEnabled = false
    }

    // MARK: -

    /// Content to be emitted as confetti
    public enum Content {
        /// Confetti shapes
        public enum Shape {
            /// A circle.
            case circle

            /// A triangle.
            case triangle

            /// A square.
            case square

            // A custom shape.
            case custom(CGPath)
        }
        
        var id: String {
            switch self {
            case .shape(_, _, let id):
                id
            case .image(_, _, let id):
                id
            case .text(_, _, let id):
                id
            }
        }

        /// A shape with a particular color.
        case shape(Shape, color: UIColor, id: String = UUID().uuidString)

        /// An image with an optional tint color.
        case image(UIImage, color: UIColor?, id: String = UUID().uuidString)

        /// A string of characters.
        case text(String, size: Double = 16.0, id: String = UUID().uuidString)
    }

    // MARK: -

    private final class Layer: CAEmitterLayer {
        var completion: ((Bool) -> Void)?

        func configure(with contents: [Content]) {
            emitterCells = contents.map { content in
                let cell = CAEmitterCell()
                
                cell.name = content.id
                
                cell.contents = content.image.cgImage
                if let color = content.color {
                    cell.color = color.cgColor
                }

                cell.beginTime = CACurrentMediaTime()
                cell.birthRate = 100.0
                cell.lifetime = 10.0
                
                cell.velocityRange = 1000
                
                cell.emissionRange = .pi
                cell.emissionLongitude = .pi
                
                cell.spin = .pi * 3
                cell.spinRange = .pi * 3
                
                cell.scale = 0.2
                cell.scaleRange = 0.2
                cell.scaleSpeed = 0.0
                
                
                cell.setValue("plane", forKey: "particleType")
                cell.setValue(Double.pi, forKey: "orientationRange")
                cell.setValue(Double.pi / 2, forKey: "orientationLongitude")
                cell.setValue(Double.pi / 2, forKey: "orientationLatitude")

                return cell
            }
        }

        // MARK: CALayer

        override func layoutSublayers() {
            super.layoutSublayers()
            
            emitterMode = .outline
            emitterShape = .line
            emitterSize = CGSize(
                width: FinalStepViewController.Style.outerCircleSize,
                height: FinalStepViewController.Style.outerCircleSize
            )
            emitterPosition = CGPoint(x: frame.midX, y: frame.midY)
        }
    }
}

// MARK: - CAAnimationDelegate

extension ConfettiView: CAAnimationDelegate {
    public func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        if let layer = animation.value(forKey: kAnimationLayerKey) as? Layer {
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
            layer.completion?(flag)
        }
    }
}

// MARK: -

fileprivate extension ConfettiView.Content.Shape {
    func path(in rect: CGRect) -> CGPath {
        switch self {
        case .circle:
            return CGPath(ellipseIn: rect, transform: nil)
        case .triangle:
            let path = CGMutablePath()
            path.addLines(between: [
                CGPoint(x: rect.midX, y: 0),
                CGPoint(x: rect.maxX, y: rect.maxY),
                CGPoint(x: rect.minX, y: rect.maxY),
                CGPoint(x: rect.midX, y: 0)
            ])

            return path
        case .square:
            return CGPath(rect: rect, transform: nil)
        case .custom(let path):
            return path
        }
    }

    func image(with color: UIColor) -> UIImage {
        let rect = CGRect(origin: .zero, size: CGSize(width: 12.0, height: 12.0))
        return UIGraphicsImageRenderer(size: rect.size).image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.addPath(path(in: rect))
            context.cgContext.fillPath()
        }
    }
}

fileprivate extension ConfettiView.Content {
    var color: UIColor? {
        switch self {
        case let .image(_, color?, _),
             let .shape(_, color, _):
            return color
        default:
            return nil
        }
    }

    var image: UIImage {
        switch self {
        case let .shape(shape, _, _):
            return shape.image(with: .white)
        case let .image(image, _, _):
            return image
        case let .text(string, size, _):
            let defaultAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: CGFloat(size))
            ]

            return NSAttributedString(string: "\(string)", attributes: defaultAttributes).image()
        }
    }
}

fileprivate extension NSAttributedString {
    func image() -> UIImage {
        return UIGraphicsImageRenderer(size: size()).image { _ in
            self.draw(at: .zero)
        }
    }
}
