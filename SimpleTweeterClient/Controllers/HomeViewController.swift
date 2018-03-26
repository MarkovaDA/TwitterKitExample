//
//  EntryPointViewController.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 24.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import UIKit
import TwitterKit
class HomeViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLoginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TwitterApiClient.shared.getCurrentUser(success: { (user: TWTRUser?) in
            print("SUCCESS GETTING USER")
            print("GET HOMETIMELINE")
            TwitterApiClient.shared.getHomeTimeline()
            DispatchQueue.main.async {
                self.userNameLabel.text = user?.name
                self.userLoginLabel.text = user?.screenName
            }
        }) { (error: Error?) in
            print("ERROR GETTING USER")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutBtnClick(_ sender: UIBarButtonItem) {
        //presentingViewController?.dismiss(animated: true, completion:nil)
        self.logout()
    }
    
    func logout() {
        let store = TWTRTwitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
            let loginController = storyboard?.instantiateViewController(withIdentifier: "AppLoginViewController") as! LoginViewController
            present(loginController, animated:true, completion: nil)
        }
    }
}
