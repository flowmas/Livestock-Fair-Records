//
//  EditOCShowTVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/5/21.
//

import UIKit

class EditOCShowTVC: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var judgeTextField: UITextField!
    @IBOutlet weak var superTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        judgeTextField.delegate = self
        superTextField.delegate = self
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        var components = URLComponents()

        components.scheme = "http"
        components.host = "livestock-fair-records.com"
        components.path = "/get-classentries-by-exhibitor.php"
        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "ocshowID", value: "1"))
        components.queryItems?.append(URLQueryItem(name: "judgeName", value: "\(self.judgeTextField.text!)"))
        components.queryItems?.append(URLQueryItem(name: "superintendentName", value: "\(superTextField.text!)"))
        
        let url = components.url!
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }

        task.resume()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
