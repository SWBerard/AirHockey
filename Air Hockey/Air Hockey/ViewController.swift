//
//  ViewController.swift
//  Air Hockey
//
//  Created by Steven Berard on 5/1/17.
//  Copyright © 2017 Steven Berard. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate, PaddleViewDelegate {
    
    var animator: UIDynamicAnimator!
    
    var topPaddle: PaddleView!
    var bottomPaddle: PaddleView!
    var puck: CircleView!
    
    var topSnap: UISnapBehavior?
    var bottomSnap: UISnapBehavior?
    var paddleBehavior: UIDynamicItemBehavior!

    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var middleView: UIView!
    
    @IBOutlet weak var topGoal: UIView!
    @IBOutlet weak var bottomGoal: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        topPaddle = PaddleView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        topPaddle.delegate = self
        topPaddle.center = topContainerView.center
        topPaddle.backgroundColor = UIColor.darkGray
        view.addSubview(topPaddle)
        
        bottomPaddle = PaddleView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        bottomPaddle.delegate = self
        bottomPaddle.center = bottomContainerView.center
        bottomPaddle.backgroundColor = UIColor.darkGray
        view.addSubview(bottomPaddle)
        
        puck = CircleView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        puck.center = view.center
        puck.backgroundColor = UIColor.black
        view.addSubview(puck)
        
        animator = UIDynamicAnimator(referenceView: view)
        
        let middleAttachment = UIAttachmentBehavior(item: middleView, attachedToAnchor: middleView.center)
        animator.addBehavior(middleAttachment)
        
        let topGoalAttachment = UIAttachmentBehavior(item: topGoal, attachedToAnchor: topGoal.center)
        animator.addBehavior(topGoalAttachment)
        
        let bottomGoalAttachment = UIAttachmentBehavior(item: bottomGoal, attachedToAnchor: bottomGoal.center)
        animator.addBehavior(bottomGoalAttachment)
        
        let rotationItemBehavior = UIDynamicItemBehavior(items: [middleView, topGoal, bottomGoal])
        rotationItemBehavior.allowsRotation = false
        animator.addBehavior(rotationItemBehavior)
        
        let puckItemBehavior = UIDynamicItemBehavior(items: [puck])
        puckItemBehavior.friction = 0.2
        puckItemBehavior.resistance = 0.2
        puckItemBehavior.angularResistance = 0.5
        puckItemBehavior.elasticity = 0.9
        animator.addBehavior(puckItemBehavior)
        
//        let gravity = UIGravityBehavior(items: [topRect, bottomRect])
//        gravity.magnitude = 1.0
//        animator.addBehavior(gravity)
        
        let collision = UICollisionBehavior(items: [topPaddle, bottomPaddle, middleView])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let puckCollision = UICollisionBehavior(items: [topPaddle, bottomPaddle, puck])
        puckCollision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(puckCollision)
        
        let goalCollision = UICollisionBehavior(items: [puck, topGoal, bottomGoal])
        goalCollision.collisionDelegate = self
        animator.addBehavior(goalCollision)
        
        paddleBehavior = UIDynamicItemBehavior(items: [topPaddle, bottomPaddle])
        paddleBehavior.allowsRotation = false
        paddleBehavior.friction = 0         // paddles should slide freely
        paddleBehavior.resistance = 0.7        // don’t bleed velocity too fast
        paddleBehavior.elasticity = 0.9        // lively bounces
        paddleBehavior.density = 10.0          // give them “mass” vs. puck
        animator.addBehavior(paddleBehavior)
    }
    
    @IBAction func userPannedInTopView(_ sender: UIPanGestureRecognizer) {
        
        let desired = sender.location(in: view)

        // Clamp so it can’t cross into/through middleView
        let x = clampedX(for: topPaddle, desiredX: desired.x)
        let y = clampTopPaddleY(desired.y, paddle: topPaddle)
        let clamped = CGPoint(x: x, y: y)
        
        if sender.state == .changed || sender.state == .began {
            topPaddle.center = clamped
            animator.updateItem(usingCurrentState: topPaddle)
            
            // velocity injection (delta form to avoid runaway)
            let desiredVel = sender.velocity(in: view)
            let currentVel = paddleBehavior.linearVelocity(for: topPaddle)
            let delta = CGPoint(x: desiredVel.x - currentVel.x, y: desiredVel.y - currentVel.y)
            paddleBehavior.addLinearVelocity(delta, for: topPaddle)
        }
    }
    
    @IBAction func userPannedInBottomView(_ sender: UIPanGestureRecognizer) {

        let desired = sender.location(in: view)

        // Clamp so it stays below/away from middleView
        let x = clampedX(for: bottomPaddle, desiredX: desired.x)
        let y = clampBottomPaddleY(desired.y, paddle: bottomPaddle)
        let clamped = CGPoint(x: x, y: y)
        
        if sender.state == .changed || sender.state == .began {
            bottomPaddle.center = clamped
            animator.updateItem(usingCurrentState: bottomPaddle)
            
            // velocity injection (delta form)
            let desiredVel = sender.velocity(in: view)
            let currentVel = paddleBehavior.linearVelocity(for: bottomPaddle)
            let delta = CGPoint(x: desiredVel.x - currentVel.x, y: desiredVel.y - currentVel.y)
            paddleBehavior.addLinearVelocity(delta, for: bottomPaddle)
        }
    }
    
    func handlePanGesture(_ panGesture: UIPanGestureRecognizer, for view: UIView) {
        if view == topPaddle {
            userPannedInTopView(panGesture)
        }
        
        if view == bottomPaddle {
            userPannedInBottomView(panGesture)
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        
        let puckSnap = UISnapBehavior(item: puck, snapTo: view.center)
        animator.addBehavior(puckSnap)
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            self.animator.removeBehavior(puckSnap)
        }
        
        let item1 = item1 as! UIView
        let item2 = item2 as! UIView
        
        if item1 == topGoal || item2 == topGoal {
            // Score 1 for top
            
            bottomContainerView.backgroundColor = UIColor.green
            
            UIView.animate(withDuration: 2.0) {
                self.bottomContainerView.backgroundColor = UIColor.white
            }
        }
        
        if item1 == bottomGoal || item2 == bottomGoal {
            // Score 1 for bottom
            
            topContainerView.backgroundColor = UIColor.green
            
            UIView.animate(withDuration: 2.0) {
                self.topContainerView.backgroundColor = UIColor.white
            }
        }
    }
    
    // Helpers
    private func clampedX(for paddle: UIView, desiredX: CGFloat) -> CGFloat {
        let half = paddle.bounds.width * 0.5
        return min(max(desiredX, half), view.bounds.width - half)
    }

    private func clampTopPaddleY(_ desiredY: CGFloat, paddle: UIView) -> CGFloat {
        let half = paddle.bounds.height * 0.5
        // Keep the whole paddle within the top container and above the middle
        let minY = topContainerView.frame.minY + half
        let maxY = min(middleView.frame.minY - half, topContainerView.frame.maxY - half)
        return min(max(desiredY, minY), maxY)
    }

    private func clampBottomPaddleY(_ desiredY: CGFloat, paddle: UIView) -> CGFloat {
        let half = paddle.bounds.height * 0.5
        // Keep the whole paddle within the bottom container and below the middle
        let minY = max(middleView.frame.maxY + half, bottomContainerView.frame.minY + half)
        let maxY = bottomContainerView.frame.maxY - half
        return min(max(desiredY, minY), maxY)
    }
}

