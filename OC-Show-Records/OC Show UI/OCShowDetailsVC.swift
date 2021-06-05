//
//  OCShowDetailsVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/4/21.
//

import UIKit

class OCShowDetailsVC: UIViewController {

    @IBOutlet weak var arenaLabel: UILabel!
    @IBOutlet weak var day1StartLabel: UILabel!
    @IBOutlet weak var day1EndLabel: UILabel!
    @IBOutlet weak var day2StartLabel: UILabel!
    @IBOutlet weak var day2EndLabel: UILabel!
    @IBOutlet weak var judgeLabel: UILabel!
    @IBOutlet weak var superLabel: UILabel!
    
    var show: OCShow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.arenaLabel.text = "Arena Name: " + show.ArenaName!
        self.day1StartLabel.text = "Day 1 Start Time: " + show.StarttimeDayOne!
        self.day1EndLabel.text = "Day 1 End Time: " + show.EndtimeDayOne!
        self.day2StartLabel.text = "Day 2 Start Time: " + show.StarttimeDayTwo!
        self.day2EndLabel.text = "Day 2 End Time: " + show.EndtimeDayTwo!
        self.judgeLabel.text = "Judge Name: " + show.JudgeName!
        self.superLabel.text = "Superintendent Name: " + show.SuperintendentName!
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
