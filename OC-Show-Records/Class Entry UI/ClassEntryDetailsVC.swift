//
//  ClassEntryDetailsVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/4/21.
//

import UIKit

class ClassEntryDetailsVC: UIViewController {

    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var placementLabel: UILabel!
    @IBOutlet weak var specialPlacementLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var earTagLabel: UILabel!
    
    var classEntry: ClassEntry!
    var breedShow: BreedShow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.entryLabel.text = "Entry Code: " + classEntry.EntryCodeID!
        self.placementLabel.text = "Placement: " + placementLabel.text!
        self.specialPlacementLabel.text = "Special Placement: " + getSpecialPlacement(id: self.classEntry.SpecialPlacementID!)
        self.premiumLabel.text = "Premium: " + self.classEntry.Premium!
        self.earTagLabel.text = "Ear Tag: " + self.classEntry.TagNumber!
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentEditClassEntryScreen" {
            let navVC = segue.destination as! UINavigationController
            let destinationVC = navVC.topViewController as! EditClassEntryTVC
            destinationVC.breedShow = self.breedShow
            destinationVC.classEntry = self.classEntry
        }
    }


}
