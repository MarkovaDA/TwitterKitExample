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
    @IBOutlet weak var tweetTextField: UITextView!
    
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
    //отправка твита
    @IBAction func onBtnTweetClicked(_ sender: UIButton) {
        let tweetText = tweetTextField.text
        if tweetText != nil && tweetText != "" {
            TwitterApiClient.shared.uploadTweet(text: tweetText!, success: { (tweet) in
                self.showAlertMessage(message: "Success creating tweet!")
                //alert об успешной отправке
            }) { (error) in
                self.showAlertMessage(message: "Error creating tweet :(")
                //alert c информацией о том, что при отправке твита возникли ошибки
            }
        }
    }
    
    @IBAction func onBtnCancelClicked(_ sender: UIButton) {
        let parent = self.parent as! HomeViewController
        parent.reloadTweetTable()
        self.view.removeFromSuperview()
        //dismiss(animated: true, completion: nil)
    }
    
    func showAlertMessage(message: String) {
        let alert = UIAlertController(title: "", message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion:nil)
        }))
    
        self.present(alert, animated: true, completion: nil)
    }
}
