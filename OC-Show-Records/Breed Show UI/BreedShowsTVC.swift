//
//  BreedShowsTVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/4/21.
//

import UIKit

class BreedShowsTVC: UITableViewController {

    var breedShows : [BreedShow]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: "http://livestock-fair-records.com/get-breedshows.php")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()

            do {
                let breedShows = try decoder.decode([BreedShow].self, from: data)
                print(breedShows)
                self.breedShows = breedShows
                
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
        if (self.breedShows == nil) {
            return 0
        }
        return self.breedShows!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = breedShows![indexPath.row].BreedType
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PushClassEntryScreen", sender: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushClassEntryScreen" {
            let destinationVC = segue.destination as! ClassEntryTVC
            destinationVC.breedShow = self.breedShows![self.tableView.indexPathForSelectedRow!.row]
        }
    }
}
