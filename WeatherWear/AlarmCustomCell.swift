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
    public var path: IndexPath? = nil
    private var subscribers: [AlarmCellSubscriber] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        
        self.backgroundColor = .darkGray
        
        
        dateFormatter.dateFormat = "hh:mm a"
        
        button.center = self.center
        button.backgroundColor = .darkGray
        button.frame = self.frame
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        self.addSubview(button)
        
//        self.textLabel?.text = "hello"
    }
    required init?(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    func setButtonTitle(title: Date?) {
        button.setTitle(dateFormatter.string(from: title ?? Date()), for: .normal)
    }
    
    func addSubscriber(sub: AlarmCellSubscriber) {
        self.subscribers = []
        self.subscribers.append(sub)
    }
    
    @objc func buttonTap() {
        print("button tap")
        for s in subscribers {
            s.alarmUpdate(index: self.path)
        }
    }
    
}

protocol AlarmCellSubscriber {
    func alarmUpdate(index: IndexPath?)
}
