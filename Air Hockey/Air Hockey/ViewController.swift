//
//  ViewController.swift
//  Air Hockey
//
//  Created by Steven Berard on 5/3/17.
//  Copyright © 2017 Event Farm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var animator: UIDynamicAnimator!
    @IBOutlet weak var topPaddle: UIView!
    @IBOutlet weak var bottomPaddle: UIView!
    @IBOutlet weak var puck: UIView!
    @IBOutlet weak var centerLine: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: view)
        
        let gravityBehavior = UIGravityBehavior(items: [puck])
        gravityBehavior.magnitude = 1.0
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: [puck, bottomPaddle])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
    }
    
    @IBAction func userPannedTopView(_ sender: UIPanGestureRecognizer) {
    }
    
    @IBAction func userPannedBottomView(_ sender: UIPanGestureRecognizer) {
    }
}

