//
//  ViewController.swift
//  Air Hockey
//
//  Created by Steven Berard on 5/3/17.
//  Copyright © 2017 Event Farm. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var animator: UIDynamicAnimator!
    @IBOutlet weak var topPaddle: UIView!
    @IBOutlet weak var bottomPaddle: UIView!
    @IBOutlet weak var puck: UIView!
    @IBOutlet weak var centerLine: UIView!
    @IBOutlet weak var topGoal: UIView!
    @IBOutlet weak var bottomGoal: UIView!
    
    var topSnapBehavior: UISnapBehavior?
    var bottomSnapBehavior: UISnapBehavior?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: view)
        
        let collisionBehavior = UICollisionBehavior(items: [puck, bottomPaddle, topPaddle])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
        
        let paddleSideCollisionBehavior = UICollisionBehavior(items: [topPaddle, bottomPaddle, centerLine])
        animator.addBehavior(paddleSideCollisionBehavior)
        
        let goalCollisionBehavior = UICollisionBehavior(items: [puck, topGoal, bottomGoal])
        goalCollisionBehavior.collisionDelegate = self
        animator.addBehavior(goalCollisionBehavior)
        
        let attachmentBehavior = UIAttachmentBehavior(item: centerLine, attachedToAnchor: centerLine.center)
        animator.addBehavior(attachmentBehavior)
        
        let topGoalAttachmentBehavior = UIAttachmentBehavior(item: topGoal, attachedToAnchor: topGoal.center)
        animator.addBehavior(topGoalAttachmentBehavior)
        
        let bottomGoalAttachmentBehavior = UIAttachmentBehavior(item: bottomGoal, attachedToAnchor: bottomGoal.center)
        animator.addBehavior(bottomGoalAttachmentBehavior)
        
        let dynamicItemBehavior = UIDynamicItemBehavior(items: [centerLine, topGoal, bottomGoal])
        dynamicItemBehavior.allowsRotation = false
        animator.addBehavior(dynamicItemBehavior)
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
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        
        print("This happened")
    }
}

