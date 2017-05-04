//
//  paddleView.swift
//  Air Hockey
//
//  Created by Steven Berard on 5/1/17.
//  Copyright © 2017 Steven Berard. All rights reserved.
//

import UIKit

protocol PaddleViewDelegate: class {
    func handlePanGesture(_ panGesture: UIPanGestureRecognizer, for view: UIView)
}

class PaddleView: UIView {
    
    weak var delegate: PaddleViewDelegate?
    
    private var isFirstLoad = true
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isFirstLoad {
            isFirstLoad = false
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(PaddleView.handlePanGesture(_:)))
            addGestureRecognizer(panGesture)
            
            layer.cornerRadius = bounds.height / 2
        }
    }

    func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        delegate?.handlePanGesture(panGesture, for: self)
    }
}
