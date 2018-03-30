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
    @IBOutlet weak var userImageView: UIImageView!
    
    var activityIndicator = UIActivityIndicatorView()
    var tweets: [Tweet]? = [] //cписок твитов текущего пользователя
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.userImageView.layer.cornerRadius = 50
        /*self.userImageView.layer.borderColor = UIColor(red: 100, green: 120, blue: 130, alpha: 1)
        self.userImageView.layer.borderWidth = 3*/
        self.tweetTableView.estimatedRowHeight = 150
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        self.blockApplicationUI()
        TwitterApiClient.shared.getCurrentUser(success: { (user: TWTRUser?) in
            DispatchQueue.main.async {
                self.userNameLabel.text = user?.name
            }
            self.reloadTweetTable()
        }) { (error: Error?) in
            print("ERROR GETTING USER")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutBtnClick(_ sender: UIBarButtonItem) {
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
        cell.tweetTextField.text = self.tweets![indexPath.row].fullText
        cell.tweetDateLabel.text = formatter.string(from: self.tweets![indexPath.row].createdAt)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "TweetDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView = segue.destination as? DetailViewController
        if (detailView != nil) {
            let index = self.tweetTableView.indexPathForSelectedRow?.row //номер выбранного твита
            detailView?.selectedTweet = self.tweets?[index!]
        }
    }
    
    @IBAction func onShareTweetBtnClick(_ sender: UIButton) {
        self.showComposer()
    }
    
    func showComposer() {
        //опубликовать твит
        //сделать свою форму, которая позволит выбирать изображение (загружать) и отправлять твит
        //TwitterApiClient.shared.client.sendTweet(withText: <#T##String#>, image: <#T##UIImage#>, completion: <#T##TWTRSendTweetCompletion##TWTRSendTweetCompletion##(TWTRTweet?, Error?) -> Void#>)
        let composer = TWTRComposer();
        composer.setText("");
        composer.show(from: self) {
            result in
            if (result == .done) {
                print("UPDATE TWEETS TABLE")
                //добавился новый твит - обновляем твиты в таблице
                self.blockApplicationUI()
                self.reloadTweetTable()
            }
        }
    }
    
    func reloadTweetTable() {
        TwitterApiClient.shared.getHomeTimeline(success: {(tweets: [Tweet]?) in
            DispatchQueue.main.async {
                self.tweets = tweets
                self.tweetTableView.reloadData()
                self.unblockApplicationUI()
            }
        }, failure: {(error: Error?) in
            print("ERROR GETTING TWEETS")
        })
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
