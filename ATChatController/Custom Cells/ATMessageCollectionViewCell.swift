//
//  ATMessageCollectionViewCell.swift
//  DearJini
//
//  Created by Creator-$ on 6/25/19.
//  Copyright © 2019 tiwariammit@mail.com. All rights reserved.
//

import Foundation
import UIKit

public class ATMessageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!

//    @IBOutlet weak var messageBubbleContainerWidthConstraint: NSLayoutConstraint!
//    @IBOutlet weak var textViewTopVerticalSpaceConstraint: NSLayoutConstraint!
//    @IBOutlet weak var textViewBottomVerticalSpaceConstraint: NSLayoutConstraint!
//    @IBOutlet weak var textViewAvatarHorizontalSpaceConstraint: NSLayoutConstraint!
//    @IBOutlet weak var textViewMarginHorizontalSpaceConstraint: NSLayoutConstraint!
//    @IBOutlet weak var cellTopLabelHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var messageBubbleTopLabelHeightConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var cellBottomLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var avatarImageViewViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var avatarImageViewViewHeightConstraint: NSLayoutConstraint!
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
    }
  

    func cellConfigurations(_ message : ATMessage){
        self.lblText.text = message.text
    }
    
}
/*
public class ATMessageCollectionViewCell: UICollectionViewCell {
    
    /**
    *  The object that acts as the delegate for the cell.
    */
//    @property (weak, nonatomic) id<JSQMessagesCollectionViewCellDelegate> delegate;
    
    /**
     *  Returns the label that is pinned to the top of the cell.
     *  This label is most commonly used to display message timestamps.
     */
    @IBOutlet weak var cellTopLabel: JSQMessagesLabel!

    
    /**
     *  Returns the label that is pinned just above the messageBubbleImageView, and below the cellTopLabel.
     *  This label is most commonly used to display the message sender.
     */
    @IBOutlet weak var messageBubbleTopLabel: JSQMessagesLabel!
    
    /**
     *  Returns the label that is pinned to the bottom of the cell.
     *  This label is most commonly used to display message delivery status.
     */
    
    @IBOutlet weak var cellBottomLabel: JSQMessagesLabel!
    
    /**
     *  Returns the text view of the cell. This text view contains the message body text.
     *
     *  @warning If mediaView returns a non-nil view, then this value will be `nil`.
     */
    
    @IBOutlet weak var textView: JSQMessagesCellTextView!

    /**
     *  Returns the bubble image view of the cell that is responsible for displaying message bubble images.
     *
     *  @warning If mediaView returns a non-nil view, then this value will be `nil`.
     */
    @IBOutlet weak var messageBubbleImageView: UIImageView!
    
    /**
     *  Returns the message bubble container view of the cell. This view is the superview of
     *  the cell's textView and messageBubbleImageView.
     *
     *  @discussion You may customize the cell by adding custom views to this container view.
     *  To do so, override `collectionView:cellForItemAtIndexPath:`
     *
     *  @warning You should not try to manipulate any properties of this view, for example adjusting
     *  its frame, nor should you remove this view from the cell or remove any of its subviews.
     *  Doing so could result in unexpected behavior.
     */
    @IBOutlet weak var messageBubbleContainerView: UIView!

    /**
     *  Returns the avatar image view of the cell that is responsible for displaying avatar images.
     */
    @IBOutlet weak var avatarImageView: UIImageView!

    /**
     *  Returns the avatar container view of the cell. This view is the superview of the cell's avatarImageView.
     *
     *  @discussion You may customize the cell by adding custom views to this container view.
     *  To do so, override `collectionView:cellForItemAtIndexPath:`
     *
     *  @warning You should not try to manipulate any properties of this view, for example adjusting
     *  its frame, nor should you remove this view from the cell or remove any of its subviews.
     *  Doing so could result in unexpected behavior.
     */
    @IBOutlet weak var avatarContainerView: UIView!

    /**
     *  The media view of the cell. This view displays the contents of a media message.
     *
     *  @warning If this value is non-nil, then textView and messageBubbleImageView will both be `nil`.
     */

    @IBOutlet weak var mediaView: UIView!
   
   
    @IBOutlet weak var messageBubbleContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewTopVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewBottomVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewAvatarHorizontalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewMarginHorizontalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageBubbleTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellBottomLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarContainerViewHeightConstraint: NSLayoutConstraint!

    
    private var textViewFrameInsets : UIEdgeInsets = UIEdgeInsets.zero
    private var  avatarViewSize : CGSize = CGSize.zero
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor.white
        
        self.cellTopLabelHeightConstraint.constant = 0.0
        self.messageBubbleTopLabelHeightConstraint.constant = 0.0
        self.cellBottomLabelHeightConstraint.constant = 0.0
        
//        self.avatarViewSize = CGSize.zero
        
        self.cellTopLabel.textAlignment = .center
        self.cellTopLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        self.cellTopLabel.textColor = UIColor.lightGray
        
        self.messageBubbleTopLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.messageBubbleTopLabel.textColor = UIColor.lightGray
        
        self.cellBottomLabel.font = UIFont.systemFont(ofSize: 11.0)
        self.cellBottomLabel.textColor = UIColor.lightGray
    }
    
    deinit {
        
//        _delegate = nil;
//
//        [_tapGestureRecognizer removeTarget:nil action:NULL];
//        _tapGestureRecognizer = nil;
        
        self.cellTopLabel = nil
        self.messageBubbleTopLabel = nil
        self.cellBottomLabel = nil
        
        self.textView = nil
        self.messageBubbleImageView = nil;
        self.mediaView = nil;
        self.avatarImageView = nil;
    }

    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cellTopLabel.text = nil
        self.messageBubbleTopLabel.text = nil
        self.cellBottomLabel.text = nil
        
        self.textView.dataDetectorTypes = UIDataDetectorTypes.all//UIDataDetectorTypeNone;
        self.textView.text = nil
        self.textView.attributedText = nil
        
        self.avatarImageView.image = nil
        self.avatarImageView.highlightedImage = nil
    }
    
//    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        return layoutAttributes
//    }
//
//    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//
//        guard let customAttributes = layoutAttributes as? JSQMessagesCollectionViewLayoutAttributes else {
//            return
//        }
//
//        if textView.font != customAttributes.messageBubbleFont {
//            textView.font = customAttributes.messageBubbleFont
//        }
//
//        if !UIEdgeInsetsEqualToEdgeInsets(textView.textContainerInset, customAttributes.textViewTextContainerInsets) {
////            if let textViewTextContainerInsets = customAttributes.textViewTextContainerInsets {
////            }
//            textView.textContainerInset = customAttributes.textViewTextContainerInsets
//
//        }
////
//        textViewFrameInsets = customAttributes.textViewFrameInsets
//    }
    
    
    func cellConfigurations(_ message : ATMessage){
        self.textView.text = message.text
    }
}

 */
