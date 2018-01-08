//
//  EmotionsViewController.swift
//  DrawFace
//
//  Created by Анастасия Соколан on 23.12.17.
//  Copyright © 2017 Анастасия Соколан. All rights reserved.
//

import UIKit

class EmotionsViewController: VCLLoggingViewController {
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    private let emotions: Dictionary<String, FacialExpression> = [
        "sad" : FacialExpression(eyes: .close, mouth: .frown),
        "happy" : FacialExpression(eyes: .open, mouth: .smile),
        "worried" : FacialExpression(eyes: .open, mouth: .smirk)
    ]
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if let faceViewController = destinationViewController as? FaceViewController,
            let identifier = segue.identifier,
            let expression = emotions[identifier] {
            faceViewController.expression = expression
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
