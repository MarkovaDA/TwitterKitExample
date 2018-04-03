//
//  NewTweetPopupViewController.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 31.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import UIKit

class InfoPopupViewController: UIViewController {
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var friendsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        //self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        // Do any additional setup after loading the view.
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        TwitterApiClient.shared.getCurrentUserProfile(success: { (user) in
            TwitterApiClient.shared.uploadImage(url: "https://twitter.com/\(user.screenName)/profile_image?size=original", success: { (image: UIImage) in
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }) { (error: Error) in}
            DispatchQueue.main.async {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
                self.screenNameLabel.text = "(\(user.screenName))"
                self.creationDateLabel.text = formatter.string(from: user.createdAt)
                self.friendsCountLabel.text = String(user.friendsCount)
                self.followersCountLabel.text = String(user.followersCount)
                //self.profileImageView.image;
            }
        }) { (error) in
            print("error getting user info")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        //self.view.removeFromSuperview()
        self.hideAnimate()
    }
    
    func showAnimate() {
        self.view.alpha = 0.0
        self.view.transform = CGAffineTransform(scaleX: 1.5,y: 1.5)
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func hideAnimate() {
        UIView.animate(withDuration: 0.25, delay: 0, animations: {
            UIView.animate(withDuration: 0.5) {
                self.view.alpha = 0.0
                self.view.transform = CGAffineTransform(scaleX: 1.5,y: 1.5)
            }
        }, completion: { (finished: Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
    }
}
