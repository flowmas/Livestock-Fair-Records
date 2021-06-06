//
//  PhoneInfoTVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/6/21.
//

import UIKit

class PhoneInfoTVC: UITableViewController {
    
    var phones : [PhoneInfo]? = nil
    
    var exhibitor: Exhibitor!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.phones == nil) {
            return 0
        }
        return self.phones!.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: "http://livestock-fair-records.com/get-phoneinfo-by-exhibitor.php?exhibitorID=\(exhibitor.ID!)")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()

            do {
                let phones = try decoder.decode([PhoneInfo].self, from: data)
                print(phones)
                self.phones = phones
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        task.resume()
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let phone = phones![indexPath.row]
        cell.isUserInteractionEnabled = false
        cell.textLabel?.text = phone.Number! + " | " + phone.Name!
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var components = URLComponents()

            components.scheme = "http"
            components.host = "livestock-fair-records.com"
            components.path = "/delete-phoneinfo.php"
            components.queryItems = [URLQueryItem(name: "phoneinfoID", value: "\(self.phones![indexPath.row].ID!)"), ]
            
            let url = components.url!
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    self.phones?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }

            }
            task.resume()
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentAddPhoneInfoScreen" {
            let navVC = segue.destination as! UINavigationController
            let destinationVC = navVC.topViewController as! AddPhoneInfoTVC
            destinationVC.exhibitorID = self.exhibitor.ID!
        }
    }

}
