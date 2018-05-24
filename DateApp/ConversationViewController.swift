//
//  ConversationViewController.swift
//  DateApp
//
//  Created by Neil Ballard on 1/20/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit
import MessageKit
import MapKit

@objc protocol ConversationDelegate: class {
    func didDismissMessageViewController(sender: ConversationViewController)
}

@objc class ConversationViewController: MessagesViewController {
    
    
    @IBOutlet var leftBarButton: UIBarButtonItem!
    
    let refreshControl = UIRefreshControl()
    var messageList: [ChatMessage] = []
    var matchAvatar: UIImage? = nil
    var userAvatar: UIImage? = nil
    var isTyping = false
    weak var delegate: ConversationDelegate?
 //   var socket: DASocket? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
    //    socket = DASocket()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newMessageReceived(notification:)), name: NSNotification.Name(rawValue: "newMessageReceived"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkForMessages), name: NSNotification.Name(rawValue: "newMessage"), object: nil)
        
        if let user = MatchUser.current()
        {
            self.title = user.name
        }
        
        
        
        //self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")?.imageWithRenderingMode(.AlwaysOriginal)
        
       // leftBarButton.image = UIImage(named: "close_icon")?.withRenderingMode(.alwaysOriginal)
      //  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            self.iMessage()
      //  })

        DAServer.getMessages({(messages, error) in
            DispatchQueue.main.async {
                if (error == nil)
                {
                    if let list = messages
                    {
                        self.messageList = self.initData(list: list as! [Message])
                        self.messagesCollectionView.reloadData()
                        self.messagesCollectionView.scrollToBottom()
                        DataAccess().setUserHasMessages(true)
                    }
                }
            }
        })
        
        _ = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {
            (_) in
                self.checkForMessages()
        }
        


