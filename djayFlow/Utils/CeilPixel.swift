//
//  CeilPixel.swift
//  djayFlow
//
//  Created by Denis.Morozov on 12.04.2025.
//

import UIKit

extension BinaryFloatingPoint {
    func ceilPixelValue() -> Self {
        let scale = Self(UIScreen.main.scale)
        return ceil((self - .ulpOfOne) * scale) / scale
    }
    
    func roundPixelValue() -> Self {
        let scale = Self(UIScreen.main.scale)
        return (self * scale).rounded() / scale
    }
}

extension CGRect {
    func ceilPixelRect() -> CGRect {
        let origin = CGPoint(
            x: self.origin.x.ceilPixelValue(),
            y: self.origin.y.ceilPixelValue()
        )
        
        let size = CGSize(
            width: self.size.width.ceilPixelValue(),
            height: self.size.height.ceilPixelValue()
        )
        
        return CGRect(origin: origin, size: size)
    }
    
    func roundPixelRect() -> CGRect {
        let origin = CGPoint(
            x: self.origin.x.roundPixelValue(),
            y: self.origin.y.roundPixelValue()
        )
        
        let size = CGSize(
            width: self.size.width.roundPixelValue(),
            height: self.size.height.roundPixelValue()
        )
        
        return CGRect(origin: origin, size: size)
    }
}

extension CGSize {
    func rounded() -> CGSize {
        CGSize(width: width.rounded(), height: height.rounded())
    }
}
