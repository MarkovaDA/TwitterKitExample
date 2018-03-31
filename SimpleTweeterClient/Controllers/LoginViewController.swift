//
//  AppLoginViewController.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 24.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import UIKit
import Foundation
import TwitterKit
class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginBtnClicked(_ sender: UIButton) {
        self.login()
    }
    
    func login() {
        TWTRTwitter.sharedInstance().logIn {(session, error) in
            if session != nil {
                self.performSegue(withIdentifier: "homeSegue", sender: self)
                print("SUCCESS LOGIN \(String(describing: session?.userName))")
            } else {
                // log error
                print("FAILURE LOGIN \(String(describing: error))")
            }
        }
    }
}
