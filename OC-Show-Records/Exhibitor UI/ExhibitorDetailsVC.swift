//
//  ExhibitorDetailsVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/4/21.
//

import UIKit

class ExhibitorDetailsVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    
    var exhibitor: Exhibitor!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = "Name: " + exhibitor.FirstName! + " " + exhibitor.LastName!
        emailLabel.text = "Email: " + exhibitor.Email!
        address1Label.text = "Address 1: " + exhibitor.Address1!
        if let address2 = exhibitor.Address2 {
            address2Label.text = "Address 2: " + address2
        } else {
            address2Label.text = "Address 2: (Empty)"
        }
        cityLabel.text = "City: " + exhibitor.City!
        stateLabel.text = "State: " + exhibitor.State!
        zipLabel.text = "Zip: " + exhibitor.Zip!
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushAnimalsScreen" {
            let destinationVC = segue.destination as! AnimalTVC
            destinationVC.title = self.exhibitor.FirstName! + "'s Animals"

            destinationVC.exhibitor = self.exhibitor
        }
        
        if segue.identifier == "PresentEditExhibitorScreen" {
            
        }
    }
}
