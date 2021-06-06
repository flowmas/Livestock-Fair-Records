//
//  ExhibitorClassEntriesTVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/5/21.
//

import UIKit

class ExhibitorClassEntriesTVC: UITableViewController {

    var classEntries : [ExhibitorClassEntry]? = nil
    var exhibitor: Exhibitor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()

    }
    
    override func viewWillAppear(_ animated: Bool) {

        var components = URLComponents()

        components.scheme = "http"
        components.host = "livestock-fair-records.com"
        components.path = "/get-classentries-by-exhibitor.php"
        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "email", value: "\"\(exhibitor.Email!)\""))
        
        let url = components.url!
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()

            do {
                let classEntries = try decoder.decode([ExhibitorClassEntry].self, from: data)
                print(classEntries)
                self.classEntries = classEntries
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        task.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.classEntries == nil) {
            return 0
        }
        return self.classEntries!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  "Code: " + self.classEntries![indexPath.row].EntryCodeID!
        return cell
    }

}