        /*
        DispatchQueue.global(qos: .userInitiated).async {
            SampleData.shared.getMessages(count: messagesToFetch) { messages in
                DispatchQueue.main.async {
                    self.messageList = messages
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            }
        } */
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        messageInputBar.sendButton.tintColor = UIColor(red:0.31, green:0.69, blue:1.00, alpha:1.0)
        scrollsToBottomOnKeybordBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        /*
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(ConversationViewController.loadMoreMessages), for: .valueChanged) */
        /*
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "ic_keyboard"),
                            style: .plain,
                            target: self,
                            action: #selector(ConversationViewController.handleKeyboardButton)),
            UIBarButtonItem(image: UIImage(named: "ic_typing"),
                            style: .plain,
                            target: self,
                            action: #selector(ConversationViewController.handleTyping))
        ] */
        
        
    }
    
    @objc func checkForMessages() -> Void
    {
        DAServer.getMessages({(messages, error) in
            DispatchQueue.main.async {
                if (error == nil)
                {
                    if let list = messages
                    {
                        self.messageList = self.initData(list: list as! [Message])
                        self.messagesCollectionView.reloadData()
                        self.messagesCollectionView.scrollToBottom()
                        DataAccess().setUserHasMessages(true)
                    }
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show keyboard by default
        messageInputBar.inputTextView.becomeFirstResponder()
    }

    /*
    @objc func handleTyping() {
        
        defer {
            isTyping = !isTyping
        }
        
        if isTyping {
            
            messageInputBar.topStackView.arrangedSubviews.first?.removeFromSuperview()
            messageInputBar.topStackViewPadding = .zero
            
        } else {
            
            let label = UILabel()
            label.text = "nathan.tannar is typing..."
            label.font = UIFont.boldSystemFont(ofSize: 16)
            messageInputBar.topStackView.addArrangedSubview(label)
            
            
            messageInputBar.topStackViewPadding.top = 6
            messageInputBar.topStackViewPadding.left = 12
            
            // The backgroundView doesn't include the topStackView. This is so things in the topStackView can have transparent backgrounds if you need it that way or another color all together
            messageInputBar.backgroundColor = messageInputBar.backgroundView.backgroundColor
            
        }
        
    } */
    /*
    @objc func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now() + 4) {
            SampleData.shared.getMessages(count: 10) { messages in
                DispatchQueue.main.async {
                    self.messageList.insert(contentsOf: messages, at: 0)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    } */
    
    @objc func newMessageReceived(notification: NSNotification)
    {
        let message: Message = notification.userInfo?["new_message"] as! Message
        
        if message != nil
        {
            let chatMessage = initItem(item: message)
            DispatchQueue.main.async {
                self.messageList.append(chatMessage)
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom()
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillAppear(true)
      //  socket?.disconnectSocket()
    }
    
    func initItem(item: Message) -> ChatMessage
    {
        let matchUser = MatchUser.current()
        let sender = Sender(id: String(describing:matchUser?.user_id), displayName: (matchUser?.name)!)
        let date = Date(timeIntervalSince1970: TimeInterval(item.timestamp))
        
        return ChatMessage(text: item.message!, sender: sender, messageId: String(describing: item.timestamp), date: date)
    }
    
    func initData(list: [Message]) -> [ChatMessage]
    {
        let matchUser = MatchUser.current()
        let userName = DataAccess().getName()
        let userID = DataAccess().getUserID()

        var messages: [ChatMessage] = []

        for item in list
        {
            var sender: Sender
            if(item.type == Int(message_type.RECEIVED_MESSAGE.rawValue))
            {
                sender = Sender(id: String(describing:matchUser?.user_id), displayName: (matchUser?.name)!)
            }
            else
            {
                sender = Sender(id: userID!, displayName: (userName)!)
            }
            
            let date = Date(timeIntervalSince1970: TimeInterval(item.timestamp))
            let message = ChatMessage(text: item.message!, sender: sender, messageId: String(describing: item.timestamp), date: date)
            messages.append(message)
        }
        
        return messages;
    }
    
    @IBAction func exitVC(_ sender: Any)
    {
        self.messageInputBar.alpha = 0.0
        self.messageInputBar.removeFromSuperview()
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleKeyboardButton() {
        
        messageInputBar.inputTextView.resignFirstResponder()
        let actionSheetController = UIAlertController(title: "Change Keyboard Style", message: nil, preferredStyle: .actionSheet)
        let actions = [
            UIAlertAction(title: "Slack", style: .default, handler: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.slack()
                })
            }),
            UIAlertAction(title: "iMessage", style: .default, handler: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.iMessage()
                })
            }),
            UIAlertAction(title: "Default", style: .default, handler: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.defaultStyle()
                })
            }),
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ]
        actions.forEach { actionSheetController.addAction($0) }
        actionSheetController.view.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Style
    
    func slack() {
        defaultStyle()
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.isTranslucent = false
        messageInputBar.inputTextView.backgroundColor = .clear
        messageInputBar.inputTextView.layer.borderWidth = 0
        let items = [
            makeButton(named: "ic_camera").onTextViewDidChange { button, textView in
                button.isEnabled = textView.text.isEmpty
            },
            makeButton(named: "ic_at").onSelected {
                $0.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
                print("@ Selected")
            },
            makeButton(named: "ic_hashtag").onSelected {
                $0.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
                print("# Selected")
            },
            .flexibleSpace,
            makeButton(named: "ic_library").onTextViewDidChange { button, textView in
                button.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
                button.isEnabled = textView.text.isEmpty
            },
            messageInputBar.sendButton
                .configure {
                    $0.layer.cornerRadius = 8
                    $0.layer.borderWidth = 1.5
                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                    $0.setTitleColor(.white, for: .normal)
                    $0.setTitleColor(.white, for: .highlighted)
                    $0.setSize(CGSize(width: 52, height: 30), animated: true)
                }.onDisabled {
                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                    $0.backgroundColor = .white
                }.onEnabled {
                    $0.backgroundColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
                    $0.layer.borderColor = UIColor.clear.cgColor
                }.onSelected {
                    // We use a transform becuase changing the size would cause the other views to relayout
                    $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }.onDeselected {
                    $0.transform = CGAffineTransform.identity
            }
        ]
        items.forEach { $0.tintColor = .lightGray }
        
        // We can change the container insets if we want
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        
        // Since we moved the send button to the bottom stack lets set the right stack width to 0
        messageInputBar.setRightStackViewWidthConstant(to: 0, animated: true)
        
        // Finally set the items
        messageInputBar.setStackViewItems(items, forStack: .bottom, animated: true)
    }
    
    func iMessage() {
        defaultStyle()
        messageInputBar.isTranslucent = false
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: true)
        messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: true)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(red:0.22, green:0.59, blue:0.94, alpha:1.0)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: true)
        messageInputBar.sendButton.image = #imageLiteral(resourceName: "send_button")
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        messageInputBar.sendButton.backgroundColor = .clear
        messageInputBar.textViewPadding.right = -38
    }
    
    func defaultStyle() {
        let newMessageInputBar = MessageInputBar()
        newMessageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        newMessageInputBar.delegate = self
        messageInputBar = newMessageInputBar
        reloadInputViews()
    }
    
    // MARK: - Helpers
    
    func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 30, height: 30), animated: true)
            }.onSelected {
                $0.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
            }.onDeselected {
                $0.tintColor = UIColor.lightGray
            }.onTouchUpInside { _ in
                print("Item Tapped")
        }
    }
    
    
}

// MARK: - MessagesDataSource

extension ConversationViewController: MessagesDataSource {
    
