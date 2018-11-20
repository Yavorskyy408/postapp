//
//  PrivateChatVC.swift
//  postApp
//
//  Created by Vasyl Yavorskyy on 14/04/2018.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import UIKit
import Firebase

class PrivateChatVC: UIViewController, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    var userProfile: UserProfile!
    
    var messages = [Message]()
    var tableView: UITableView!

    override func viewDidLoad() {
        //inset the textView
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 25)
        textView.layer.cornerRadius = 15
        textView.delegate = self
        addKeyboardObserver()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 20, width: view.frame.size.width, height: view.frame.size.height - textView.frame.size.height - 35), style: .plain)
        let cellNib = UINib(nibName: "FriendMessageCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "friendRow")
        
        let myCellNib = UINib(nibName: "MyMessageCell", bundle: nil)
        tableView.register(myCellNib, forCellReuseIdentifier: "myRow")
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        observeMesseges(user: userProfile, completionHandler: { success in
            if success {
                self.scrollPostsToLastOne()
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friendRow = tableView.dequeueReusableCell(withIdentifier: "friendRow", for: indexPath) as! FriendMessageCell
        let myRow = tableView.dequeueReusableCell(withIdentifier: "myRow", for: indexPath) as! MyMessageCell
        let messageRow = messages[indexPath.row]
        
        if messageRow.isSender {
            friendRow.set(message: messageRow)
        } else if !messageRow.isSender {
            myRow.set(message: messageRow)
        }
        
        guard messageRow.isSender else { return myRow }
        return friendRow
 
    }
    
    
    
    //MARK: Observe message in database // витягую дані про повідомлення з своєї бази
    func observeMesseges(user: UserProfile, completionHandler: @escaping ((_ success: Bool) -> ())) {
        guard let curentUser = UserService.currentUserProfile else { return }
        
        let refToCurentUser = Database.database().reference().child("users/profile/\(curentUser.uId)/chat/")
        refToCurentUser.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("\(user.uId)") {
                let refToSendUser = snapshot.ref.child("\(user.uId)") ///messages/
                refToSendUser.observe(.value, with: { snapshot in
                    for child in snapshot.children {
                        if let childSnapshot = child as? DataSnapshot,
                            let author = childSnapshot.value as? [String: Any],
                            let userName = author["userName"] as? String,
                            let userSurname = author["userSurname"] as? String,
                            let photoURL = author["photoURL"] as? String,
                            let url = URL(string: photoURL) {
                            let autor = UserProfile(uId: snapshot.key, name: userName, surname: userSurname, photoURL: url)
                            let newRefToMessages = snapshot.ref.child("/messages/")
                            newRefToMessages.observe(.value, with: { snapshot in
                                self.messages = [Message]()
                                for child in snapshot.children {
                                    if let childSnapshot = child as? DataSnapshot,
                                        let dict = childSnapshot.value as? [String: Any],
                                        let text = dict["text"] as? String,
                                        let timestamp = dict["timestamp"] as? Double,
                                        let isSender = dict["isSender"] as? Bool {
                                        let message = Message(autor: autor, mId: snapshot.key, text: text, timestamp: timestamp, isSender: isSender)
                                        self.messages.append(message)
                                    }
                                }
                                print(self.messages.count, "messages count")
                                self.tableView.reloadData()
                                completionHandler(true)
                            })
                        }
                    }
                })
            }
        })
    }
    
    func sendToUser(user: UserProfile) {
        userProfile = user
    }

    func sendMessage(user: UserProfile, completion: @escaping ((_ isSend: Bool) -> ()))  {
        
        guard let curentUser = UserService.currentUserProfile else { return }
        
//        MARK: Create a message in the base of the received user // створення повідомлення в базі полученого юзера
        let refToReceivedUser = Database.database().reference().child("users/profile/\(user.uId)/chat/")
        
        refToReceivedUser.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("\(curentUser.uId)") {
                let newRefToMessages = snapshot.ref.child("\(curentUser.uId)/messages/").childByAutoId()
                let message = [
                    "isSender": true,
                    "text": self.textView.text,
                    "timestamp": [".sv": "timestamp"]
                    ] as [String : Any]
                newRefToMessages.setValue(message, withCompletionBlock: { (error, ref) in
                    completion(error == nil)
                    if error == nil {
                        print("Message sent to existing user")
                    } else {
                        print(error!)
                    }
                })
            } else {
                let newRefToAuthor = snapshot.ref.child("\(curentUser.uId)")
                let newRefToMessages = snapshot.ref.child("\(curentUser.uId)/messages/").childByAutoId()
                let author = [
                    "author" : [
                        "userName": curentUser.name,
                        "userSurname": curentUser.surname,
                        "photoURL": curentUser.photoURL.absoluteString
                    ]
                    ] as [String : Any]
                let message = [
                    "isSender": true,
                    "text": self.textView.text,
                    "timestamp": [".sv": "timestamp"]
                    ] as [String : Any]
                newRefToAuthor.setValue(author, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        print("Message created with new user")
                    } else {
                        print(error!)
                    }
                })
                newRefToMessages.setValue(message, withCompletionBlock: { (error, ref) in
                    completion(error == nil)
                    if error == nil {
                        print("Message sent to new user")
                    } else {
                        print(error!)
                    }
                })
            }
        })
        
