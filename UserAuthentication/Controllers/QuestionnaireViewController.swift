//
//  QuestionnaireViewController.swift
//  UserAuthentication
//
//  Created by Rick DeAmicis on 5/11/23.
//

import UIKit

class QuestionnaireViewController: UIViewController {

    @IBOutlet private weak var username: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setup(username: String) {
        self.username.text = username
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
