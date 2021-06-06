//
//  ClassEntryTVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/4/21.
//

import UIKit

class ClassEntryTVC: UITableViewController {

    var classEntries : [ClassEntry]? = nil
    var breedShow: BreedShow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: "http://livestock-fair-records.com/get-classentry-by-breedshow1.php?breedshowID=\(breedShow.ID!)")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()

            do {
                let classEntries = try decoder.decode([ClassEntry].self, from: data)
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
        cell.textLabel?.text =  "Code: " + self.classEntries![indexPath.row].EntryCodeID! + " | Tag: " + self.classEntries![indexPath.row].TagNumber!
        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentAddClassEntryScreen" {
            let navVC = segue.destination as! UINavigationController
            let destinationVC = navVC.topViewController as! AddClassEntryTVC
            destinationVC.breedShow = self.breedShow
        }
    }
}
