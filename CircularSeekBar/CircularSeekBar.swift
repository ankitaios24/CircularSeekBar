//
//  CircularSeekBar.swift
//  CircularSeekBar
//
//  Created by Ankita Thakur on 11/08/24.
//

import UIKit

@IBDesignable
class CircularSeekBar: UIControl {
    
    @IBInspectable var minimumValue: CGFloat = 0
    @IBInspectable var maximumValue: CGFloat = 100
    @IBInspectable var value: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var barWidth: CGFloat = 8.0
    @IBInspectable var progressGradientColors: [UIColor] = [.green, .yellow, .red]
    @IBInspectable var innerThumbRadius: CGFloat = 5.0
    @IBInspectable var outerThumbRadius: CGFloat = 10.0
    @IBInspectable var startAngle: CGFloat = 135
    @IBInspectable var sweepAngle: CGFloat = 270
    @IBInspectable var dashWidth: CGFloat = 1
    @IBInspectable var dashGap: CGFloat = 2
    @IBInspectable var extraDashGap: CGFloat = 2 // Extra gap to increase spacing

    private var radius: CGFloat {
        return min(bounds.width, bounds.height) / 2 - outerThumbRadius
    }
    
    private var centerPoint: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        // Draw progress bar with gradient
        let progressPath = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: startAngle.toRadians(), endAngle: (startAngle + sweepAngle * (value / maximumValue)).toRadians(), clockwise: true)
        
        context?.setLineWidth(barWidth)
        context?.saveGState()
        context?.addPath(progressPath.cgPath)
        context?.replacePathWithStrokedPath()
        context?.clip()
        
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: progressGradientColors.map { $0.cgColor } as CFArray, locations: nil)!
        context?.drawLinearGradient(gradient, start: CGPoint(x: 0, y: bounds.midY), end: CGPoint(x: bounds.maxX, y: bounds.midY), options: [])
        context?.restoreGState()
        
        // Draw dashes from inside to outside
        let dashPath = UIBezierPath()
        for i in stride(from: 0, through: sweepAngle, by: dashWidth + dashGap + extraDashGap) {
            let dashAngle = (startAngle + CGFloat(i)).toRadians()
            let innerDashPoint = CGPoint(x: centerPoint.x + (radius - barWidth / 2) * cos(dashAngle), y: centerPoint.y + (radius - barWidth / 2) * sin(dashAngle))
            let outerDashPoint = CGPoint(x: centerPoint.x + (radius + barWidth / 2) * cos(dashAngle), y: centerPoint.y + (radius + barWidth / 2) * sin(dashAngle))
            dashPath.move(to: innerDashPoint)
            dashPath.addLine(to: outerDashPoint)
        }
        context?.setLineWidth(dashWidth)
        UIColor.black.setStroke()
        dashPath.stroke()
        
        // Draw handle
        let handleAngle = (startAngle + sweepAngle * (value / maximumValue)).toRadians()
        let handleCenter = CGPoint(x: centerPoint.x + radius * cos(handleAngle), y: centerPoint.y + radius * sin(handleAngle))
        context?.setLineWidth(innerThumbRadius * 2)
        UIColor.white.setFill()
        context?.fillEllipse(in: CGRect(x: handleCenter.x - innerThumbRadius, y: handleCenter.y - innerThumbRadius, width: innerThumbRadius * 2, height: innerThumbRadius * 2))
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        updateValue(for: location)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
    }
    
    private func updateValue(for location: CGPoint) {
        let angle = atan2(location.y - centerPoint.y, location.x - centerPoint.x).toDegrees()
        let adjustedAngle = (angle - startAngle + 360).truncatingRemainder(dividingBy: 360)
        value = min(maximumValue, max(minimumValue, maximumValue * adjustedAngle / sweepAngle))
        sendActions(for: .valueChanged)
        setNeedsDisplay()
    }
}

private extension CGFloat {
    func toRadians() -> CGFloat {
        return self * .pi / 180
    }
    
    func toDegrees() -> CGFloat {
        return self * 180 / .pi
    }
}

