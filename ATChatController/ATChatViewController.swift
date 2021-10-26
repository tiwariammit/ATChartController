//
//  ChatBaseViewController.swift
//  DearJini
//
//  Created by Creator-$ on 6/24/19.
//  Copyright © 2019 tiwariammit@mail.com. All rights reserved.
//

import UIKit
import Photos


class ATChatViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inputMessageTextView: TextViewMaster!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtViewInputMessageContainerView: UIView!
    
    @IBOutlet weak var seperatorView: UIView!
    //    @IBOutlet weak var toolbarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottomLayoutGuide: NSLayoutConstraint!
    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnImageUpload: UIButton!
    @IBOutlet weak var btnEmoji: UIButton!
    
    private var keyboardIsOpen : Bool = false
    private var keyboardFrame : CGRect = .zero
    
    //    private var snapshotView : UIView = UIView()
    //    private var jsq_isObserving : Bool = false
    private var selectedIndexPathForMenu : IndexPath?
    
    private var selectedView : UIView = UIView()
    
    //    private var currentInteractivePopGestureRecognizer : UIGestureRecognizer = UIGestureRecognizer()
    //    private var textViewWasFirstResponderDuringInteractivePop : Bool = false
    //
    //    public weak var delegate : ATChatViewControllerDelegate?
    
    //Sender Detail
    public var senderId: String = ""
    public var senderDisplayName: String = ""
    public var senderImageUrl : URL?
    
    public var messageFont : UIFont = UIFont.systemFont(ofSize: 14)
    
    public var avatarSenderImageHeight : CGFloat = 0
    public var avatarReceiverImageHeight : CGFloat = 50
    
    public var receiverImageUrl : URL?
    
    public var avatarPlaceholderImage : UIImage?
    
    public var messages : [ATMessage] = []
    
    public var enableConsecutiveSenderAvatarHiddingProperty : Bool = false
    
    public var enableConsecutiveReceiverAvatarHiddingProperty : Bool = false
    
    public var imageHeightAndWidth : CGFloat = 150
    
    public var allowsMediaEditing : Bool = false
    
    /**
     *  Specifies whether or not the view controller should automatically scroll to the most recent message
     *  when the view appears and when sending, receiving, and composing a new message.
     *
     *  @discussion The default value is `YES`, which allows the view controller to scroll automatically to the most recent message.
     *  Set to `NO` if you want to manage scrolling yourself.
     */
    
    public var automaticallyScrollsToMostRecentMessage : Bool = false
    
    /**
     *  Specifies whether or not the view controller should show the typing indicator for an incoming message.
     *
     *  @discussion Setting this property to `YES` will animate showing the typing indicator immediately.
     *  Setting this property to `NO` will animate hiding the typing indicator immediately. You will need to scroll
     *  to the bottom of the collection view in order to see the typing indicator. You may use `scrollToBottomAnimated:` for this.
     */
    public var showTypingIndicator : Bool = false
    
    
    
    /**
     *  Specifies whether or not the view controller should show the "load earlier messages" header view.
     *
     *  @discussion Setting this property to `YES` will show the header view immediately.
     *  Settings this property to `NO` will hide the header view immediately. You will need to scroll to
     *  the top of the collection view in order to see the header.
     */
    public var showLoadEarlierMessagesHeader : Bool = false
    
    
    
    /**
     *  Specifies an additional inset amount to be added to the collectionView's contentInsets.top value.
     *
     *  @discussion Use this property to adjust the top content inset to account for a custom subview at the top of your view controller.
     */
    public var topContentAdditionalInset: CGFloat = 0
    
    public var inputTextViewPlaceholderColor: UIColor = UIColor.lightGray
    public var inputTextViewPlaceholderFont : UIFont = UIFont.systemFont(ofSize: 14)
    public var inputTextViewPlaceholder: String = "Type something here..."{
        didSet{
            self.setUpInputTextViewProperty()
        }
    }
    
    public let viewTag : Int = 545
    private var defaultInputTextViewHeight : CGFloat = 40
    private var maximumInputTextViewHeight : CGFloat = 120
    
    
    private let fakeEmojiTextView : EmojiTextView = EmojiTextView(frame: CGRect(x: 0, y: -200, width: 50, height: 50))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let className = "ATChatViewController"
        let nib = UINib(nibName: className, bundle: Bundle(identifier: className))
        nib.instantiate(withOwner: self, options: nil)
        
        self.view.backgroundColor = UIColor.white
        
        self.view.tag = self.viewTag        
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.keyboardDismissMode = .interactive
        
        let saveMenuItem = UIMenuItem(title: "Copy", action: #selector(copy(_:)))
        let deleteMenuItem = UIMenuItem(title: "Delete", action: #selector(delete(_:)))
        
        UIMenuController.shared.menuItems = [deleteMenuItem, saveMenuItem]
        
        self.setUpInputTextViewProperty()
        
        self.view.addSubview(self.fakeEmojiTextView)
        self.fakeEmojiTextView.delegate = self
        
        self.collectionView.register(UINib(nibName: "ATSenderCVCell", bundle: nil), forCellWithReuseIdentifier: "ATSenderCVCell")
        
        self.collectionView.register(UINib(nibName: "ATReceiverCVCell", bundle: nil), forCellWithReuseIdentifier: "ATReceiverCVCell")
        
        self.addNotificationObserver(addObserver: true)
        
        self.enableDisableSendButton()
        self.addLongPressGuesture()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.setUpInputTextViewProperty()
        self.collectionView.contentInset = UIEdgeInsets(top: self.topContentAdditionalInset, left: 0, bottom: 0, right: 0)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.btnSend.layer.cornerRadius = self.btnSend.frame.height/2
        self.btnSend.layer.masksToBounds = true
        self.setUpShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    deinit {
        self.collectionView.dataSource = nil
        self.collectionView.delegate = nil
        NotificationCenter.default.removeObserver(self)
        self.addNotificationObserver(addObserver: false)
    }
    
    private func setUpShadow(){
        let shadowSize : CGFloat = 6.0
        
        self.seperatorView.backgroundColor = .lightGray
        
        let shadowPath = UIBezierPath(roundedRect: CGRect(x: 5, y: -shadowSize / 2, width: self.txtViewInputMessageContainerView.frame.size.width, height: self.txtViewInputMessageContainerView.frame.size.height), cornerRadius : 0)
        
        self.txtViewInputMessageContainerView.backgroundColor = .white
        self.txtViewInputMessageContainerView.layer.masksToBounds = false
        self.txtViewInputMessageContainerView.layer.shadowColor = UIColor.gray.cgColor
        self.txtViewInputMessageContainerView.layer.shadowOffset = CGSize.zero
        self.txtViewInputMessageContainerView.layer.shadowOpacity = 0.2
        self.txtViewInputMessageContainerView.layer.shadowPath = shadowPath.cgPath
        self.txtViewInputMessageContainerView.layer.cornerRadius = 0
    }
    
    
    
    //MARK:-Add Notification observer
    private func addNotificationObserver(addObserver : Bool){
        if addObserver{
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            
            //            NotificationCenter.default.addObserver(self, selector: #selector(self.jsq_handleDidChangeStatusBarFrameNotification(_:)), name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
            
            //            NotificationCenter.default.addObserver(self, selector: #selector(self.inputModeDidChange(_:)), name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMenuWillShowNotification(_:)), name: UIMenuController.willShowMenuNotification,object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.didHideMenuNotification(_:)), name: UIMenuController.didHideMenuNotification,object: nil)
        }else{
            
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            
            //            NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
            //            NotificationCenter.default.removeObserver(self, name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)
            
            
            NotificationCenter.default.removeObserver(self, name: UIMenuController.willShowMenuNotification, object: nil)
            
            NotificationCenter.default.removeObserver(self, name: UIMenuController.didHideMenuNotification, object: nil)
            
        }
        
    }
    
    
    
    // MARK: - Collection view utilities
    
    public func didPressSendButton(_ button : UIButton, withMessageText text : String, senderId: String, senderDisplayName : String, date : Date){
        
    }
    
    /*
     Override this method for handle the media view touch event
     */
    public func mediaViewTriggerEvent(_ message : ATMessage){
        
    }
    
    
    public func didPressAccessoryButton(_ sender: UIButton) {
        
    }
    
    
    public func didSelectImageFromPicker( _ image : UIImage, imageName : String){
        
    }
    
    
    /**
     *  Animates the sending of a new message. See `finishSendingMessageAnimated:` for more details.
     *
     *  @see `finishSendingMessageAnimated:`.
     */
    public func finishSendingMessage(animated : Bool = false){
        
        self.collectionView.reloadData()
        self.inputMessageTextView.text = nil
        self.fakeEmojiTextView.text = nil
        self.enableDisableSendButton()
        
        if self.automaticallyScrollsToMostRecentMessage {
            scrollToBottom(animated: animated, isScrollToBottom: false)
        }
    }
    
    
    /**
     *  Completes the "sending" of a new message by resetting the `inputToolbar`, adding a new collection view cell in the collection view,
     *  reloading the collection view, and scrolling to the newly sent message as specified by `automaticallyScrollsToMostRecentMessage`.
     *  Scrolling to the new message can be animated as specified by the animated parameter.
     *
     *  @param animated Specifies whether the sending of a message should be animated or not. Pass `YES` to animate changes, `NO` otherwise.
     *
     *  @discussion You should call this method at the end of `didPressSendButton: withMessageText: senderId: senderDisplayName: date`
     *  after adding the new message to your data source and performing any related tasks.
     *
     *  @see `automaticallyScrollsToMostRecentMessage`.
     */
    //    public func finishSendingMessage(animated: Bool) {
    //
    //    }
    
    
    /**
     *  Animates the receiving of a new message. See `finishReceivingMessageAnimated:` for more details.
     *
     *  @see `finishReceivingMessageAnimated:`.
     */
    
    
    public func finishReceivingMessage(animated: Bool = false) {
        
        self.collectionView.reloadData()
        //        self.changeTextViewHeight()
        if self.automaticallyScrollsToMostRecentMessage {
            self.scrollToBottom(animated: animated, isScrollToBottom: false)
        }
        
    }
    
    /*
     
     call this method for initially inserting message
     */
    public func finishReceivingInitiallyMessage() {
        self.collectionView.reloadData()
        self.scrollToBottom(animated: false, isScrollToBottom: true)
    }
    
    
    /**
     *  Completes the "receiving" of a new message by showing the typing indicator, adding a new collection view cell in the collection view,
     *  reloading the collection view, and scrolling to the newly sent message as specified by `automaticallyScrollsToMostRecentMessage`.
     *  Scrolling to the new message can be animated as specified by the animated parameter.
     *
     *  @param animated Specifies whether the receiving of a message should be animated or not. Pass `YES` to animate changes, `NO` otherwise.
     *
     *  @discussion You should call this method after adding a new "received" message to your data source and performing any related tasks.
     *
     *  @see `automaticallyScrollsToMostRecentMessage`.
     */
    
    /**
     *  Scrolls the collection view such that the bottom most cell is completely visible, above the `inputToolbar`.
     *
     *  @param animated Pass `YES` if you want to animate scrolling, `NO` if it should be immediate.
     */
    private func scrollToBottom(animated: Bool, isScrollToBottom: Bool) {
        
        guard let _ = self.collectionView else {
            return
        }
        
        if self.messages.count == 0 {
            return
        }
        self.collectionView.layoutIfNeeded()
        
        let index = self.messages.count - 1
        if isScrollToBottom{
            let lastCell = IndexPath(item: index, section: 0)
            self.scroll(to: lastCell, animated: animated)
            return()
        }
        
        let indexPaths = self.collectionView.indexPathsForVisibleItems
        var isScrolls : Bool = false
        for indexPath in indexPaths{
            let visibleIndex = indexPath.item
            if (index-1) == visibleIndex{
                isScrolls = true
                break
            }
        }
        if isScrolls{
            let lastCell = IndexPath(item: index, section: 0)
            self.scroll(to: lastCell, animated: animated)
        }
    }
    
    /**
     * Used to decide if a message is incoming or outgoing.
     *
     * @discussion The default implementation of this method compares the `senderId` of the message to the
     * value of the `senderId` property and returns `YES` if they are equal. Subclasses can override
     * this method to specialize the decision logic.
     */
    //    public func isOutgoingMessage:(id<JSQMessageData>)messageItem;
    
    /**
     * Scrolls the collection view so that the cell at the specified indexPath is completely visible above the `inputToolbar`.
     *
     * @param indexPath The indexPath for the cell that will be visible.
     * @param animated Pass `YES` if you want to animate scrolling, `NO` otherwise.
     */
    public func scroll(to indexPath: IndexPath, animated: Bool) {
        self.collectionView.layoutIfNeeded()
        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
        self.collectionView.layoutIfNeeded()
    }
    
    //MARK:-Actions
    @IBAction func btnSendTouched(_ sender: UIButton){
        let message = self.inputMessageTextView.text.trim()
        if message.count == 0{
            return()
        }
        self.didPressSendButton(sender, withMessageText: message, senderId: self.senderId, senderDisplayName: self.senderDisplayName, date: Date())
        
        self.inputMessageTextView.text = nil
        self.fakeEmojiTextView.text = nil
    }
    
    @IBAction func btnImageUploadTouched(_ sender: Any) {
        self.presentImagePickerVC()
    }
    
    @IBAction func btnEmojiTouched(_ sender: UIButton) {
        
        self.btnEmoji.isSelected = !self.btnEmoji.isSelected
        
        if self.btnEmoji.isSelected{
            self.fakeEmojiTextView.becomeFirstResponder()
        }else{
            self.inputMessageTextView.becomeFirstResponder()
        }
    }
}


extension ATChatViewController{
    
    //MARK:-Set up Input Text view
    private func setUpInputTextViewProperty(){
        
        self.inputMessageTextView.delegate = self
        self.inputMessageTextView.layer.cornerRadius = 5
        self.inputMessageTextView.isAnimate = true
        self.inputMessageTextView.maxLength = 1000
        self.inputMessageTextView.maxHeight = 100
        self.inputMessageTextView.minHeight = 30
        self.inputMessageTextView.placeHolder = self.inputTextViewPlaceholder
        self.inputMessageTextView.placeHolderColor = self.inputTextViewPlaceholderColor
        self.inputMessageTextView.font = self.inputTextViewPlaceholderFont
        
        self.inputMessageTextView.placeHolderTopPadding = -5
        self.inputMessageTextView.placeHolderBottomPadding = 0
        
    }
    
    //MARK:- Lift up text view when keyboard present
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        self.keyboardIsOpen = true
        
        if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var bottomPadding : CGFloat = 0
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                bottomPadding = window?.safeAreaInsets.bottom ?? 0
            }
            let height = keyboardSize.height - bottomPadding
            
            self.view.layoutIfNeeded()
            self.bottomViewBottomLayoutGuide.constant = height + 5
            self.view.layoutIfNeeded()
            
            self.scrollToBottom(animated: true, isScrollToBottom: false)
            
            //            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            //                self.view.layoutIfNeeded()
            //            }, completion: {[weak self] finised in
            //                guard let `self` = self else { return }
            //
            //            })
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.inputMessageTextView{
            self.inputMessageTextView.detectScrolling()
            return()
        }
        
        let fingerLocation = scrollView.panGestureRecognizer.location(in: scrollView)
        let absoluteFingerLocation = scrollView.convert(fingerLocation, to: view)
        
        if self.keyboardIsOpen && scrollView.panGestureRecognizer.state == .changed && absoluteFingerLocation.y >= (self.view.frame.size.height - keyboardFrame.size.height) {
            
            var bottomPadding : CGFloat = 0
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                bottomPadding = window?.safeAreaInsets.bottom ?? 0
            }
            self.bottomViewBottomLayoutGuide.constant = UIScreen.main.bounds.size.height - absoluteFingerLocation.y - bottomPadding
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillChangeFrame(notification : NSNotification){
        guard let userInfo = notification.userInfo else { return }
        
        if let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.layoutIfNeeded()
            self.keyboardFrame = keyboardSize
        }
    }
    
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.layoutIfNeeded()
        
        self.keyboardIsOpen = false
        self.bottomViewBottomLayoutGuide.constant = 0
        self.btnEmoji.isSelected = false
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.inputMessageTextView.layoutIfNeeded()
        })
    }
    
    //    @objc func inputModeDidChange(_ notification: Notification) {
    //
    //        print(notification)
    //
    ////        let inputMethod = notification.object//.textInputMode?.primaryLanguage
    ////
    ////        print(inputMethod)
    ////
    ////        print(self.fakeEmojiTextField.textInputMode?.primaryLanguage)
    ////
    ////        print("textView:- \(self.inputMessageTextView.textInputMode?.primaryLanguage)")
    //        if let inputMode = notification.object as? UITextInputMode {
    //            if let lang = inputMode.primaryLanguage {
    //                // do something
    //                if lang == "emoji"{
    //                    self.btnEmoji.isSelected = false
    //                }
    //            }
    //        }
    //    }
    //
    
    
}

