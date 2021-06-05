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
        address2Label.text = "Address 2: " + exhibitor.Address2!
        cityLabel.text = "City: " + exhibitor.City!
        stateLabel.text = "State: " + exhibitor.State!
        zipLabel.text = "Zip: " + exhibitor.Zip!
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushAnimalsScreen" {
            
        }
        
        if segue.identifier == "PresentEditExhibitorScreen" {
            
        }
    }
}
