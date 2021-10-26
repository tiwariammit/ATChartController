//
//  ATMessagesCollectionViewLayoutAttributes.swift
//  DearJini
//
//  Created by Creator-$ on 6/25/19.
//  Copyright © 2019 tiwariammit@mail.com. All rights reserved.
//

import Foundation
import UIKit


class ATMessagesCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    /**
     *  The font used to display the body of a text message in a message bubble within a `JSQMessagesCollectionViewCell`.
     *  This value must not be `nil`.
     */
    public var messageBubbleFont : UIFont?
    
    /**
     *  The width of the `messageBubbleContainerView` of a `JSQMessagesCollectionViewCell`.
     *  This value should be greater than `0.0`.
     *
     *  @see JSQMessagesCollectionViewCell.
     */
    public var messageBubbleContainerViewWidth: CGFloat?;
    
    /**
     *  The inset of the text container's layout area within the text view's content area in a `JSQMessagesCollectionViewCell`.
     *  The specified inset values should be greater than or equal to `0.0`.
     */
    public var textViewTextContainerInsets: UIEdgeInsets?;
    
    /**
     *  The inset of the frame of the text view within a `JSQMessagesCollectionViewCell`.
     *
     *  @discussion The inset values should be greater than or equal to `0.0` and are applied in the following ways:
     *
     *  1. The right value insets the text view frame on the side adjacent to the avatar image
     *  (or where the avatar would normally appear). For outgoing messages this is the right side,
     *  for incoming messages this is the left side.
     *
     *  2. The left value insets the text view frame on the side opposite the avatar image
     *  (or where the avatar would normally appear). For outgoing messages this is the left side,
     *  for incoming messages this is the right side.
     *
     *  3. The top value insets the top of the frame.
     *
     *  4. The bottom value insets the bottom of the frame.
     */
    public var textViewFrameInsets: UIEdgeInsets?;
    
    /**
     *  The size of the `avatarImageView` of a `JSQMessagesCollectionViewCellIncoming`.
     *  The size values should be greater than or equal to `0.0`.
     *
     *  @see JSQMessagesCollectionViewCellIncoming.
     */
    public var incomingAvatarViewSize : CGSize?;
    
    /**
     *  The size of the `avatarImageView` of a `JSQMessagesCollectionViewCellOutgoing`.
     *  The size values should be greater than or equal to `0.0`.
     *
     *  @see `JSQMessagesCollectionViewCellOutgoing`.
     */
    public var outgoingAvatarViewSize : CGSize?;
    
    /**
     *  The height of the `cellTopLabel` of a `JSQMessagesCollectionViewCell`.
     *  This value should be greater than or equal to `0.0`.
     *
     *  @see JSQMessagesCollectionViewCell.
     */
    public var cellTopLabelHeight: CGFloat?;
    
    /**
     *  The height of the `messageBubbleTopLabel` of a `JSQMessagesCollectionViewCell`.
     *  This value should be greater than or equal to `0.0`.
     *
     *  @see JSQMessagesCollectionViewCell.
     */
    public var messageBubbleTopLabelHeight : CGFloat?;
    
    /**
     *  The height of the `cellBottomLabel` of a `JSQMessagesCollectionViewCell`.
     *  This value should be greater than or equal to `0.0`.
     *
     *  @see JSQMessagesCollectionViewCell.
     */
    public var cellBottomLabelHeight: CGFloat?;

    
    // MARK: - Init
    override init() {
        super.init()
        messageBubbleFont = UIFont.preferredFont(forTextStyle: .body)
        messageBubbleContainerViewWidth = 320.0
    }

    
    // MARK: - Setters
    func setMessageBubble(_ messageBubbleFont: UIFont?) {
        assert(messageBubbleFont != nil, "Invalid parameter not satisfying: messageBubbleFont != nil")
        self.messageBubbleFont = messageBubbleFont
    }
    
    func setMessageBubbleContainerViewWidth(_ messageBubbleContainerViewWidth: CGFloat) {
        assert(messageBubbleContainerViewWidth > 0.0, "Invalid parameter not satisfying: messageBubbleContainerViewWidth > 0.0")
//        self.messageBubbleContainerViewWidth = ceilf(messageBubbleContainerViewWidth)
    }
    
    func setIncomingAvatarViewSize(_ incomingAvatarViewSize: CGSize) {
        assert(incomingAvatarViewSize.width >= 0.0 && incomingAvatarViewSize.height >= 0.0, "Invalid parameter not satisfying: incomingAvatarViewSize.width >= 0.0 && incomingAvatarViewSize.height >= 0.0")
//        self.incomingAvatarViewSize = jsq_correctedAvatarSize(from: incomingAvatarViewSize)
    }
    
}