    func currentSender() -> Sender
    {
        let user = User.current()
        let userName = user?.name
        let userID = DataAccess().getUserID()
        return Sender(id: userID!, displayName: userName!)
    }
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        struct ConversationDateFormatter {
            static let formatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return formatter
            }()
        }
        let formatter = ConversationDateFormatter.formatter
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
}

// MARK: - MessagesDisplayDelegate

extension ConversationViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedStringKey : Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(red:0.27, green:0.60, blue:0.98, alpha:1.0) : UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
        //        let configurationClosure = { (view: MessageContainerView) in}
        //        return .custom(configurationClosure)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if (isFromCurrentSender(message: message))
        {
            if (userAvatar != nil)
            {
                let avatar = Avatar(image:userAvatar, initials: "EL")
                avatarView.set(avatar: avatar)
            }
            else
            {
                DAServer.getProfile({(data, error) in
                    DispatchQueue.main.async {
                        if (error == nil)
                        {
                            if let user = data
                            {
                                if let pics = user.pics
                                {
                                    if(pics.count > 0)
                                    {
                                        let url = pics.firstObject as! String
                                        PhotoDownloader.downloadImage(url){ (img, error) in
                                            DispatchQueue.main.async {
                                                if (error == nil)
                                                {
                                                    self.userAvatar = img
                                                    let avatar = Avatar(image:self.userAvatar, initials: "DL")
                                                    avatarView.set(avatar: avatar)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                })
                /*

                 
                 
                 
                if let pics = user.pics
                {
                    if(pics.count > 0)
                    {
                        let url = pics.firstObject as! String
                        PhotoDownloader.downloadImage(url){ (img, error) in
                            DispatchQueue.main.async {
                                if (error == nil)
                                {
                                    self.matchAvatar = img
                                    let avatar = Avatar(image:self.matchAvatar, initials: "DL")
                                    avatarView.set(avatar: avatar)
                                }
                            }
                        }
                    }
                } */
            }
        }
        else
        {
            if (matchAvatar != nil)
            {
                let avatar = Avatar(image:matchAvatar, initials: "DL")
                avatarView.set(avatar: avatar)
            }
            else
            {
                let matchUser = MatchUser.current()
                if let user = matchUser
                {
                    if let pics = user.pics
                    {
                        if(pics.count > 0)
                        {
                            let url = pics.firstObject as! String
                            PhotoDownloader.downloadImage(url){ (img, error) in
                                DispatchQueue.main.async {
                                    if (error == nil)
                                    {
                                        self.matchAvatar = img
                                        let avatar = Avatar(image:self.matchAvatar, initials: "DL")
                                        avatarView.set(avatar: avatar)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Location Messages
    
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
        let pinImage = #imageLiteral(resourceName: "pin")
        annotationView.image = pinImage
        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
        return annotationView
    }
    
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
        return { view in
            view.layer.transform = CATransform3DMakeScale(0, 0, 0)
            view.alpha = 0.0
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                view.layer.transform = CATransform3DIdentity
                view.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        
        return LocationMessageSnapshotOptions()
    }
}

// MARK: - MessagesLayoutDelegate

extension ConversationViewController: MessagesLayoutDelegate {
    
    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        return AvatarPosition(horizontal: .natural, vertical: .messageBottom)
    }
    
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        if isFromCurrentSender(message: message) {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)
        } else {
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
        }
    }
    
    func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        } else {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        }
    }
    
    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        } else {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        }
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        return CGSize(width: messagesCollectionView.bounds.width, height: 10)
    }
    
    // MARK: - Location Messages
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 200
    }
    
    
    
}

// MARK: - MessageCellDelegate

extension ConversationViewController: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
        //delegate?.didDismissMessageViewController(sender: self)
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapTopLabel(in cell: MessageCollectionViewCell) {
        print("Top label tapped")
    }
    
    func didTapBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
}

// MARK: - MessageLabelDelegate

extension ConversationViewController: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String : String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
}

// MARK: - MessageInputBarDelegate

extension ConversationViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        // Each NSTextAttachment that contains an image will count as one empty character in the text: String
        
        for component in inputBar.inputTextView.components {
            
            let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
            
            let message = ChatMessage(attributedText: attributedText, sender: currentSender(), messageId: UUID().uuidString, date: Date())
            messageList.append(message)
            messagesCollectionView.insertSections([messageList.count - 1])
          //  socket?.sendMessage(text)
            
            DAServer.sendMessage(text, completion: (({ (error) in
                //get last message to update matchVC once user goes back
                DAServer.getMessages({(messages, error) in
                    if let _ = messages{
                        DataAccess().setUserHasMessages(true)
                    }
                })
            })))
            /*
            if let image = component as? UIImage {
                
                let imageMessage = MockMessage(image: image, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                messageList.append(imageMessage)
                messagesCollectionView.insertSections([messageList.count - 1])
                
            } else if let text = component as? String {
                

            } */
            
        }
        
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
    }
    
}

