//
//  ViewController.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 22.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var tweetsTableView: UITableView!
    
    var tweets = ["Tweet1", "Tweet2", "Tweet3", "Tweet4", "Tweet5"] //список твитов юзера
    var activityIndicator = UIActivityIndicatorView()
    
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
    
    @IBAction func onBtnSearchClick(_ sender: UIButton) {
        let searchedPattern = searchTextField.text;
        
        if (searchedPattern == nil) {
            return;
        }
        
        if searchedPattern != "" {
            blockApplicationUI()
            let searchedUser =
                searchedPattern!.replacingOccurrences(of: " ", with: "");
            getMatchingUsers(userNickname: searchedUser);
        }
    }
    
    //поиск подходящих юзеров по паттерну
    func getMatchingUsers(userNickname: String) {
        //api http-запрос с токеном на поиск список пользователей
        let url = URL(string: "https://twitter.com/" + userNickname);
        let task = URLSession.shared.dataTask(with: url!) {(data,response,error) in
            if error != nil {
                DispatchQueue.main.async {
                    if let errorMessage = error?.localizedDescription {
                        self.userNicknameLabel.text = errorMessage
                        print(errorMessage);
                    } else {
                        self.userNicknameLabel.text = "Error searching";
                    }
                }
            } else {
                let userResponse: String = String(data: data!, encoding: String.Encoding.utf8)!
                //Get the user name
                var array:[String] = userResponse.components(separatedBy: "<title>");
                array = array[1].components(separatedBy: " |");
                let userName = array[0]
                //Get the profile picture
                array.removeAll()
                array = userResponse.components(separatedBy: "data-resolved-url-large=\"");
                array = array[1].components(separatedBy: "\"")
                let profilePicture = array[0]
                //Get the tweets
                array = userResponse.components(separatedBy: "data-aria-label-part=\"0\">")
                array.remove(at: 0)
                for i in 0...array.count - 1 {
                    let newTweet = array[i].components(separatedBy: "<")
                    array[i] = newTweet[0]
                }
                self.tweets = array
                //updating the interface
                DispatchQueue.main.async {
                    self.userNicknameLabel.text = userName
                    self.updateImage(url: profilePicture)
                    self.tweetsTableView.reloadData()
                    self.unblockApplicationUI()
                }
            }
        }
        task.resume()
    }
    
    func updateImage(url: String) {
        let url = URL(string: url)
        let task = URLSession.shared.dataTask(with: url!){(data,response, error) in
            DispatchQueue.main.async {
                self.userImageView.image = UIImage(data: data!);
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tweets.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! UserSearchTableViewCell
        
        cell.tweetTextView.text = self.tweets[indexPath.row]
        //установить линий динамически
        return (cell)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

