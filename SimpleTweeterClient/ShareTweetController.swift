//
//  ShareTweetController.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 23.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import UIKit
import TwitterKit

class LoginController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                //session?.authToken;
                //session?.authTokenSecret;
                //session?.userName
                print("signed in as \(String(describing: session?.userName))");
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
    }
}
