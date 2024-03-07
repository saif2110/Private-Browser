//
//  WelcomeEnd.swift
//  SplitBrowser
//
//  Created by Saif Mukadam on 15/01/24.
//

import UIKit

class WelcomeEnd: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func `continue`(_ sender: Any) {
      
        Manager.isWelcomeDone = true
        
        DispatchQueue.main.async {
            let vc = IAPViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
