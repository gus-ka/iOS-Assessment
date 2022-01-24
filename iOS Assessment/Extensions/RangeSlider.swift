//
//  RangeSlider.swift
//  iOS Assessment
//
//  Created by Eva Tamara on 24/01/22.
//

import Foundation
import UIKit
import QuartzCore


@IBDesignable
class RangeSlider: UIControl {
    
    @IBInspectable
    var hapticsOn: Bool = false { didSet { updateLayerFrames() } }
    
    // Number of discrete steps for the slider over the full range
    @IBInspectable
    var discreteSteps: Int = 0 { didSet { updateLayerFrames() } }
    
    @IBInspectable
    var minimumValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable
    var maximumValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable
    var lowerValue: Double = 0.2 {
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable
    var upperValue: Double = 0.8 {
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable
    var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var trackHighlightTintColor: UIColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var thumbLineWidth: CGFloat = 1.0 {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var thumbStrokeColor: UIColor = UIColor.gray {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var thumbTintColor: UIColor = UIColor.white {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var thumbType: Int = 0 {                  // e.g. number of corners:  0 = circle, 2 = line , 3 = triangle, 4 = square
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var trackSizeScale: CGFloat = 1.0  {    // to force track size relative to thumbs
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }

    @IBInspectable
    var curvaceousness: CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    // These three layers — trackLayer, lowerThumbLayer, and upperThumbLayer — are used to render the various components of the slider control. thumbWidth is used for layout purposes.
    let trackLayer = RangeSliderTrackLayer()
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
    
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    var previousLocation = CGPoint()       // track the touch locations
    let haptic = UISelectionFeedbackGenerator()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale  // make sure it looks good on retina displays
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.rangeSlider = self
        upperThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(upperThumbLayer)
        
        updateLayerFrames()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale  // make sure it looks good on retina displays
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.rangeSlider = self
        upperThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(upperThumbLayer)
        
        updateLayerFrames()
    }
    
    // Override frame to implement a property observer that updates the layer frames when the frame changes.
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue))
        
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0,
                                       width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(value: upperValue))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0,
                                       width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        CATransaction.commit()
    }
    
    
    // Maps a value to a location on screen using a simple ratio to scale the position between the minimum and maximum range of the control
    func positionForValue(value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    
    
    // Invoked when the user first touches the control. The return value for the method informs the UIControl superclass whether subsequent touches should be tracked.
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        // Hit test the thumb layers
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = true
        }
        if hapticsOn {
            haptic.prepare()
        }
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    
    // Makes sure the passed in value is within the specified range
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        if discreteSteps > 0 {
            let step = (maximumValue - minimumValue) / Double(discreteSteps)
            let roundedValue = round(value / step) * step
            return min(max(roundedValue, lowerValue), upperValue)
        }
        
        return min(max(value, lowerValue), upperValue)
    }
    
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        var deltaValue: Double
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        deltaValue = round((maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth))
        
        if discreteSteps > 0 {
            if abs(deltaLocation) >=   Double(bounds.width - thumbWidth) / Double(discreteSteps) {
                deltaValue = round((maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth))
                previousLocation = location
                if hapticsOn {
                    haptic.selectionChanged()
                }
            } else {
                return true
            }
        } else {
            deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth)
            previousLocation = location
        }
        
        // 2. Update the values
        if lowerThumbLayer.highlighted {
            lowerValue = min(lowerValue + deltaValue, upperValue - Double(thumbWidth / 3))
            lowerValue = boundValue(value: lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        } else if upperThumbLayer.highlighted {
            upperValue = max(upperValue + deltaValue, lowerValue + Double(thumbWidth / 3))
            upperValue = boundValue(value: upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }
        
        // 3. Update the UI
        sendActions(for: .valueChanged)     // notify any subscribed targets of the changes
        return true
    }
        
    
    // Handle the end of the touch and drag events. Resets both thumbs to a non-highlighted state.
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
        
    }
    
    
}
