//
//  ExhibitorTVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 5/27/21.
//

import UIKit

class ExhibitorTVC: UITableViewController {

    var exhibitors : [Exhibitor]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.view.backgroundColor = .systemBackground
        let url = URL(string: "http://livestock-fair-records.com/get-exhibitors.php")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()

            do {
                let people = try decoder.decode([Exhibitor].self, from: data)
                print(people)
                self.exhibitors = people
                
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
        if (self.exhibitors == nil) {
            return 0
        }
        return self.exhibitors!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if (self.exhibitors == nil) {
            return cell
        }
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.exhibitors![indexPath.row].FirstName! + " " + self.exhibitors![indexPath.row].LastName!

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PushExhibitorDetailsScreen", sender: nil)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            var components = URLComponents()

            components.scheme = "http"
            components.host = "livestock-fair-records.com"
            components.path = "/delete-exhibitor.php"
            components.queryItems = [URLQueryItem(name: "exhibitorID", value: "\(self.exhibitors![indexPath.row].ID!)"), ]
            
            let url = components.url!
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    self.exhibitors?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }

            }
            task.resume()
        }   
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushExhibitorDetailsScreen" {
            let destinationVC = segue.destination as! ExhibitorDetailsVC
            destinationVC.exhibitor = self.exhibitors![self.tableView.indexPathForSelectedRow!.row]
        }
    }
}
