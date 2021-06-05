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
        let url = URL(string: "http://livestock-fair-records.com/update-ocshow2.php?ocshowID=1&judgeName=\(self.judgeTextField.text!)&superintendentName=\(superTextField.text!)")!
        
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
