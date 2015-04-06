//
//  RangeSliderThumbLayer.swift
//  AI Controls
//
//  Created by Anas Iqbal on 06/04/2015.
//
//

import UIKit
import QuartzCore

class RangeSliderThumbLayer: CALayer
{
	var highlighted: Bool = false {
		didSet {
			setNeedsDisplay()
		}
	}
	weak var rangeSlider: RangeSlider?
	
	override func drawInContext(ctx: CGContext!) {
		if let slider = rangeSlider {
			let thumbFrame = bounds.rectByInsetting(dx: 2.0, dy: 2.0)
			let cornerRadius = thumbFrame.height * slider.curvaciousness/2.0
			let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
			
			// fill with shadow
			let shadowColor = UIColor.grayColor()
			CGContextSetShadowWithColor(ctx, CGSize(width: 0.0, height: 1.0), 1.0, shadowColor.CGColor)
			CGContextSetFillColorWithColor(ctx, slider.thumbTintColor.CGColor)
			CGContextAddPath(ctx, thumbPath.CGPath)
			CGContextFillPath(ctx)
			
			//outline
			CGContextSetStrokeColorWithColor(ctx, shadowColor.CGColor)
			CGContextSetLineWidth(ctx, 0.5)
			CGContextAddPath(ctx, thumbPath.CGPath)
			CGContextStrokePath(ctx)
			
			if highlighted {
				CGContextSetFillColorWithColor(ctx, UIColor(white: 0.0, alpha: 0.1).CGColor)
				CGContextAddPath(ctx, thumbPath.CGPath)
				CGContextFillPath(ctx)
			}
		}
	}
}
