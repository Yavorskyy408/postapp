//
//  MessageVC.swift
//  postApp
//
//  Created by Vasyl Yavorskyy on 25/04/2018.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var underButtonView: UIView!
    var tableView: UITableView!
    var users = [UserProfile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - underButtonView.frame.size.height), style: .plain)
        let cellNib = UINib(nibName: "PersonCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "userCell")
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        observeUsers()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! PersonCell
        cell.set(user: users[indexPath.row])
        cell.onButtonTap = { sender in
            print("BUTTON TAP, indexPath=\(indexPath.row)")
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let privateChat = storyBoard.instantiateViewController(withIdentifier: "privateChat") as! PrivateChatVC
            
            privateChat.sendToUser(user: self.users[indexPath.row])
            
            self.present(privateChat, animated: true, completion: nil)
        }
        return cell
    }
    
    //MARK:  show message scene
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyBoard.instantiateViewController(withIdentifier: "profile") as! ProfileVC
        profile.set(user: users[indexPath.row])
        self.present(profile, animated: true, completion: nil)
        print("didSelectRowAt \(indexPath.row)")
    }
    
    //    MARK: Check database for has new user who send message
    func observeUsers() {
        
        guard let curentUser = UserService.currentUserProfile else { return }
        let refToCurentUser = Database.database().reference().child("users/profile/\(curentUser.uId)/chat")

                refToCurentUser.observe(.value, with: { snapshot in
                    self.users = [UserProfile]()
                    for child in snapshot.children {
                        if let childSnapshot = child as? DataSnapshot,
                            let dict = childSnapshot.value as? [String: Any],
                            let author = dict["author"] as? [String: Any],
                            let userName = author["userName"] as? String,
                            let userSurname = author["userSurname"] as? String,
                            let photoURL = author["photoURL"] as? String,
                            let url = URL(string: photoURL)
                        {
                            let userProfile = UserProfile(uId: childSnapshot.key, name: userName, surname: userSurname, photoURL: url)
                            self.users.append(userProfile)
                        }
                    }
                    self.tableView.reloadData()
        })
    }
        
    @IBAction func cancleButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.dismiss(animated: true, completion: nil)
        }) { success in
            print("dismiss AllPersonVC")
        }
    }
}
