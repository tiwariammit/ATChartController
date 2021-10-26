//
//  TextViews.swift
//  DearJini
//
//  Created by Creator-$ on 7/3/19.
//  Copyright © 2019 tiwariammit@mail.com. All rights reserved.
//

import Foundation
import UIKit


@objc protocol ATDynamicTextViewDelegate: class {
    
    @objc optional func dynamicTextViewDidResizeHeight(textview: ATDynamicTextView, height: CGFloat)
    @objc optional func placeholderTextViewDidChangeText(_ textView: UITextView)
    @objc optional func placeholderTextViewDidEndEditing(_ textView: UITextView)
    @objc optional func placeholderTextViewShouldBeginEditing(_ textView: UITextView)

}


class ATDynamicTextView: UITextView {
    
    weak var notifier: ATDynamicTextViewDelegate?
    
    public var minHeight: CGFloat = 50
    public var maxHeight: CGFloat = 60
    private var contentOffsetCenterY: CGFloat = 10
    
    public var placeholder: String?{
        didSet {
            self.lblPlaceholder.text = placeholder
        }
    }
    public var placeholderColor = UIColor.lightGray
    public var placeholderFont = UIFont.systemFont(ofSize: 14){
        didSet {
            self.lblPlaceholder.font = placeholderFont
        }
    }
    
    private var lblPlaceholder: UILabel = UILabel()
    private let textInset : CGFloat = 0
    public var textXInset : CGFloat = 5


    override var text: String!{
        didSet{
//            if text.count<=0{
                self.addPlaceHolder()
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.minHeight = self.frame.size.height
        let offset : CGFloat = 0
        
        self.delegate = self
        
        self.lblPlaceholder.textColor = self.placeholderColor
        self.lblPlaceholder.text = self.placeholder
        self.lblPlaceholder.textAlignment = .left
        self.lblPlaceholder.numberOfLines = 0
        self.lblPlaceholder.font = self.placeholderFont

        //center first line
        let size = self.sizeThatFits(CGSize(width: self.bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        self.contentOffsetCenterY = (-(frame.size.height - size.height * self.zoomScale) / 2.0) + offset
        
        //listen for text changes
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChangeHandler(_:)), name: UITextView.textDidChangeNotification, object: nil)
        
        //update offsets
        self.layoutSubviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Use content size if more than min size, compensate for Y offset
        var height = max(self.contentSize.height - (contentOffsetCenterY * 2.0), minHeight)
        var updateContentOffsetY: CGFloat?
        //Max Height
        if height > self.maxHeight {
            //Cap at maxHeight
            height = self.maxHeight
        } else {
            //constrain Y to prevent odd skip and center content to view.
            updateContentOffsetY = self.contentOffsetCenterY
        }
        //update frame if needed & notify delegate
        if self.frame.size.height != height {
            self.frame.size.height = height
            self.notifier?.dynamicTextViewDidResizeHeight?(textview: self, height: height)
        }
        //constrain Y must be done after setting frame
        if updateContentOffsetY != nil {
            self.contentOffset.y = updateContentOffsetY!
        }
        
        self.addPlaceHolder()
    }
    
    private func addPlaceHolder(){
        
        var height:CGFloat = self.placeholderFont.lineHeight
        if let data = self.lblPlaceholder.text {
            
            let expectedDefaultWidth:CGFloat = bounds.size.width
            
            let textView = UITextView()
            textView.text = data
            textView.font = self.placeholderFont
            let sizeForTextView = textView.sizeThatFits(CGSize(width: expectedDefaultWidth, height: CGFloat.greatestFiniteMagnitude))
            let expectedTextViewHeight = sizeForTextView.height
            
            if expectedTextViewHeight > height {
                height = expectedTextViewHeight
            }
        }
        
        self.lblPlaceholder.frame = CGRect(x: self.textXInset, y: self.textInset/4, width: bounds.size.width - 16, height: height - 5)
        
        if self.text.isEmpty {
            self.addSubview(self.lblPlaceholder)
            self.bringSubviewToFront(self.lblPlaceholder)
        }else{
            self.lblPlaceholder.removeFromSuperview()
        }
        
    }

    
    @objc func textDidChangeHandler(_ notification: Notification) {
        
        let caretRect = self.caretRect(for: self.selectedTextRange!.start)
        let overflow = caretRect.size.height + caretRect.origin.y - (self.contentOffset.y + self.bounds.size.height - self.contentInset.bottom - self.contentInset.top)
        if overflow > 0 {
            //Fix wrong offset when cursor jumps to next line un explisitly
            let seekEndY = self.contentSize.height - self.bounds.size.height
            if self.contentOffset.y != seekEndY {
                self.contentOffset.y = seekEndY
            }
        }
        
        self.addPlaceHolder()
    }
}

// MARK: - UITextViewDelegate
extension ATDynamicTextView : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.notifier?.placeholderTextViewDidChangeText?(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.notifier?.placeholderTextViewDidEndEditing?(textView)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        
        self.notifier?.placeholderTextViewShouldBeginEditing?(textView)
        return true
    }
}









