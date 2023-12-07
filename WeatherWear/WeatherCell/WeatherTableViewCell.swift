//
//  WeatherTableViewCell.swift
//  NewWeather
//
//  Created by Derrell Downey on 11/25/23.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .gray
        self.selectedBackgroundView?.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: WeatherData) {
        self.lowTempLabel.text = "\(Int(model.low_temp))°"
        self.highTempLabel.text = "\(Int(model.high_temp))°"
        self.dayLabel.text = model.datetime
        
//        self.lowTempLabel.text = "12°"
//        self.highTempLabel.text = "25°"
        self.lowTempLabel.textColor = .white
        self.highTempLabel.textColor = .white
        self.dayLabel.textColor = .white
        
        
        
        print(self.lowTempLabel.text!)
        print(self.highTempLabel.text!)
        print(self.dayLabel.text!)
        
    }
    
}