extension ATChatViewController : ATCollectionViewCellDelegate {
    
    
    private func enableDisableSendButton(){
        
        if self.inputMessageTextView.text.trim().count == 0{
            self.btnSend.isEnabled = false
        }else{
            self.btnSend.isEnabled = true
        }
    }
    
    //MARK:-Long Press Guesture
    private func addLongPressGuesture(){
        //
        //        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        //        lpgr.minimumPressDuration = 0.4
        //        //        lpgr.delegate = self
        //        lpgr.delaysTouchesBegan = true
        //        self.collectionView.addGestureRecognizer(lpgr)
        
    }
    
    //MARK:-Handle Long Press Event
    @objc func handleLongPress(_ sender : UILongPressGestureRecognizer) {
        
        let touchedPoint = sender.location(in: self.collectionView)
        guard let indexPath = self.collectionView.indexPathForItem(at: touchedPoint) else{
            print("couldn't find index path")
            return
        }
        
        self.selectedIndexPathForMenu = indexPath
        
        guard sender.state == .began, let cell = self.collectionView.cellForItem(at: indexPath)
            else {
                return
        }
        
        var destinationView : UIView = cell
        let data = self.messages[indexPath.item]
        
        self.view.layoutIfNeeded()
        
        if data.senderId == self.senderId{
            let cells = cell as! ATSenderCVCell
            destinationView = cells.textContentView!
            
            //            cells.textContentView.addSubview(self.selectedView)
            
        }else{
            let cells = cell as! ATReceiverCVCell
            destinationView = cells.textContentView!
            
            //            cells.textContentView.addSubview(self.selectedView)
        }
        
        //        self.selectedView.frame = destinationView.frame
        
        //        self.selectedView.backgroundColor = .red
        //        self.selectedView.isUserInteractionEnabled = false
        
        guard let superView = destinationView.superview else { return }
        
        superView.becomeFirstResponder()
        self.btnSend.becomeFirstResponder()
        
        //        let saveMenuItem = UIMenuItem(title: "Copy", action: #selector(self.copyTapped(_:)))
        ////        let deleteMenuItem = UIMenuItem(title: "Delete", action: #selector(self.deleteTapped(_:)))
        //
        //        UIMenuController.shared.setMenuVisible(false, animated: false)
        //
        //        UIMenuController.shared.menuItems = [saveMenuItem]//, deleteMenuItem]
        //        UIMenuController.shared.setTargetRect(destinationView.frame, in: superView)
        
        //        UIMenuController.shared.arrowDirection = .down
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
    
    //    override var canBecomeFirstResponder: Bool{
    //        return true
    //    }
    
    @objc private func didReceiveMenuWillShowNotification(_ notification: Notification){
        guard let indexPath = self.selectedIndexPathForMenu else { return }
        
        NotificationCenter.default.removeObserver(self, name: UIMenuController.willShowMenuNotification, object: nil)
        
        UIMenuController.shared.setMenuVisible(false, animated: false)
        
        
        guard let cell = self.collectionView.cellForItem(at: indexPath)
            else {
                return
        }
        
        var destinationView : UIView = cell
        let data = self.messages[indexPath.item]
        
        self.view.layoutIfNeeded()
        
        if data.senderId == self.senderId{
            let cells = cell as! ATSenderCVCell
            destinationView = cells.textContentView!
        }else{
            let cells = cell as! ATReceiverCVCell
            destinationView = cells.textContentView!
        }
        
        guard let superView = destinationView.superview else { return }
        
        superView.becomeFirstResponder()
        
        UIMenuController.shared.setTargetRect(destinationView.frame, in: superView)
        
        //        UIMenuController.shared.arrowDirection = .down
        UIMenuController.shared.setMenuVisible(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMenuWillShowNotification(_:)), name: UIMenuController.willShowMenuNotification,object: nil)
        
        self.selectedIndexPathForMenu = nil
    }
    
