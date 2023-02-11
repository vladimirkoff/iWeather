//
//  ErrorViewController.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import UIKit

class ErrorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Identifiers.goBackSegue, sender: self)
    }
}
