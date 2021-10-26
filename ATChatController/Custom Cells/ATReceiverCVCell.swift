//
//  MessageCVCellIncoming.swift
//  DearJini
//
//  Created by Creator-$ on 6/24/19.
//  Copyright © 2019 tiwariammit@mail.com. All rights reserved.
//

import UIKit

class ATReceiverCVCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    @IBOutlet weak var textContentView: UIView!
    
    @IBOutlet weak var itemImageViewContainerView: UIControl!
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemImageViewContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalSpaceBetweenImageContainerAndMessageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var avatarImageViewViewWidthConstraint: NSLayoutConstraint!
    
    //    @IBOutlet weak var itemImageViewHeightConstraint: NSLayoutConstraint!
    
    //    @IBOutlet weak var messageBubbleContainerWidthConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var textViewTopVerticalSpaceConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var textViewBottomVerticalSpaceConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var textViewAvatarHorizontalSpaceConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var textViewMarginHorizontalSpaceConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var cellTopLabelHeightConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var messageBubbleTopLabelHeightConstraint: NSLayoutConstraint!
    
    //    @IBOutlet weak var cellBottomLabelHeightConstraint: NSLayoutConstraint!
    
    //    @IBOutlet weak var avatarImageViewViewHeightConstraint: NSLayoutConstraint!
    
    public var isHideImageView : Bool = true
    
    weak var notifier: ATCollectionViewCellDelegate?

    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.itemImageView.layer.borderColor = UIColor.lightGray.cgColor
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
//    
    func cellConfigurations(_ message : ATMessage){
        self.lblText.text = message.text
    }
}

