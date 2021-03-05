//
//  ChatViewController.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/3/21.
//

import UIKit
import NotificationCenter
import Firebase
import FirebaseFirestoreSwift

class ChatViewController: BaseViewController, Storyboarded {
    var coordinator: ChatCoordinator?
    @IBOutlet weak var inputContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: CustomButtonShape!
    @IBOutlet weak var inputBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textInputView: CustomTextView!
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var placeholderLbl: UILabel!
    
    let cellOwnIdentifier = String(describing: ChatOwnTableViewCell.self)
    let cellOtherIdentifier = String(describing: ChatOthersTableViewCell.self)
    
    var onLogout: (() -> ())?
    var onSend: ((_ message: String) -> ())?
    
    var messages: [Chat] = []
    var listener: ListenerRegistration?
    
    var assumedUsername: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assumedUsername = coordinator?.dbController.user?.displayName
        
        initializeUI()
        
        fetchChat()
        
        hideKeyboardOnTapTable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    // MARK: - SEND MESSAGE
    @IBAction func handleSend(_ sender: CustomButtonShape) {
        guard !textInputView.text.isEmpty else {return}
        let haptic = UIImpactFeedbackGenerator(style: .light)
        haptic.impactOccurred()
        
        // Note: disable to prevent spam click
        sender.isEnabled = false
        
        coordinator?.dbController.sendMessage(textInputView.text) { (success) in
            print("Message sending: \(success)")
            
        }
        
        // NOTE: regardless of success in sending message, clear
        DispatchQueue.main.async { [unowned self] in
            
            // Note: enable button again
            sender.isEnabled = true
            self.textInputView.text = ""
            self.textViewHeightConstraint.isActive = true
            self.placeholderLbl.isHidden = false
            self.tableView.reloadData()
            //self.tableView.scrollToBottom()
        }
    }
    
    func hideKeyboardOnTapTable() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        // NOTE: important to set to false so gestures wont overlap
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Query Messages
extension ChatViewController {
    @objc func fetchChat() {
        messages.removeAll()
        listener?.remove()
        listenToChat()
    }
    
    func listenToChat() {
        listener = coordinator?.dbController.db.collection("chat").order(by: "date_sent").addSnapshotListener(includeMetadataChanges: true, listener: { [unowned self] (querySnapshot, error) in
            
            guard error == nil else {
                return
            }

            guard let snapshot = querySnapshot else {
                return
            }

            guard snapshot.count > 0 else {
                self.messages.removeAll()
                self.tableView.reloadData()
                return
            }

            snapshot.documentChanges.forEach { (diff) in
                if diff.type == .added {
                    let data = diff.document.data()
                    let chat = Chat(text: data["message"] as! String, user: data["username"] as! String, dateSent: (data["date_sent"] as! Timestamp).dateValue())
                    self.messages.append(chat)
                }
            }
            
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [unowned self] in
                self.tableView.scrollToBottom()
            }
        })
    }
}

// MARK: - TableView
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        // OWN message
        if assumedUsername == message.user {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellOwnIdentifier, for: indexPath) as! ChatOwnTableViewCell
            
            cell.userLbl.text = assumedUsername
            cell.textLbl.text = message.text
            cell.dateLbl.text = message.dateSent.chatDateFormatted()
            cell.selectionStyle = .none
            return cell
        }
        // Other's messages
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellOtherIdentifier, for: indexPath) as! ChatOthersTableViewCell
            
            cell.userLbl.text = message.user
            cell.textLbl.text = message.text
            cell.dateLbl.text = message.dateSent.chatDateFormatted()
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - Design
extension ChatViewController {
    private func initializeUI() {
        title = "Chat app"
        
        let rightBarButton = UIButton(type: .custom)
        rightBarButton.frame = CGRect(x: 0, y: 0, width: 80, height: 25)
        rightBarButton.titleLabel?.font = UIFont(name: "Arial", size: 16)
        rightBarButton.layer.cornerRadius = 8
        rightBarButton.tintColor = UIColor.white
        rightBarButton.backgroundColor = UIColor(named: "darkColor")
        rightBarButton.setTitle("Log out", for: .normal)
        rightBarButton.titleLabel?.addCharacterSpacing()
        rightBarButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        let rightBarItem = UIBarButtonItem(customView: rightBarButton)
        self.navigationItem.setRightBarButton(rightBarItem, animated: true)
        
        sendBtn.titleLabel?.addCharacterSpacing()
        
        inputContainer.addTopBorderWithColor(color: UIColor.systemGray5, width: 1)
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        
        textInputView.translatesAutoresizingMaskIntoConstraints = false
        textInputView.frame = CGRect(x: 0, y: 0, width: textInputView.frame.width, height: 35)
        textInputView.sizeToFit()
        
        tableView.register(UINib(nibName: cellOwnIdentifier, bundle: nil), forCellReuseIdentifier: cellOwnIdentifier)
        tableView.register(UINib(nibName: cellOtherIdentifier, bundle: nil), forCellReuseIdentifier: cellOtherIdentifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        
        registerForKeyboardNotifications()
    }
    
    // MARK: - LOG OUT
    @objc private func logout() {
        let haptic = UIImpactFeedbackGenerator(style: .light)
        haptic.impactOccurred()
        
        // NOTE: uncomment to show confirmation message before logout
        let alert = UIAlertController(title: "\(assumedUsername ?? "")", message: "Are you sure you want to log out of Chat app?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            let haptic = UIImpactFeedbackGenerator(style: .medium)
            haptic.impactOccurred()
            self.dismiss(animated: true) {
                self.onLogout?()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Keyboard Notifications
extension ChatViewController {
    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        //self.scrollView.isScrollEnabled = true
        let info = notification.userInfo!
        guard let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        
        var shouldMoveUp = false
        let bottomOfInputContainer = inputContainer.convert(inputContainer.bounds, to: self.view).maxY
        let topOfKB = self.view.frame.height - keyboardSize.height
        
        if bottomOfInputContainer > topOfKB {
            shouldMoveUp = true
        }
        
        if shouldMoveUp {
            self.view.frame.origin.y = 0 - keyboardSize.height
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        self.view.frame.origin.y = 0
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - TextViewDelegate
extension ChatViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLbl.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLbl.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textViewHeightConstraint != nil {
                textViewHeightConstraint.isActive = true
            }
            placeholderLbl.isHidden = false
        } else {
            placeholderLbl.isHidden = true
        }
        
        // custom checker for textview default height constraint
        // this is to ensure that initial height of textview is 1liner
        if textView.intrinsicContentSize.height > 44.5 {
            if textViewHeightConstraint != nil {
                textViewHeightConstraint.isActive = false
            }
        } else {
            if textViewHeightConstraint != nil {
                textViewHeightConstraint.isActive = true
            }
        }
    }
}