//
//@objc protocol ATTextViewDelegate: class {
//    func placeholderTextViewDidChangeText(_ textView: UITextView)
//    @objc optional func placeholderTextViewDidEndEditing(_ textView: UITextView)
//}
//
//
//class ATTextView: UITextView {
//
//    public weak var notifier:ATTextViewDelegate?
//
//    public var placeholder: String? {
//        didSet {
//            lblPlaceholder.text = placeholder
//        }
//    }
//    public var placeholderColor = UIColor.lightGray
//    public var placeholderFont = UIFont.systemFont(ofSize: 14){
//        didSet {
//            lblPlaceholder.font = placeholderFont
//        }
//    }
//
//    private var lblPlaceholder: UILabel = UILabel()
//    private let textInset : CGFloat = 0
//
//    override var text: String!{
//        didSet{
//            if text.count<=0{
//                self.addPlaceHolder()
//            }
//        }
//    }
//
//    // MARK: - LifeCycle
//
//    init() {
//        super.init(frame: CGRect.zero, textContainer: nil)
//        awakeFromNib()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        self.contentInset = UIEdgeInsets(top: self.textInset, left: self.textInset, bottom: self.textInset, right: self.textInset)
//
//        self.sizeToFit()
//
////        let newPosition = self.beginningOfDocument
////        self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
//
//        self.delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChangeHandler(notification:)), name: UITextView.textDidChangeNotification, object: nil)
//
//        self.lblPlaceholder.textColor = self.placeholderColor
//        self.lblPlaceholder.text = self.placeholder
//        self.lblPlaceholder.textAlignment = .left
//        self.lblPlaceholder.numberOfLines = 0
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.addPlaceHolder()
//
//    }
//
//    private func addPlaceHolder(){
//
//        lblPlaceholder.font = placeholderFont
//
//        var height:CGFloat = placeholderFont.lineHeight
//        if let data = lblPlaceholder.text {
//
//            let expectedDefaultWidth:CGFloat = bounds.size.width
//
//            let textView = UITextView()
//            textView.text = data
//            textView.font = self.placeholderFont
//            let sizeForTextView = textView.sizeThatFits(CGSize(width: expectedDefaultWidth, height: CGFloat.greatestFiniteMagnitude))
//            let expectedTextViewHeight = sizeForTextView.height
//
//            if expectedTextViewHeight > height {
//                height = expectedTextViewHeight
//            }
//        }
//
//        self.lblPlaceholder.frame = CGRect(x: 5, y: self.textInset/4, width: bounds.size.width - 16, height: height - 5)
//
//        if self.text.isEmpty {
//            self.addSubview(self.lblPlaceholder)
//            bringSubviewToFront(lblPlaceholder)
//        }else{
//            self.lblPlaceholder.removeFromSuperview()
//        }
//    }
//
//    @objc func textDidChangeHandler(notification: Notification) {
//        self.layoutSubviews()
//    }
//
//}
//
//extension ATTextView : UITextViewDelegate {
//    // MARK: - UITextViewDelegate
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
////        if(text == "\n") {
////            textView.resignFirstResponder()
////            return false
////        }
//        return true
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//        self.notifier?.placeholderTextViewDidChangeText(textView)
//
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        self.notifier?.placeholderTextViewDidEndEditing?(textView)
//    }
//}
