//
//  EntryPointViewController.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 24.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import UIKit
import TwitterKit
class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLoginLabel: UILabel!
    @IBOutlet weak var tweetTableView: UITableView!
    
    var activityIndicator = UIActivityIndicatorView()
    var tweets: [Tweet]? = [] //cписок твитов текущего пользователя
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tweetTableView.estimatedRowHeight = 100
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        self.blockApplicationUI()
        TwitterApiClient.shared.getCurrentUser(success: { (user: TWTRUser?) in
            TwitterApiClient.shared.getHomeTimeline(success: {(tweets: [Tweet]?) in
                DispatchQueue.main.async {
                    self.userNameLabel.text = user?.name
                    //self.userLoginLabel.text = user?.screenName
                    self.tweets = tweets
                    self.tweetTableView.reloadData()
                    //print("КОЛ-ВО ТВИТОВ \(tweets?.count)")
                    self.unblockApplicationUI()
                }
            }, failure: {(error: Error?) in
                print("ERROR GETTING TWEETS")
            })
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        cell.tweetTextField.text = self.tweets![indexPath.row].text
        cell.tweetDateLabel.text = formatter.string(from: self.tweets![indexPath.row].createdAt)
        return cell
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
