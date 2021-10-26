//
//  ATMessage.swift
//  
//
//  Created by Creator-$ on 6/25/19.
//

import Foundation
import UIKit

class ATMessage : NSObject {
    
    public var senderId : String = ""
    /**
     *  Returns the display name for the user who sent the message. This value does not have to be unique.
     */
    public var senderDisplayName : String = ""
    /**
     *  Returns the date that the message was sent.
     */
    public var date : Date = Date()
    
    /**
     *  Returns a boolean value specifying whether or not the message contains media.
     *  If `false`, the message contains text. If `true`, the message contains media.
     *  The value of this property depends on how the object was initialized.
     */
    public var isMediaMessage : Bool = false
    
    /**
     *  Returns the body text of the message, or `nil` if the message is a media message.
     *  That is, if `isMediaMessage` is equal to `YES` then this value will be `nil`.
     */
    public var text : String?
    /**
     Return the media image
    */
    public var mediaUrl : URL?
    
    //MARK:-Initialization
    init(senderId : String, senderDisplayName : String, text : String, date : Date) {
        self.senderId = senderId
        self.senderDisplayName = senderDisplayName
        self.text = text
        self.date = date
    }
    
    init(senderId : String, senderDisplayName : String, isMediaMessage: Bool, mediaUrl : URL, date : Date, text : String?) {
        self.senderId = senderId
        self.senderDisplayName = senderDisplayName
        self.mediaUrl = mediaUrl
        self.isMediaMessage = isMediaMessage
        self.date = date
        self.text = text
    }
}

