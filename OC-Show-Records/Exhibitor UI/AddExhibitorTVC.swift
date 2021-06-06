//
//  AddExhibitorTVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/5/21.
//

import UIKit

class AddExhibitorTVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var lastTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var address1TF: UITextField!
    @IBOutlet weak var address2TF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var zipTF: UITextField!
    
    var states: [State]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        let url = URL(string: "http://livestock-fair-records.com/get-states.php")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()

            do {
                let states = try decoder.decode([State].self, from: data)
                print(states)
                self.states = states
                
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        task.resume()
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        let state = states![self.pickerView.selectedRow(inComponent: 0)].ID!
        var components = URLComponents()
        components.scheme = "http"
        components.host = "livestock-fair-records.com"
        components.path = "/insert-exhibitor.php"
        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "firstname", value: "\(firstTF.text!)"))
        components.queryItems?.append(URLQueryItem(name: "lastname", value: "\(lastTF.text!)"))
        components.queryItems?.append(URLQueryItem(name: "email", value: "\(emailTF.text!)"))
        components.queryItems?.append(URLQueryItem(name: "address1", value: "\(address1TF.text!)"))
        components.queryItems?.append(URLQueryItem(name: "address2", value: "\(address2TF.text ?? "")"))
        components.queryItems?.append(URLQueryItem(name: "city", value: "\(cityTF.text!)"))
        components.queryItems?.append(URLQueryItem(name: "state", value: "\(state)"))
        components.queryItems?.append(URLQueryItem(name: "zip", value: "\(zipTF.text!)"))

        
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
        return 8
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (self.states == nil) {
            return 0
        }
        return self.states!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.states![row].Name!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 6 {
            return 250.0
        }
        return 44.0
    }

}
