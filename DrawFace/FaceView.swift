//
//  FaceView.swift
//  DrawFace
//
//  Created by Анастасия Соколан on 02.12.17.
//  Copyright © 2017 Анастасия Соколан. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    @IBInspectable
    var scale: CGFloat = 0.85 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable
    var isOpenEyes: Bool = false {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable
    var mouthCurvature: Double = 1.0 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable
    var lineWidth: CGFloat = 4.0 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable
    var color: UIColor = UIColor.red {
        didSet { setNeedsDisplay() }
    }
    
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    private var centerPoint: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    private enum Eye {
        case left
        case right
    }
    private struct Ratios {
        static let skullRadiusToEyeOffset : CGFloat = 3
        static let skullRadiusToEyeRadius : CGFloat = 10
        static let skullRadiusMouthWidth : CGFloat = 1
        static let skullRadiusMouthHeight : CGFloat = 3
        static let skullRadiusMouthOffset : CGFloat = 3
    }
    
    private func drawSkull() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: centerPoint, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
    private func drawEye(_ eye: Eye) -> UIBezierPath {
        func centerOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = centerPoint
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .right) ? 1 : -1) * eyeOffset
            return eyeCenter
        }
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        let eyePath: UIBezierPath
        if isOpenEyes {
            eyePath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        }
        else {
            eyePath = UIBezierPath()
            eyePath.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            eyePath.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        eyePath.lineWidth = lineWidth
        return eyePath
    }
    private func drawMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.skullRadiusMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusMouthOffset
        
        let mouthRect = CGRect(
            x: centerPoint.x - mouthWidth / 2,
            y: centerPoint.y + mouthOffset,
            width: mouthWidth,
            height: mouthHeight)
        
        let startPoint = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let endPoint = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        
        let cp1 = CGPoint(x: startPoint.x + mouthRect.width / 3, y: startPoint.y + smileOffset)
        let cp2 = CGPoint(x: endPoint.x - mouthRect.width / 3, y: startPoint.y + smileOffset)
        
        let mouthPath = UIBezierPath()
        mouthPath.move(to: startPoint)
        mouthPath.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        mouthPath.lineWidth = lineWidth
        return mouthPath
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        color.set()
        drawSkull().stroke()
        drawEye(.left).stroke()
        drawEye(.right).stroke()
        drawMouth().stroke()
    }
    
    @objc func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1.0
        default:
            break
        }
        
    }
}
