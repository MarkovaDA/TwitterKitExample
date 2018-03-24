//
//  AppStartViewController.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 24.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import UIKit
import TwitterKit
class StartViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        //если пользователь уже авторизован - переходим на главную страницу
        if TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers() {
            let mainNavigationController = storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") as! MainNavigationController
            present(mainNavigationController, animated:false, completion: nil)
        } else {
            //редиректим его на страницу авторизации
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
}