    @objc private func didHideMenuNotification(_ notification : Notification){
        
        self.selectedView.removeFromSuperview()
        
        self.view.layoutIfNeeded()
        
        let text = self.inputMessageTextView.text ?? ""
        if text.count > 2{
            let bottom = NSMakeRange(text.count - 1, 1)
            self.inputMessageTextView.scrollRangeToVisible(bottom)
        }
        
        self.view.layoutIfNeeded()
    }
    
    @objc func copyTapped(_ sender : UIMenuItem){
        guard let indexPath = self.selectedIndexPathForMenu else { return }
        
        let index = indexPath.item
        let data = self.messages[index]
        UIPasteboard.general.string = data.text
        self.selectedView.removeFromSuperview()
        if #available(iOS 10.0, *) {
            ATVibration.light.vibrate()
        }
    }
    
    @objc func deleteTapped(_ sender : UIMenuItem){
        
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
    ////        return false
    //        return super.canPerformAction(action, withSender: sender)
    //    }
    
    
    //MARK:- Collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        let index = indexPath.item
        if action == #selector(copy(_:)){
            
            //            let index = self.selectedIndexPathForMenu.item
            let data = self.messages[index]
            UIPasteboard.general.string = data.text
            self.selectedView.removeFromSuperview()
            if #available(iOS 10.0, *) {
                ATVibration.light.vibrate()
            }
        }
        
        if action == #selector(delete(_:)){
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        //        if action == #selector(copy(_:)) {
        //            return true
        //        }
        //
        //        if  action == #selector(delete(_:)){
        //            return true
        //        }
        
        //        if action == #selector(copyTapped(_:)){
        //            return true
        //        }
        //        if action == #selector(deleteTapped(_:)){
        //            return true
        //        }
        //
        return false
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        
        guard let cell = self.collectionView.cellForItem(at: indexPath)
            else {
                return false
        }
        
        self.selectedIndexPathForMenu = indexPath
        
        let message = self.messages[indexPath.item]
        
        var destinationView : UIView = cell
        
        if message.senderId == self.senderId{
            let cells = cell as! ATSenderCVCell
            destinationView = cells.textContentView!
        }else{
            let cells = cell as! ATReceiverCVCell
            destinationView = cells.textContentView!
        }
        
        print(destinationView.frame)
        
        return true
    }
    
}


