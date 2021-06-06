//
//  ExportVC.swift
//  OC-Show-Records
//
//  Created by Sam Wolf on 6/5/21.
//

import UIKit
import MessageUI

class ExportVC: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var exportButton: UIButton!
    
    var winners : [Winners]? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.exportButton.isEnabled = false
        let url = URL(string: "http://livestock-fair-records.com/get-winners.php")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()

            do {
                let winners = try decoder.decode([Winners].self, from: data)
                print(winners)
                self.winners = winners
                
                DispatchQueue.main.async {
                    self.exportButton.isEnabled = true
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        task.resume()
    }
    
    func winnerMessage() -> String {
        var stringToReturn = ""
        guard let winners = self.winners else { return stringToReturn }
        for winner in winners {
            stringToReturn += "Name: " + winner.FirstName! + " " + winner.LastName! + " | Animal Tag: " + winner.TagNumber! + " | Placement: " + winner.Placement! + " | Premium: " + winner.Premium!
            stringToReturn += "\n"
        }
        return stringToReturn
    }

    @IBAction func exportButtonTapped(_ sender: UIButton) {
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["spraydan@uw.edu"])
            mail.setMessageBody(winnerMessage(), isHTML: false)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
