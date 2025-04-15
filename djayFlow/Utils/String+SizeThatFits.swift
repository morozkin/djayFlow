//
//  String+SizeThatFits.swift
//  djayFlow
//
//  Created by Denis.Morozov on 12.04.2025.
//

import UIKit

func getSizeThatFits(
    _ string: String,
    font: UIFont,
    textAlignment: NSTextAlignment = .natural,
    maxWidth: CGFloat
) -> CGSize {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.setParagraphStyle(.default)
    paragraphStyle.alignment = textAlignment
    
    let attributedString = NSAttributedString(
        string: string,
        attributes: [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
    )
    
    let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
    let rectPath = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: 50000))

    let ctFrame = CTFramesetterCreateFrame(framesetter, CFRange(), CGPath(rect: rectPath, transform: nil), nil)

    guard let ctLines = CTFrameGetLines(ctFrame) as? [CTLine], !ctLines.isEmpty else {
        return .zero
    }

    var ctLinesOrigins = Array<CGPoint>(repeating: .zero, count: ctLines.count)
    // Get origins in CoreGraphics coodrinates
    CTFrameGetLineOrigins(ctFrame, CFRange(), &ctLinesOrigins)

    // Transform last origin to iOS coordinates
    let transform = CGAffineTransform(scaleX: 1, y: -1)
        .concatenating(CGAffineTransform.init(translationX: 0, y: rectPath.height))

    guard let lastCTLineOrigin = ctLinesOrigins.last?.applying(transform), let lastCTLine = ctLines.last else {
        return .zero
    }

    // Get last line metrics and get full height (relative to from origin)
    var ascent: CGFloat = 0
    var descent: CGFloat = 0
    var leading: CGFloat = 0
    CTLineGetTypographicBounds(lastCTLine, &ascent, &descent, &leading)
    let lineSpacing = (floor(ascent + descent + leading) * 0.2) + 0.5 // 20% by default, actual value depends on Paragraph

    // Calculate maximum height of the frame
    let maxHeight = lastCTLineOrigin.y + descent + leading + (lineSpacing * 0.5)
    return CGSize(width: maxWidth, height: maxHeight)
}
