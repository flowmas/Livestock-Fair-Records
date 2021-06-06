//
//  EditClassEntryTVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/5/21.
//

import UIKit

class EditClassEntryTVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    @IBOutlet weak var exhibitorPickerView: UIPickerView!
    @IBOutlet weak var animalPickerView: UIPickerView!
    @IBOutlet weak var entryCodePickerView: UIPickerView!
    @IBOutlet weak var specialPlacementPickerView: UIPickerView!
    @IBOutlet weak var placementLabel: UITextField!
    @IBOutlet weak var premiumLabel: UITextField!
    @IBOutlet weak var verifiedSwitch: UISwitch!
    
    var entryCodes: [EntryCode]? = nil
    var animals: [Animal]? = nil
    var exhibitors: [Exhibitor]? = nil
    
    var breedShow: BreedShow!
    var classEntry: ClassEntry!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exhibitorPickerView.delegate = self
        exhibitorPickerView.dataSource = self
        animalPickerView.delegate = self
        animalPickerView.dataSource = self
        entryCodePickerView.delegate = self
        entryCodePickerView.dataSource = self
        specialPlacementPickerView.delegate = self
        specialPlacementPickerView.dataSource = self
        
        let url2 = URL(string: "http://livestock-fair-records.com/get-entrycode.php")!
        
        let task2 = URLSession.shared.dataTask(with: url2) { (data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()

            do {
                let entryCodes = try decoder.decode([EntryCode].self, from: data)
                print(entryCodes)
                self.entryCodes = entryCodes
                
                DispatchQueue.main.async {
                    self.entryCodePickerView.reloadAllComponents()
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        task2.resume()
        
        let url3 = URL(string: "http://livestock-fair-records.com/get-exhibitors-in-breedshow.php?breedshowID=\(self.breedShow.ID!)")!
        
        let task3 = URLSession.shared.dataTask(with: url3) { (data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()

            do {
                let exhibitors = try decoder.decode([Exhibitor].self, from: data)
                print(exhibitors)
                self.exhibitors = exhibitors
                
                DispatchQueue.main.async {
                    self.exhibitorPickerView.reloadAllComponents()
                }
                
                if self.exhibitors != nil && !self.exhibitors!.isEmpty {
                    let url = URL(string: "http://livestock-fair-records.com/get-animal-by-breedshow-and-exhibitor.php?breedshowID=\(self.breedShow.ID!)&exhibitorID=\(self.exhibitors![0].ID!)")!
                    
                    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                        guard let data = data else { return }
                        print(String(data: data, encoding: .utf8)!)
                        let decoder = JSONDecoder()

                        do {
                            let animals = try decoder.decode([Animal].self, from: data)
                            print(animals)
                            self.animals = animals
                            
                            DispatchQueue.main.async {
                                self.animalPickerView.reloadAllComponents()
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    task.resume()
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        task3.resume()
        
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "livestock-fair-records.com"
        components.path = "/update-classentry.php"
        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "placement", value: "\(placementLabel.text ?? "0")"))
        components.queryItems?.append(URLQueryItem(name: "specialPlacementID", value: "\(self.specialPlacementPickerView.selectedRow(inComponent: 0) + 1)"))
        components.queryItems?.append(URLQueryItem(name: "premium", value: "\(premiumLabel.text ?? "0")"))
        components.queryItems?.append(URLQueryItem(name: "isVerified", value: "\(getVerfied(v: self.verifiedSwitch.isOn))"))
        components.queryItems?.append(URLQueryItem(name: "entryCode", value: "\(self.entryCodes![self.entryCodePickerView.selectedRow(inComponent: 0)].EntryCode!)"))
        components.queryItems?.append(URLQueryItem(name: "animalID", value: "\(self.animals![self.animalPickerView.selectedRow(inComponent: 0)].ID!)"))
        components.queryItems?.append(URLQueryItem(name: "ID", value: "\(self.classEntry.ID!)"))
        
        
        let url = components.url!
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }

        task.resume()
    }
    
    func getSpecialPlacement(id: String) -> String {
        if id == "1" {
            return "Reserve Grand Champion"
        }
        if id == "2" {
            return "Grand Champion"
        }
        if id == "3" {
            return "Supreme Champion"
        }
        return "None"
    }
    
    func getVerfied(v: Bool) -> Int {
        if v {
            return 1
        }
        return 0
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.animalPickerView {
            return self.animals![row].TagNumber!
        } else if pickerView == self.exhibitorPickerView {
            return self.exhibitors![row].FirstName! + " " + self.exhibitors![row].LastName!
        } else if pickerView == self.specialPlacementPickerView {
            return getSpecialPlacement(id: "\(row + 1)")
        }
        return self.entryCodes![row].EntryCode! + " | " + self.entryCodes![row].Description!
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.animalPickerView {
            if (self.animals == nil) {
                return 0
            }
            return self.animals!.count
        } else if pickerView == self.exhibitorPickerView {
            if (self.exhibitors == nil) {
                return 0
            }
            return self.exhibitors!.count
        } else if pickerView == self.specialPlacementPickerView {
            return 4
        }
        if (self.entryCodes == nil) {
            return 0
        }
        return self.entryCodes!.count
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.exhibitorPickerView {
            let url = URL(string: "http://livestock-fair-records.com/get-animal-by-breedshow-and-exhibitor.php?breedshowID=\(self.breedShow.ID!)&exhibitorID=\(self.exhibitors![row].ID!)")!
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                print(String(data: data, encoding: .utf8)!)
                let decoder = JSONDecoder()

                do {
                    let animals = try decoder.decode([Animal].self, from: data)
                    print(animals)
                    self.animals = animals
                    
                    DispatchQueue.main.async {
                        self.animalPickerView.reloadAllComponents()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }

}
