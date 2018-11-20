//
//  HomeVC.swift
//  loginApp
//
//  Created by Vasyl Yavorskyy on 28.02.18.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet var quickLookView: UIView!
    @IBOutlet weak var quickLookName: UILabel!
    @IBOutlet weak var quickLookMessage: UITextView!
    
    @IBOutlet weak var writeNewPostLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var plusButtonAction: UIButton!
    @IBOutlet weak var savePost: UIButton!
    @IBOutlet weak var canclePost: UIButton!
    @IBOutlet var quickLookTapGesture: UITapGestureRecognizer!
    

    var tableView: UITableView!
    var posts = [Post]()

    var buttonHeight: CGFloat = 30
    
    static var swipe = true

    fileprivate func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: 20, width: view.frame.size.width, height: view.frame.size.height - 20), style: .plain)
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        //анімація баттона типу тогле
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.plusButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        })
        
        quickLookView.center = view.center
        quickLookView.alpha = 0
        textView.alpha = 0
        textView.text.removeAll()
        textView.delegate = self
        effectView.alpha = 0
        writeNewPostLabel.alpha = 0
        savePost.alpha = 0
        savePost.isEnabled = false
        canclePost.alpha = 0
        quickLookTapGesture.isEnabled = false
        
        view.bringSubview(toFront: plusButton)
        view.bringSubview(toFront: plusButtonAction)
        addKeyboardObserver()
        observePosts { (success) in
            if success {
                self.scrollPostsToLastOne()
            }
        }
    }
    
    
    
    @IBAction func swipeRight(_ sender: UIScreenEdgePanGestureRecognizer) {
        if HomeVC.swipe {
            print("swipe right")
            let menu = storyboard!.instantiateViewController(withIdentifier: "menu") as! SidebarMenu
            self.addChildViewController(menu)
            view.addSubview(menu.view)
            menu.showMenu()
            HomeVC.swipe = false
        }
    }
    
    //MARK: Scroll to last one
    func scrollPostsToLastOne() {
        let last = posts.count > 0 ? self.posts.count - 1 : 0
        if last > 0 {
            tableView.scrollToRow(at: IndexPath(row: last, section: 0), at: .bottom, animated: true)
        }
    }
    
    @IBAction func plusButtonAction(_ sender: UIButton) {
        view.bringSubview(toFront: effectView)
        view.bringSubview(toFront: textView)
        textView.becomeFirstResponder()
        effectView.alpha = 1
        textView.alpha = 1
        writeNewPostLabel.alpha = 1
        savePost.alpha = 1
        savePost.isEnabled = false
        canclePost.alpha = 1
        HomeVC.swipe = false
    }
    
    @IBAction func savePost(_ sender: UIButton) {
        print("Button add post is pressed")
        
        //      MARK: Firebase code add new post in database
        guard let userProfile = UserService.currentUserProfile else { return }
        let postRef = Database.database().reference().child("posts").childByAutoId()
        let postObject = [
            "author" : [
                "uId": userProfile.uId,
                "userName": userProfile.name,
                "userSurname": userProfile.surname,
                "photoURL": userProfile.photoURL.absoluteString
            ],
            "text": textView.text,
            "timestamp": [".sv":"timestamp"]
            ] as [String : Any]
        
        postRef.setValue(postObject) { (error, ref) in
            if error == nil {
                self.tableView.scrollToRow(at: IndexPath(row: self.posts.count - 1, section: 0), at: .bottom, animated: true)
                self.canclePost(sender)
                self.textView.text.removeAll()
            } else {
                print("Post has no created!!!!")
            }
        }
    }
    
    @IBAction func canclePost(_ sender: UIButton){
        textView.resignFirstResponder()
        textView.alpha = 0
        effectView.alpha = 0
        writeNewPostLabel.alpha = 0
        savePost.alpha = 0
        canclePost.alpha = 0
        HomeVC.swipe = true
        
    }
    
    //MARK: Close Quck Look View
    @IBAction func closeQuickView(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: {
            self.quickLookView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            self.quickLookView.alpha = 0
            self.effectView.alpha = 0
        }) {(success: Bool) in
            self.quickLookView.removeFromSuperview()
            self.quickLookTapGesture.isEnabled = false
            HomeVC.swipe = true
        }
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.savePost.frame.origin.y = view.frame.height - keyboardSize.height - buttonHeight * 2 + 25
        self.canclePost.frame.origin.y = view.frame.height - keyboardSize.height - buttonHeight * 2 + 25
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil else { return }
        self.savePost.frame.origin.y = view.frame.height - buttonHeight * 2 + 25
        self.canclePost.frame.origin.y = view.frame.height - buttonHeight * 2 + 25
    }
    
    //MARK: TableView Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        cell.set(post: posts[indexPath.row])
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognizer))
        longPress.minimumPressDuration = 0.5
        cell.addGestureRecognizer(longPress)
        return cell
    }
    
    @objc func longPressGestureRecognizer(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let posts = self.posts[indexPath.row]
                //FIXME: quick view height equale text but not more 150
                quickLookName.text = posts.author.name + " " + posts.author.surname
                quickLookMessage.text = posts.text
                self.view.bringSubview(toFront: self.effectView)
                self.view.addSubview(self.quickLookView)
                self.quickLookView.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
                self.quickLookTapGesture.isEnabled = true
                HomeVC.swipe = false
                
                UIView.animate(withDuration: 0.4) {
                    self.quickLookView.alpha = 1
                    self.effectView.alpha = 1
                    self.quickLookView.transform = CGAffineTransform.identity
                }
            }
        }
    }
    
    //MARK: Press in one cell animation in
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UITableViewCell.animate(withDuration: 0.2) {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
    }
    //MARK: Press in one cell animation out
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UITableViewCell.animate(withDuration: 0.2) {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.transform = .identity
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    //MARK: Can delete cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let curentUser = Auth.auth().currentUser?.uid
        let myPost = self.posts[indexPath.row]
        let user = myPost.author.uId
        guard curentUser == user else { return false }
            return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let curentUser = Auth.auth().currentUser?.uid
        let postToDelete = self.posts[indexPath.row]
        let user = postToDelete.author.uId

        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            if curentUser == user {
                postToDelete.ref.removeValue()
            }
        })
        
        deleteAction.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.00001)
        UIButton.appearance().setTitleColor(UIColor.red, for: UIControlState.normal)

        return [deleteAction]
    }
    
