//
//  SidebarMenu.swift
//  sidebarMenu
//
//  Created by Vasyl Yavorskyy on 29.03.18.
//  Copyright © 2018 Vasyl Yavorskyy. All rights reserved.
//

import Foundation
import UIKit

class SidebarMenu: UIViewController {
    
    @IBOutlet weak var leadingMenuView: UIView!
    @IBOutlet weak var menuImageView: UIImageView!
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    let home = HomeVC()
    
    override func viewDidLoad() {
        startPosition()
    }
    
    func startPosition() {
        self.menuImageView.image = #imageLiteral(resourceName: "menuBar")
        self.menuImageView.transform = CGAffineTransform(translationX: -self.menuImageView.frame.width, y: 0)
        self.leadingMenuView.isHidden = true
        
        self.homeButton.transform = CGAffineTransform(translationX: -self.leadingMenuView.frame.width, y: 0)
        self.addButton.transform = CGAffineTransform(translationX: -self.leadingMenuView.frame.width, y: 0)
        self.refreshButton.transform = CGAffineTransform(translationX: -self.leadingMenuView.frame.width, y: 0)
        self.groupButton.transform = CGAffineTransform(translationX: -self.leadingMenuView.frame.width, y: 0)
        self.logOutButton.transform = CGAffineTransform(translationX: -self.leadingMenuView.frame.width, y: 0)
    }
    
    func showMenu() {
        leadingMenuView.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.homeButton.transform = .identity
            self.logOutButton.transform = .identity
        })
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.addButton.transform = .identity
            self.groupButton.transform = .identity
        })
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.refreshButton.transform = .identity
        })
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.menuImageView.transform = .identity
        })
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.homeButton.transform = CGAffineTransform(translationX: -self.leadingMenuView.frame.width, y: 0)
            self.logOutButton.transform = CGAffineTransform(translationX: -self.leadingMenuView.frame.width, y: 0)
        })
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.addButton.transform = CGAffineTransform(translationX: -self.leadingMenuView.frame.width, y: 0)
            self.groupButton.transform = CGAffineTransform(translationX: -self.leadingMenuView.frame.width, y: 0)
        })
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.refreshButton.transform = CGAffineTransform(translationX: -self.leadingMenuView.frame.width, y: 0)
        }) { success in
            self.leadingMenuView.isHidden = true
            self.view.removeFromSuperview()
        }
        UIView.animate(withDuration: 0.35, delay: 0.1, options: .curveEaseOut, animations: {
            self.menuImageView.transform = CGAffineTransform(translationX: -self.menuImageView.frame.width, y: 0)
        })
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            hideMenu()
            HomeVC.swipe = true
        }
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        showMenu()
    }
    
    //MARK: Menu buttons
    @IBAction func homeButton(_ sender: UIButton) {
        hideMenu()
        HomeVC.swipe = true
        
        let profile = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileVC
        profile.currentUser()
        self.present(profile, animated: true, completion: nil)
    }
    
    @IBAction func chatButton(_ sender: UIButton) {
        hideMenu()
        HomeVC.swipe = true
        
        let messageVC = storyboard?.instantiateViewController(withIdentifier: "messageVC") as! MessageVC
        self.present(messageVC, animated: true, completion: nil)
    }
    
    @IBAction func thirdButton(_ sender: UIButton) {
        hideMenu()
        HomeVC.swipe = true
    }
    
    @IBAction func allUsersButton(_ sender: UIButton) {
        hideMenu()
        HomeVC.swipe = true
        
        let allPersonVC = storyboard?.instantiateViewController(withIdentifier: "allPersonVC") as! AllPersonVC
        self.present(allPersonVC, animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        hideMenu()
        HomeVC.swipe = true
        home.logOut()
    }
}
