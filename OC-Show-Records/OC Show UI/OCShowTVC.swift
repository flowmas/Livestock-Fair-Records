//
//  OCShowTVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/4/21.
//

import UIKit

class OCShowTVC: UITableViewController {
    
    var shows : [OCShow]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.view.backgroundColor = .systemBackground
        let url = URL(string: "http://livestock-fair-records.com/get-ocshows.php")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()

            do {
                let shows = try decoder.decode([OCShow].self, from: data)
                print(shows)
                self.shows = shows
                
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
        if (self.shows == nil) {
            return 0
        }
        return self.shows!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "OC Sheep Show #\(indexPath.row + 1)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PushOCShowDetailsScreen", sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushOCShowDetailsScreen" {
            let destinationVC = segue.destination as! OCShowDetailsVC
            destinationVC.show = self.shows![self.tableView.indexPathForSelectedRow!.row]
        }
    }
}