//MARK:-Collection View Datasource
extension ATChatViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.messages.count
        return count
    }
    //        if totalCount != 0 && currentIndex != 0 {
    //            let previousSendID = self.messages[currentIndex-1].senderId
    //            let currentSenderId = message.senderId
    //            if previousSendID == currentSenderId{
    //                isHideSenderAvatarImage = true
    //            }
    //        }
    
    
    @objc private func imageViewTouched(_ sender : UIControl){
        let tag = sender.tag
        let message = self.messages[tag]
        self.mediaViewTriggerEvent(message)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentIndex : Int = indexPath.item
        let data = self.messages[currentIndex]
        
        var isHideSenderAvatarImage : Bool = false
        
        //hide consecutive receiver avatar image
        if self.enableConsecutiveReceiverAvatarHiddingProperty{
            let totalCount = self.messages.count
            if  totalCount != currentIndex+1{
                let currentSenderId = data.senderId
                let futureSendID = self.messages[currentIndex+1].senderId
                if futureSendID == currentSenderId{
                    isHideSenderAvatarImage = true
                }
            }
        }
        
        //        if self.enableConsecutiveSenderAvatarHiddingProperty{
        //            let totalCount = self.messages.count
        //            if  totalCount != currentIndex+1{
        //                let currentSenderId = data.senderId
        //                let futureSendID = self.messages[currentIndex+1].senderId
        //                if futureSendID == currentSenderId{
        //                    isHideSenderAvatarImage = true
        //                }
        //            }
        //        }
        
        let radius: CGFloat = 20
        
        if data.senderId == self.senderId{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ATSenderCVCell", for: indexPath) as! ATSenderCVCell
            
            cell.notifier = self
            cell.itemImageView.layer.borderColor = UIColor.lightGray.cgColor
            cell.itemImageViewContainerView.tag = indexPath.item
            
            
            if data.isMediaMessage{
                cell.itemImageViewContainerViewWidthConstraint.constant = self.imageHeightAndWidth
                cell.itemImageView.sd_setImage(with: data.mediaUrl, placeholderImage: avatarPlaceholderImage, options: .scaleDownLargeImages, context: nil)
                cell.itemImageView.layer.borderWidth = 1
                cell.verticalSpaceBetweenImageContainerAndMessageConstraint.constant = 10
                cell.itemImageViewContainerView.addTarget(self, action: #selector(self.imageViewTouched(_:)), for: .touchUpInside)
                
            }else{
                cell.itemImageViewContainerViewWidthConstraint.constant = 0
                cell.itemImageView.layer.borderWidth = 0
                cell.verticalSpaceBetweenImageContainerAndMessageConstraint.constant = 0
            }
            cell.layoutIfNeeded()
            
            cell.avatarImageViewViewWidthConstraint.constant = self.avatarSenderImageHeight
            cell.lblText.font = self.messageFont
            
            cell.cellConfigurations(data)
            
            cell.avatarImageView.sd_setImage(with: self.senderImageUrl, placeholderImage: avatarPlaceholderImage, options: .scaleDownLargeImages, context: nil)
            
            cell.layoutIfNeeded()
            
            cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.height/2
            cell.avatarImageView.layer.masksToBounds = true
            cell.textContentView.drawRoundCorner([.bottomRight,.bottomLeft,.topLeft], radius: radius)
            
            cell.textContentView.backgroundColor = .appColor
            cell.textContentView.borderWidths = 0
            
            return cell
        }else{
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ATReceiverCVCell", for: indexPath) as! ATReceiverCVCell
            
            cell.notifier = self
            
            cell.itemImageView.layer.borderColor = UIColor.lightGray.cgColor
            cell.itemImageViewContainerView.tag = indexPath.item
            
            if data.isMediaMessage{
                cell.isHideImageView = false
                cell.itemImageViewContainerViewWidthConstraint.constant = self.imageHeightAndWidth
                cell.itemImageView.sd_setImage(with: data.mediaUrl, placeholderImage: avatarPlaceholderImage, options: .scaleDownLargeImages, context: nil)
                cell.itemImageView.layer.borderWidth = 1
                cell.verticalSpaceBetweenImageContainerAndMessageConstraint.constant = 10
                cell.itemImageViewContainerView.addTarget(self, action: #selector(self.imageViewTouched(_:)), for: .touchUpInside)
                
            }else{
                cell.itemImageViewContainerViewWidthConstraint.constant = 0
                cell.itemImageView.layer.borderWidth = 0
                cell.verticalSpaceBetweenImageContainerAndMessageConstraint.constant = 0
            }
            
            cell.lblText.font = self.messageFont
            cell.avatarImageViewViewWidthConstraint.constant = self.avatarReceiverImageHeight
            
            cell.avatarImageView.isHidden = isHideSenderAvatarImage
            
            cell.cellConfigurations(data)
            
            cell.avatarImageView.sd_setImage(with: self.receiverImageUrl, placeholderImage: avatarPlaceholderImage, options: .scaleDownLargeImages, context: nil)
            
            cell.layoutIfNeeded()
            
            cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.height/2
            cell.avatarImageView.layer.masksToBounds = true
            cell.textContentView.drawRoundCorner([.bottomRight,.bottomLeft,.topRight], radius: radius, borderColor : .appSelected)
            cell.textContentView.backgroundColor = .white
            
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("didSelectItemAt")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //        layout.minimumLineSpacing = 10
        layout.minimumLineSpacing = 10
        layout.invalidateLayout()
        
        let data = self.messages[indexPath.item]
        var imageHeight : CGFloat = 0
        if data.isMediaMessage {
            
            imageHeight = self.imageHeightAndWidth + 10
        }
        var constraintWidth : CGFloat = 0
        if data.senderId == self.senderId{
            constraintWidth = 40 + self.avatarSenderImageHeight + 50 + 40
        }else{
            constraintWidth = 40 + self.avatarReceiverImageHeight + 40 + 50
        }
        let textViewWidth = collectionView.frame.width - constraintWidth
        
        guard let text = data.text else {
            
            return CGSize(width: collectionView.frame.size.width, height: imageHeight)
        }
        
        var height = self.height(text, width: textViewWidth, with: self.messageFont)
        height = height + 30 + imageHeight
        let size = CGSize(width: collectionView.frame.size.width, height: height)
        return size
    }
    
    private func height(_ message: String, width: CGFloat, with font: UIFont) -> CGFloat {
        let constraintSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let boundingBox = message.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [ NSAttributedString.Key.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
}


//MARK:- TextView Master Delegate
extension ATChatViewController : TextViewMasterDelegate{
    
    func growingTextView(growingTextView: TextViewMaster, willChangeHeight height: CGFloat) {
        
        self.bottomViewHeightConstraint.constant = height + 16
        self.view.layoutIfNeeded()
        self.scrollToBottom(animated: false, isScrollToBottom: false)
        self.collectionView.layoutIfNeeded()
    }
    
    func growingTextViewTextDidChange(growingTextView: TextViewMaster){
        
        self.enableDisableSendButton()
        
        let text = growingTextView.text ?? ""
        self.fakeEmojiTextView.text = text
    }
}


//MARK:-Text View Delegate
extension ATChatViewController {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.fakeEmojiTextView{
            self.fakeEmojiTextViewDidChange(textView)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        self.btnEmoji.isSelected = false
        return true
    }
    
    
    private func fakeEmojiTextViewDidChange(_ textView : UITextView){
        let text = textView.text ?? ""
        self.inputMessageTextView.text = text
        
        self.growingTextViewTextDidChange(growingTextView: self.inputMessageTextView)
        
        self.inputMessageTextView.removePlaceHolder()
        self.inputMessageTextView.layoutSubviews()
    }
}


//MARK:-Image Picker view
extension ATChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    public func presentImagePickerVC(){
        
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) else {
            return
        }
        
        let imag = UIImagePickerController()
        imag.delegate = self
        
        imag.sourceType = UIImagePickerController.SourceType.photoLibrary;
        //imag.mediaTypes = [kUTTypeImage];
        imag.allowsEditing = self.allowsMediaEditing
        self.present(imag, animated: true, completion: nil)
    }
    
    
    //MARK:-Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        
        let defaultName = "img_\(Date().timeIntervalSince1970)"
        
        var imageName : String = defaultName
        
        if #available(iOS 11.0, *) {
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                let assetResources = PHAssetResource.assetResources(for: asset)
                
                if let name = assetResources.first?.originalFilename{
                    imageName = name
                }
            }
        } else {
            
            if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                let asset = result.firstObject
                if let name = asset?.value(forKey: "filename") as? String{
                    imageName = name
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.editedImage] as? UIImage {
            
            self.didSelectImageFromPicker(image, imageName: imageName)
        }else if let image = info[.originalImage] as? UIImage {
            
            self.didSelectImageFromPicker(image, imageName: imageName)
        } else{
            print("Unable to pick image")
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}



//        let headerNib = UINib.init(nibName: "ChatHeaderCollectionReusableView", bundle: nil)
//        self.collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ChatHeaderCollectionReusableView")
//
//        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        layout?.sectionHeadersPinToVisibleBounds = true
//
//extension ChatVC {
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//
//        case UICollectionView.elementKindSectionHeader:
//
//            let headerView: ChatHeaderCollectionReusableView = collectionView.dequeueReusableView(elementKind: kind, for: indexPath)
//            headerView.productImageView.setURLImage(self.productDetail?.images?.first?.value, andPlaceHolderImage: self.placeholderBigImage())
//            headerView.lblProductName.text = self.productDetail?.name
//            headerView.lblProductName.font = ATFontManager.setFont(15, andFontName: FontName.helveticaNeue)
//            headerView.backgroundColor = .appLightGrey
//            return headerView
//
//        default:
//            assert(false, "Unexpected element kind")
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        let text =  self.productDetail?.name ?? "Product"
//        let defaultHeight : CGFloat = collectionView.frame.width * 0.15
//
//        let textWidth = collectionView.frame.width - 40 - 10 - 100
//        let textHeight = text.height(textWidth, with: ATFontManager.setFont(15, andFontName: FontName.helveticaNeue)) + 20
//        var finalHeight = defaultHeight
//        if finalHeight > defaultHeight{
//            finalHeight = textHeight
//        }
//
//        return CGSize(width: collectionView.frame.width, height: finalHeight)
//    }
//}
