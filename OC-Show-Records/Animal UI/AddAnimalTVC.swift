//
//  AddAnimalTVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/5/21.
//

import UIKit

class AddAnimalTVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tagNumberTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    var exhibitorID: String!
    var breedShows : [BreedShow]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
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
                    self.pickerView.reloadAllComponents()
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        task.resume()
        
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        let doubleQuote = "\"\""
        print(doubleQuote)
        let breedShowID = breedShows![self.pickerView.selectedRow(inComponent: 0)].ID!
        var components = URLComponents()

        components.scheme = "http"
        components.host = "livestock-fair-records.com"
        components.path = "/insert-animal.php"
        components.queryItems = [URLQueryItem(name: "exhibitorID", value: self.exhibitorID), URLQueryItem(name: "tagnumber", value: "\(tagNumberTextField.text!)"), URLQueryItem(name: "breed", value: "\(breedTextField.text!)"), URLQueryItem(name: "breedshowID", value: "\(breedShowID)"), URLQueryItem(name: "name", value: "\(nameTextField.text ?? "")")]
        
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (self.breedShows == nil) {
            return 0
        }
        return self.breedShows!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.breedShows![row].BreedType!
    }

}
