//
//  CircleView.swift
//  Air Hockey
//
//  Created by Steven Berard on 5/1/17.
//  Copyright © 2017 Steven Berard. All rights reserved.
//

import UIKit

class CircleView: UIView {

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    
    var isFirstLoad = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isFirstLoad {
            isFirstLoad = false
            
            layer.cornerRadius = bounds.height / 2
        }
    }
}
