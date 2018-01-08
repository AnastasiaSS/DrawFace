//
//  ViewController.swift
//  DrawFace
//
//  Created by Анастасия Соколан on 02.12.17.
//  Copyright © 2017 Анастасия Соколан. All rights reserved.
//

import UIKit

@objcMembers class FaceViewController : VCLLoggingViewController {
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(byReactingTo:)))
            faceView.addGestureRecognizer(pinchRecognizer)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
            
           tapRecognizer.numberOfTapsRequired = 1
            faceView.addGestureRecognizer(tapRecognizer)
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpRecognizer.direction = .up
            faceView.addGestureRecognizer(swipeUpRecognizer)
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeUpRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeDownRecognizer)
            updateUI()
        }
    }
    var expression = FacialExpression(eyes: .open, mouth: .neutral) {
        didSet {
            updateUI()
        }
    }
    func increaseHappiness() {
        expression = expression.happier
    }
    func decreaseHappiness() {
        expression = expression.sadder
    }
    private let mouthCurvatures = [
        FacialExpression.Mouth.frown : -1.0,
        .smirk : -0.5,
        .neutral : 0.0,
        .grin : 0.5,
        .smile : 1.0]
    
    func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .close) ? .open : .close
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    private func updateUI() {
        switch expression.eyes {
        case .open:
            faceView?.isOpenEyes = true
        case .close:
            faceView?.isOpenEyes = false
        case .squinting:
            faceView?.isOpenEyes = false
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }
}

