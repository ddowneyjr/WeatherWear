//
//  AlarmCustomCell.swift
//  WeatherWear
//
//  Created by Zander Chown on 11/29/23.
//

import UIKit

class AlarmCell: UITableViewCell {
    let button = UIButton()
    private let dateFormatter = DateFormatter()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        dateFormatter.dateFormat = "hh:mm a"
        
        button.center = self.center
        button.backgroundColor = .blue
        button.frame = self.frame
        
        
        self.addSubview(button)
//        self.textLabel?.text = "hello"
    }
    required init?(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    func setButtonTitle(title: Date?) {
        button.setTitle(dateFormatter.string(from: title ?? Date()), for: .normal)
    }
}