//    MARK: Text view del func
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let count = textView.text.count + (text.count - range.length)
        if count > 0 {
            savePost.isEnabled = true
        } else {
            savePost.isEnabled = false
        }
        return count <= 500
    }
    

    
    
//    MARK: Check database for has new post
    func observePosts(completion: @escaping ((_ success: Bool) -> ())) {
        let postRef = Database.database().reference().child("posts")
        postRef.observe(.value, with: { snapshot in
            
            self.posts = [Post]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String: Any],
                    let author = dict["author"] as? [String: Any],
                    let uId = author["uId"] as? String,
                    let userName = author["userName"] as? String,
                    let userSurname = author["userSurname"] as? String,
                    let photoURL = author["photoURL"] as? String,
                    let url = URL(string: photoURL),
                    let text = dict["text"] as? String,
                    let timestamp = dict["timestamp"] as? Double {
                    
                    let userProfile = UserProfile(uId: uId, name: userName, surname: userSurname, photoURL: url)
                    let post = Post(ref: childSnapshot.ref, id: childSnapshot.key, author: userProfile, text: text, timestamp: timestamp)
                    self.posts.append(post)
                }
            }
            self.tableView.reloadData()
            completion(true)
        })
    }
//    MARK: Log out
    func logOut() {
        try! Auth.auth().signOut()
    }
}



