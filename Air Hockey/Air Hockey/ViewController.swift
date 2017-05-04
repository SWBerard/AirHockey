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
    
    var topSnapBehavior: UISnapBehavior?
    var bottomSnapBehavior: UISnapBehavior?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: view)
        
        let gravityBehavior = UIGravityBehavior(items: [puck])
        gravityBehavior.magnitude = 1.0
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: [puck, bottomPaddle, topPaddle])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
    }
    
    @IBAction func userPannedTopView(_ sender: UIPanGestureRecognizer) {
        
        if topSnapBehavior != nil {
            animator.removeBehavior(topSnapBehavior!)
        }
        
        switch sender.state {
        case .began, .changed:
            topSnapBehavior = UISnapBehavior(item: topPaddle, snapTo: sender.location(in: view))
            animator.addBehavior(topSnapBehavior!)
        default:
            break
        }
    }
    
    @IBAction func userPannedBottomView(_ sender: UIPanGestureRecognizer) {
        
        if bottomSnapBehavior != nil {
            animator.removeBehavior(bottomSnapBehavior!)
        }
        
        switch sender.state {
        case .began, .changed:
            bottomSnapBehavior = UISnapBehavior(item: bottomPaddle, snapTo: sender.location(in: view))
            animator.addBehavior(bottomSnapBehavior!)
        default:
            break
        }
    }
}

