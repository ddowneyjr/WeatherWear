//
//  ViewController.swift
//  WeatherWear
//
//  Created by Derrell Downey on 11/9/23.
//

import UIKit

class ViewController: UIViewController {

    private let alarmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
        button.setTitle("Alarm", for: .normal)
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBlue
        view.addSubview(alarmButton)
        alarmButton.addTarget(self, action: #selector(alarmButtonTap), for: .touchUpInside)
    }
   
    @objc func alarmButtonTap() {
        let tabBarVC = UITabBarController()
        
        let avc = UINavigationController(rootViewController: AlarmViewController())
        
        avc.title = "Alarm"
        
        tabBarVC.setViewControllers([avc], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.isTranslucent = false
        tabBarVC.tabBar.backgroundColor = .white
        tabBarVC.tabBar.tintColor = .blue
        present(tabBarVC, animated: true)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        alarmButton.center = view.center
    }
}

