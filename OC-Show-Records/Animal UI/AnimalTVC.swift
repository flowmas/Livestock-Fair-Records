//
//  AnimalTVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/4/21.
//

import UIKit

class AnimalTVC: UITableViewController {

    var animals : [Animal]? = nil
    var exhibitor : Exhibitor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.view.backgroundColor = .systemBackground
        let url = URL(string: "http://livestock-fair-records.com/get-animal-by-exhibitor.php?email=\(exhibitor.Email!)")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()

            do {
                let animals = try decoder.decode([Animal].self, from: data)
                print(animals)
                self.animals = animals
                
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
        if (self.animals == nil) {
            return 0
        }
        return self.animals!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let animal = self.animals![indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Breed: " + animal.Breed! + " | TagNumber: " + animal.TagNumber!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PushAnimalDetailsScreen", sender: nil)
    }
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushAnimalDetailsScreen" {
            let destinationVC = segue.destination as! AnimalDetailsVC
            destinationVC.animal = self.animals![self.tableView.indexPathForSelectedRow!.row]
        }
    }

}
