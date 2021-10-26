//
//  ATSenderCVCell.swift
//  DearJini
//
//  Created by Creator-$ on 6/24/19.
//  Copyright © 2019 tiwariammit@mail.com. All rights reserved.
//

import UIKit

protocol ATCollectionViewCellDelegate: class {
    
    func copyTapped(_ sender : UIMenuItem)
    func deleteTapped(_ sender : UIMenuItem)
}

class ATSenderCVCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var textContentView: UIView!
    @IBOutlet weak var avatarImageViewViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var itemImageViewContainerView: UIControl!

    @IBOutlet weak var itemImageView: UIImageView!

    @IBOutlet weak var itemImageViewContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalSpaceBetweenImageContainerAndMessageConstraint: NSLayoutConstraint!
    

    //    @IBOutlet weak var itemImageViewHeightConstraint: NSLayoutConstraint!

    weak var notifier: ATCollectionViewCellDelegate?
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
//    
    override func awakeFromNib() {
        super.awakeFromNib()
  
        self.lblText.textColor = .white
        
        //        self.contentView.isUserInteractionEnabled = false
    }
    
    
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        
//        if action == #selector(copyTapped(_:)){
//            return true
//        }
//        
//        if action == #selector(deleteTapped(_:)){
//            return true
//        }
//        
//        //        return false
//        return super.canPerformAction(action, withSender: sender)
//    }
//    
//    @objc private func copyTapped(_ sender : UIMenuItem){
//       
//        self.notifier?.copyTapped(sender)
//    }
//    
//    @objc private func deleteTapped(_ sender : UIMenuItem){
//        self.notifier?.deleteTapped(sender)
//    }
    
    func cellConfigurations(_ message : ATMessage){
        self.lblText.text = message.text
    }
}


extension UIView {
    
    public func drawRoundCorner(_ corners:UIRectCorner, radius: CGFloat, borderColor: UIColor? = nil) {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        if let color = borderColor {
            let borderLayer = CAShapeLayer()
            
            let name = "AmritTiwari"
            if let sublayers = self.layer.sublayers{
                for layers in sublayers {
                    if layers.name == name {
                        layers.removeFromSuperlayer()
                    }
                }
            }
            borderLayer.name = name
            borderLayer.path = mask.path
            borderLayer.fillColor = nil//UIColor.clear.cgColor
            borderLayer.strokeColor = color.cgColor
            borderLayer.lineWidth = 5
            self.setNeedsDisplay()
            borderLayer.frame = path.bounds//self.bounds
            self.layer.addSublayer(borderLayer)
            mask.path = borderLayer.path
        }
        self.layer.mask = mask
    }
}