//        MARK: Create a message in the base of the current user // створення повідомлення в своїй базі
        let refToCurrentUser = Database.database().reference().child("users/profile/\(curentUser.uId)/chat/")
        refToCurrentUser.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("\(user.uId)") {
                let newRefToMessages = snapshot.ref.child("\(user.uId)/messages/").childByAutoId()
                let message = [
                    "isSender": false,
                    "text": self.textView.text,
                    "timestamp": [".sv": "timestamp"]
                    ] as [String : Any]
                newRefToMessages.setValue(message, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        print("Message sent to current user")
                    } else {
                        print(error!)
                    }
                    completion(error == nil)
                })
            } else {
                let newRefToAuthor = snapshot.ref.child("\(user.uId)")
                let newRefToMessages = snapshot.ref.child("\(user.uId)/messages/").childByAutoId()
                let author = [
                    "author" : [
                        "userName": user.name,
                        "userSurname": user.surname,
                        "photoURL": user.photoURL.absoluteString
                    ]
                    ] as [String : Any]
                let message = [
                    "isSender": false,
                    "text": self.textView.text,
                    "timestamp": [".sv": "timestamp"]
                    ] as [String : Any]
                newRefToAuthor.setValue(author, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        print("Message created with current user")
                    } else {
                        print(error!)
                    }
                })
                newRefToMessages.setValue(message, withCompletionBlock: { (error, ref) in
                    completion(error == nil)
                    if error == nil {
                        print("Message sent to current user")
                    } else {
                        print(error!)
                    }
                })
            }
        })
    }

    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
//        self.tableView.frame.size.height = self.tableView.frame.size.height - keyboardSize.size.height + 20
        self.tableView.frame.size.height = self.view.frame.size.height - keyboardSize.size.height - textView.frame.size.height - 10
        self.tableView.frame.origin.y = keyboardSize.size.height
        self.view.frame.origin.y = -keyboardSize.size.height
        scrollPostsToLastOne()
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil else { return }
        self.tableView.frame.size.height = self.view.frame.size.height - 70
        self.tableView.frame.origin.y = 20
        self.view.frame.origin.y = 0
    }

    func textViewDidChange(_ textView: UITextView) {
//    MARK: Resize text view
        if textView.contentSize.height <= 150 {
            textView.isScrollEnabled = false
            let fixedWidth = textView.frame.size.width
            textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude + 5))
            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude + 5))
            var textViewFrame = textView.frame
            let height = textViewFrame.height - newSize.height
            tableView.frame.size.height = tableView.frame.size.height + (height * 1.1)
            textViewFrame = CGRect.init(x: textViewFrame.origin.x, y: textViewFrame.origin.y + textViewFrame.height - newSize.height, width: max(newSize.width, fixedWidth), height: newSize.height)
            textView.frame = textViewFrame
        } else {
            textView.isScrollEnabled = true
        }
    }
    
//    MARK: Scroll to last one
    func scrollPostsToLastOne() {
        let last = messages.count > 0 ? self.messages.count - 1 : 0
        if last > 0 {
            tableView.scrollToRow(at: IndexPath(row: last, section: 0), at: .bottom, animated: true)
        }
    }
//    MARK: Button Action
    @IBAction func sendButton(_ sender: UIButton) {
        print("send")
        sendMessage(user: userProfile) { (isSend) in
            self.textView.text.removeAll()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
