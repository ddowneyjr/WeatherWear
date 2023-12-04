//
//  ViewController.swift
//  WeatherWear
//
//  Created by Derrell Downey on 11/9/23.
//

import UIKit

class ViewController: UIViewController {
    
    let tabBarVC = UITabBarController()
    
    var weatherSingleton: WeatherSingleton? = nil

    private let alarmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
        button.setTitle("Alarm", for: .normal)
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let clothesButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
        button.setTitle("Clothes", for: .normal)
        button.backgroundColor = .purple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let weatherButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
        button.setTitle("Weather", for: .normal)
        button.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBlue
        view.addSubview(alarmButton)
        alarmButton.addTarget(self, action: #selector(alarmButtonTap), for: .touchUpInside)
        
        view.addSubview(clothesButton)
        clothesButton.addTarget(self, action: #selector(clothesButtonTap), for: .touchUpInside)
        
        view.addSubview(weatherButton)
        weatherButton.addTarget(self, action: #selector(weatherButtonTap), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        weatherSingleton = WeatherSingleton.getInstance()
    }
   
    
    @objc func alarmButtonTap() {
        
        
        let avc = UINavigationController(rootViewController: AlarmViewController())
        avc.title = "Alarm"

        let cc = UINavigationController(rootViewController: ClothesViewController())
        cc.title = "Clothes"
        
        let wvc = UINavigationController(rootViewController: WeatherViewController())
        wvc.title = "Weather"
        
        tabBarVC.setViewControllers([avc, cc, wvc], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.isTranslucent = false
        tabBarVC.tabBar.backgroundColor = .white
        tabBarVC.tabBar.tintColor = .blue
        present(tabBarVC, animated: true)

    }
    
    @objc func clothesButtonTap() {
        
        let avc = UINavigationController(rootViewController: AlarmViewController())
        avc.title = "Alarm"

        let cc = UINavigationController(rootViewController: ClothesViewController())
        cc.title = "Clothes"
        
        let wvc = UINavigationController(rootViewController: WeatherViewController())
        wvc.title = "Weather"

        
        tabBarVC.setViewControllers([cc, avc,  wvc], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.isTranslucent = false
        tabBarVC.tabBar.backgroundColor = .white
        tabBarVC.tabBar.tintColor = .blue
        present(tabBarVC, animated: true)

    }
    
    
    @objc func weatherButtonTap() {
       
        
        let avc = UINavigationController(rootViewController: AlarmViewController())
        avc.title = "Alarm"

        let cc = UINavigationController(rootViewController: ClothesViewController())
        cc.title = "Clothes"
        
        let wvc = UINavigationController(rootViewController: WeatherViewController())
        wvc.title = "Weather"
        
        tabBarVC.setViewControllers([wvc, cc, avc], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.isTranslucent = false
        tabBarVC.tabBar.backgroundColor = .white
        tabBarVC.tabBar.tintColor = .blue
        present(tabBarVC, animated: true)

    }
    
    func createTabBar(vc: UINavigationController) {
        let tabs: [UINavigationController] = [UINavigationController(rootViewController: AlarmViewController()), UINavigationController(rootViewController: ClothesViewController()), UINavigationController(rootViewController: WeatherViewController())]
        
        tabs[0].title = "Alarm"
        tabs[0].title = "Clothes"
        tabs[0].title = "Weather"
        
        for name in tabs {
            tabBarVC.setViewControllers([name], animated: false)
            tabBarVC.modalPresentationStyle = .fullScreen
            tabBarVC.tabBar.isTranslucent = false
            tabBarVC.tabBar.backgroundColor = .white
            tabBarVC.tabBar.tintColor = .blue
        }
        
    }
    
//    @objc func weatherButtonTap() {
//        let weatherVC = WeatherViewController()
//        let navController = UINavigationController(rootViewController: weatherVC)
//        weatherVC.title = "Weather"
//
//        let tabBarVC = UITabBarController()
//        tabBarVC.setViewControllers([navController], animated: false)
//        tabBarVC.modalPresentationStyle = .fullScreen
//        tabBarVC.tabBar.isTranslucent = false
//        tabBarVC.tabBar.backgroundColor = .white
//        tabBarVC.tabBar.tintColor = .blue
//        present(tabBarVC, animated: true)
//
//    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        alarmButton.frame = CGRect(x: view.center.x - 100, y: view.center.y - 78, width: 200, height: 52)
        
        clothesButton.frame = CGRect(x: view.center.x - 100, y: alarmButton.frame.origin.y + alarmButton.frame.size.height + 10, width: 200, height: 52)
        
        weatherButton.frame = CGRect(x: view.center.x - 100, y: clothesButton.frame.origin.y + clothesButton.frame.size.height + 10, width: 200, height: 52)
    }
}

