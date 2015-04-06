//
//  RangeSlider.swift
//  AI Controls
//
//  Created by Anas Iqbal on 06/04/2015.
//
//

import UIKit
import QuartzCore

private typealias RangeSlider_HelperMethods = RangeSlider
private typealias RangeSlider_InputHandlers = RangeSlider

@IBDesignable
class RangeSlider: UIControl
{
	private let trackLayer = RangeSliderTrackLayer()
	private let lowerThumbLayer = RangeSliderThumbLayer()
	private let upperThumbLayer = RangeSliderThumbLayer()
	
	@IBInspectable var minimumValue: Double = 0.0 {
		didSet {
			updateLayerFrames()
		}
	}
	
	@IBInspectable var maximumValue: Double = 1.0 {
		didSet {
			updateLayerFrames()
		}
	}
	
	@IBInspectable var lowerValue: Double = 0.2 {
		didSet {
			updateLayerFrames()
		}
	}
	
	@IBInspectable var upperValue: Double = 0.8 {
		didSet {
			updateLayerFrames()
		}
	}
	@IBInspectable var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
		didSet {
			trackLayer.setNeedsDisplay()
		}
	}
	
	@IBInspectable var trackHighlightTintColor: UIColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0) {
		didSet {
			trackLayer.setNeedsDisplay()
		}
	}
	
	@IBInspectable var thumbTintColor: UIColor = UIColor.whiteColor() {
		didSet {
			lowerThumbLayer.setNeedsDisplay()
			upperThumbLayer.setNeedsDisplay()
		}
	}
	
	@IBInspectable var curvaciousness: CGFloat = 1.0 {
		didSet {
			trackLayer.setNeedsDisplay()
			lowerThumbLayer.setNeedsDisplay()
			upperThumbLayer.setNeedsDisplay()
		}
	}
	
	var previousLocation = CGPoint()
	
	var thumbWidth: CGFloat {
		return CGFloat(bounds.height)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		trackLayer.rangeSlider = self
		trackLayer.contentsScale = UIScreen.mainScreen().scale
		
		lowerThumbLayer.rangeSlider = self
		lowerThumbLayer.contentsScale = UIScreen.mainScreen().scale
		
		upperThumbLayer.rangeSlider = self
		upperThumbLayer.contentsScale = UIScreen.mainScreen().scale
		
		layer.addSublayer(trackLayer)
		layer.addSublayer(lowerThumbLayer)
		layer.addSublayer(upperThumbLayer)
		
		updateLayerFrames()
	}

	required init(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
		
		trackLayer.rangeSlider = self
		trackLayer.contentsScale = UIScreen.mainScreen().scale
		
		lowerThumbLayer.rangeSlider = self
		lowerThumbLayer.contentsScale = UIScreen.mainScreen().scale
		
		upperThumbLayer.rangeSlider = self
		upperThumbLayer.contentsScale = UIScreen.mainScreen().scale
		
		layer.addSublayer(trackLayer)
		layer.addSublayer(lowerThumbLayer)
		layer.addSublayer(upperThumbLayer)
		
		updateLayerFrames()
	}
	
	override var frame: CGRect {
		didSet {
			updateLayerFrames()
		}
	}
	
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

extension RangeSlider_HelperMethods
{
	func updateLayerFrames()
	{
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		trackLayer.frame = bounds.rectByInsetting(dx: 0.0, dy: bounds.height/3)
		trackLayer.setNeedsDisplay()
		
		let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
		lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0,
			width: thumbWidth, height: thumbWidth)
		lowerThumbLayer.setNeedsDisplay()
		
		let upperThumbCenter = CGFloat(positionForValue(upperValue))
		upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0,
			width: thumbWidth, height: thumbWidth)
		upperThumbLayer.setNeedsDisplay()
		
		CATransaction.commit()
	}
	
	func positionForValue(value: Double) -> Double {
		return Double(bounds.width - thumbWidth) * (value - minimumValue) /
			(maximumValue - minimumValue) + Double(thumbWidth / 2.0)
	}
}

extension RangeSlider_InputHandlers
{
	func boundValue(value: Double, toLowerValue lowerValue:Double, upperValue: Double) -> Double {
		return min(max(value, lowerValue), upperValue)
	}
	
	override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
		previousLocation = touch.locationInView(self)
		
		if(lowerThumbLayer.frame.contains(previousLocation)) {
			lowerThumbLayer.highlighted = true
		} else if (upperThumbLayer.frame.contains(previousLocation)) {
			upperThumbLayer.highlighted = true
		}
		
		return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
	}
	
	override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
		let location = touch.locationInView(self)
		
		let deltaLocation = Double(location.x - previousLocation.x)
		let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth)
		
		previousLocation = location
		
		if lowerThumbLayer.highlighted {
			lowerValue += deltaValue
			lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
		} else if upperThumbLayer.highlighted {
			upperValue += deltaValue
			upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
		}
		
		sendActionsForControlEvents(.ValueChanged)
		
		return true
	}
	
	override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
		lowerThumbLayer.highlighted = false
		upperThumbLayer.highlighted = false
	}
}








