//
//  FacialExpression.swift
//  DrawFace
//
//  Created by Анастасия Соколан on 05.12.17.
//  Copyright © 2017 Анастасия Соколан. All rights reserved.
//

import Foundation

struct FacialExpression {
    enum Eyes: Int {
        case open
        case close
        case squinting
    }
    enum Mouth: Int {
        case frown
        case smirk
        case neutral
        case grin
        case smile
        var sadder: Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }
        var happier: Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
    }
    var happier: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.happier)
    }
    var sadder: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.sadder)
    }
    
    let eyes: Eyes
    let mouth: Mouth
}
