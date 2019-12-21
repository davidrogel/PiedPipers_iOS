//
//  HomeViewController.swift
//  PiedPipers
//
//  Created by Jon Gonzalez on 17/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var userButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func userTapped(_ sender: Any) {
        guard let cuid = userButton.titleLabel?.text else {
            return
        }
        let vc = Assembler.provideUserProfile(with: cuid, status: .other)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
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
