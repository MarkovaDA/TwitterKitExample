//
//  DetailViewController.swift
//  SimpleTweeterClient
//
//  Created by Darya Markova on 24.03.2018.
//  Copyright © 2018 Darya Markova. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageTableView: UITableView!
    @IBOutlet weak var titleLabelUI: UILabel!
    var selectedTweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.selectedTweet?.extendedEntities == nil {
            DispatchQueue.main.async {
                self.titleLabelUI.text = "No images..."
            }
        } else {
            DispatchQueue.main.async {
                self.titleLabelUI.text = "Tweet images"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 2 //будем загружать одно изображение в тесовых целях
        return self.selectedTweet?.extendedEntities?.media?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageTableViewCell
        let imageUrl: String = (self.selectedTweet?.extendedEntities?.media![indexPath.row].media_url_https)!

        TwitterApiClient.shared.uploadImage(url: imageUrl, success: { (image: UIImage) in
            DispatchQueue.main.async {
                cell.tweetImageView.image = image
            }
        }) { (error: Error) in
            
        }
        return cell
    }

}
