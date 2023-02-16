//
//  CityCustomCell.swift
//  iWeather
//
//  Created by Vladimir Kovalev on 15.02.2023.
//

import UIKit
import SwipeCellKit

class CityCustomCell: SwipeTableViewCell {

  
    @IBOutlet var backGround: UIView!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backGround.backgroundColor = Tracker.mode ? #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 0, green: 0.6784313725, blue: 0.7098039216, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
