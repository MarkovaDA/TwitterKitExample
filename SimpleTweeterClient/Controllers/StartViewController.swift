//
//  AppStartViewController.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 24.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import UIKit
import TwitterKit
class StartViewController: UIViewController {

    @IBOutlet weak var twitterIconImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.twitterIconImageView.layer.opacity = 0
        self.welcomeLabel.layer.opacity = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, animations: ({
            self.welcomeLabel.layer.opacity = 1
            self.twitterIconImageView.layer.opacity = 1
            //self.twitterIconImageView.frame.origin.x = 200
            self.welcomeLabel.center.x = self.view.frame.width/2
            self.twitterIconImageView.center.x = self.view.frame.width/2
        }), completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // your code here
            //если пользователь уже авторизован - переходим на главную страницу
            if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() {
                let mainNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") as! MainNavigationController
                self.present(mainNavigationController, animated:false, completion: nil)
            } else {
                //редиректим его на страницу авторизации
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
    }
}
