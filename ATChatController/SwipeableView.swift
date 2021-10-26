//
//  SwipeableView.swift
//  DearJini
//
//  Created by Creator-$ on 7/16/19.
//  Copyright © 2019 tiwariammit@mail.com. All rights reserved.
//

import Foundation
import UIKit

class SwipeView: UIView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .green
        return label
    }()
    
    let visableView = UIView()
    var originalPoint: CGPoint!
    var maxSwipe: CGFloat! = 50 {
        didSet(newValue) {
            maxSwipe = newValue
        }
    }
    
    @IBInspectable var swipeBufffer: CGFloat = 2.0
    @IBInspectable var highVelocity: CGFloat = 300.0
    
    private let originalXCenter: CGFloat = UIScreen.main.bounds.width / 2
    private var panGesture: UIPanGestureRecognizer!
    
    public var isPanGestureEnabled: Bool {
        get { return panGesture.isEnabled }
        set(newValue) {
            panGesture.isEnabled = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGesture()
    }
    
    private func setupViews() {
        addSubview(visableView)
        visableView.addSubview(label)
        
        //        visableView.edgesToSuperview()
        //        label.edgesToSuperview()
        
    }
    
    private func setupGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipe(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    @objc func swipe(_ sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        let newXPosition = center.x + translation.x
        let velocity = sender.velocity(in: self)
        
        switch(sender.state) {
            
        case .changed:
            let shouldSwipeRight = translation.x > 0 && newXPosition < originalXCenter
            let shouldSwipeLeft = translation.x < 0 && newXPosition > originalXCenter - maxSwipe
            guard shouldSwipeRight || shouldSwipeLeft else { break }
            center.x = newXPosition
        case .ended:
            if -velocity.x > highVelocity {
                center.x = originalXCenter - maxSwipe
                break
            }
            guard center.x > originalXCenter - maxSwipe - swipeBufffer, center.x < originalXCenter - maxSwipe + swipeBufffer, velocity.x < highVelocity  else {
                center.x = originalXCenter
                break
            }
        default:
            break
        }
        panGesture.setTranslation(.zero, in: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SwipeView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
