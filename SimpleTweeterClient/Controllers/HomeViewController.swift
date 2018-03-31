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
    @IBOutlet weak var tweetTableView: UITableView!
    
    var activityIndicator = UIActivityIndicatorView()
    //! использовать разделяемый ресурс твитов - при создании твита добавлять новый твит в список, не перегружая форму
    var tweets: [Tweet]? = [] //cписок твитов текущего пользователя
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tweetTableView.estimatedRowHeight = 150
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
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
        let createTweet = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTweetController")
            as! CreateTweetViewController
        self.addChildViewController(createTweet)
        createTweet.view.frame = self.view.frame
        self.view.addSubview(createTweet.view)
        createTweet.didMove(toParentViewController: self)
        /*let createTweetController = self.storyboard?.instantiateViewController(withIdentifier: "CreateTweetController")
            as! CreateTweetViewController
        self.present(createTweetController, animated: true, completion: nil)*/
        //детектировать изменения
    }
    
    
    func reloadTweetTable() {
        self.blockApplicationUI()
        TwitterApiClient.shared.getHomeTimeline(success: {(tweets: [Tweet]?) in
            DispatchQueue.main.async {
                self.tweets = tweets
                self.tweetTableView.reloadData()
                self.unblockApplicationUI()
            }
        }, failure: {(error: Error?) in
            print(error)
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
