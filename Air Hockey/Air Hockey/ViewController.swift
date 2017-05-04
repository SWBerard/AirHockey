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
        
        animator = UIDynamicAnimator(referenceView: view)
        
        
    }
}

