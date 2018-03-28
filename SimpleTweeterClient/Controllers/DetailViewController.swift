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
    
    var selectedTweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*if let urls:[Tweet.Entity.Media] = self.selectedTweet?.entities?.media {
            for i in 0..<urls.count {
                print("\(i): \(urls[i])")
                uploadImage(index: i, url: urls[i].media_url_https!)
            }
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 2 //будем загружать одно изображение в тесовых целях
        return self.selectedTweet?.entities?.media?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageTableViewCell
        let imageUrl: String = (self.selectedTweet?.entities?.media![indexPath.row].media_url_https)!

        self.uploadImage(url: imageUrl, success: { (image: UIImage) in
            DispatchQueue.main.async {
                cell.tweetImageView.image = image
            }
        }) { (error: Error) in
            print("CELL ERROR GETTING IMAGE")
        }
        return cell
    }
    
    func uploadImage(/*index: Int,*/url: String, success: @escaping (UIImage) -> (), failure: @escaping (Error) -> ()) {
        let imageUrl = URL(string: url)
        let loadImageTask = URLSession.shared.dataTask(with: imageUrl!) {
            (data, response, error) in
            if error != nil {
                failure(error!)
            }
            else if data != nil {
                let image = UIImage(data: data!)
                success(image!)
                /*DispatchQueue.main.async {
                    let cell = self.imageTableView.cellForRow(at: IndexPath(row: index, section: 0)) as!
                        ImageTableViewCell
                    cell.tweetImageView.image = image
                    self.imageTableView.reloadData()
                }*/
            }
        }
        loadImageTask.resume()
    }
}
