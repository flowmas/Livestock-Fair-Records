//
//  AddPhoneInfoTVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/6/21.
//

import UIKit

class AddPhoneInfoTVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var exhibitorID: String!
    var phoneTypes : [PhoneType]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        let url = URL(string: "http://livestock-fair-records.com/get-phonetype.php")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()

            do {
                let phoneTypes = try decoder.decode([PhoneType].self, from: data)
                print(phoneTypes)
                self.phoneTypes = phoneTypes
                
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
        var components = URLComponents()
        components.scheme = "http"
        components.host = "livestock-fair-records.com"
        components.path = "/insert-phoneinfo.php"
        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "exhibitorID", value: "\(exhibitorID!)"))
        components.queryItems?.append(URLQueryItem(name: "type", value: "\(self.phoneTypes![self.pickerView.selectedRow(inComponent: 0)].ID!)"))
        components.queryItems?.append(URLQueryItem(name: "number", value: "\(numberTF.text!)"))
        
        let url = components.url!
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }

        task.resume()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (self.phoneTypes == nil) {
            return 0
        }
        return self.phoneTypes!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.phoneTypes![row].Name!
    }
    

}
