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
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.blockApplicationUI()
        TwitterApiClient.shared.getCurrentUser(success: { (user: TWTRUser?) in
            TwitterApiClient.shared.getHomeTimeline()
            DispatchQueue.main.async {
                self.userNameLabel.text = user?.name
                self.userLoginLabel.text = user?.screenName
                //получение списка твитов и обновление формы
                self.unblockApplicationUI()
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
    
    func blockApplicationUI() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func unblockApplicationUI() {
        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
    }
}
