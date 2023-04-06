//
//  ErrorViewController.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 10.02.2023.
//

import UIKit

class ErrorViewController: UIViewController {
    //MARK: - Properties
    
    @IBOutlet var backGround: UIView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
    }
    
    //MARK: - Actions
    
    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Identifiers.goBackSegue, sender: self)
    }
}
