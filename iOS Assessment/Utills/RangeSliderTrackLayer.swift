//
//  RangeSliderTrackLayer.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 24/01/22.
//

import Foundation
import UIKit
import QuartzCore

// Renders the track that the two thumbs slide on
class RangeSliderTrackLayer: CALayer {
    weak var rangeSlider: RangeSlider?
    
    
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            // Clip the track shape
            let cornerRadius = bounds.height * slider.curvaceousness / 2.0
            let trackOriginY = bounds.height * (1-slider.trackSizeScale) / 2  // get the right y-offset if the track is scaled
            let scaledBounds = CGRect(x: 0, y: trackOriginY, width: bounds.width, height: bounds.height * slider.trackSizeScale)
            let path = UIBezierPath(roundedRect: scaledBounds, cornerRadius: cornerRadius)
            ctx.addPath(path.cgPath)
            
            // Fill the track
            ctx.setFillColor(slider.trackTintColor.cgColor)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
            
            // Fill the highlighted range
            ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
            let lowerValuePosition = CGFloat(slider.positionForValue(value: slider.lowerValue))
            let upperValuePosition = CGFloat(slider.positionForValue(value: slider.upperValue))
            let rect = CGRect(x: lowerValuePosition, y: trackOriginY, width: upperValuePosition - lowerValuePosition, height: scaledBounds.height)
            ctx.fill(rect)
        }
    }
    
    
}
