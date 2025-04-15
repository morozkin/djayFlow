//
//  UIImage+Generation.swift
//  djayFlow
//
//  Created by Denis.Morozov on 12.04.2025.
//

import UIKit

extension UIImage {
    static func resizableImage(of color: UIColor, cornerRadius: CGFloat) -> UIImage {
        let size = cornerRadius * 2.0 + 1.0
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let image = renderer.image { ctx in
            let path = UIBezierPath(
                roundedRect: renderer.format.bounds,
                cornerRadius: cornerRadius
            )
            path.addClip()
            
            color.setFill()
            ctx.fill(renderer.format.bounds)
        }
        return image.resizableImage(
            withCapInsets: UIEdgeInsets(
                top: cornerRadius,
                left: cornerRadius,
                bottom: cornerRadius,
                right: cornerRadius
            )
        )
    }
    
    static func resizableImage(
        of color: UIColor,
        borderColor: UIColor,
        cornerRadius: CGFloat
    ) -> UIImage {
        let size = cornerRadius * 2.0 + 1.0
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let image = renderer.image { ctx in
            let path = UIBezierPath(
                roundedRect: renderer.format.bounds,
                cornerRadius: cornerRadius
            )
            path.addClip()
            
            color.setFill()
            ctx.fill(renderer.format.bounds)
            
            borderColor.setStroke()
            path.lineWidth = 4.0
            path.stroke()
        }
        return image.resizableImage(
            withCapInsets: UIEdgeInsets(
                top: cornerRadius,
                left: cornerRadius,
                bottom: cornerRadius,
                right: cornerRadius
            )
        )
    }
}
