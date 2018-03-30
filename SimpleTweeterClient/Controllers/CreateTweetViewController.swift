//
//  CreateTweetViewController.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 30.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import UIKit

class CreateTweetViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupView.frame.origin.y = 0
        self.popupView.layer.opacity = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 15,
                       animations: ({
                        self.popupView.layer.opacity = 1
                        self.popupView.frame.origin.y = self.popupView.frame.height/2
                       }),
                       completion: nil
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onBtnCancelClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
