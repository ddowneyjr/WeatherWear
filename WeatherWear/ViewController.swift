//
//  ViewController.swift
//  WeatherWear
//
//  Created by Derrell Downey on 11/9/23.
//

import UIKit

class ViewController: UIViewController, CustomTableViewCellDelegate {
    
    let tBar = {
        let t = UITabBarController()
        let avc = UINavigationController(rootViewController: AlarmViewController())
        avc.title = "Alarm"
        
        let cc = UINavigationController(rootViewController: ClothesViewController())
        cc.title = "Clothes"
        
        let wvc = UINavigationController(rootViewController: WeatherViewController())
        wvc.title = "Weather"
        
        t.setViewControllers([wvc, cc, avc], animated: false)
        t.modalPresentationStyle = .fullScreen
        t.tabBar.isTranslucent = false
        t.tabBar.backgroundColor = .white
        t.tabBar.tintColor = .blue
        return t
    }()
    
    
    var weatherSingleton: WeatherSingleton? = nil
    
    //trying to get certain uiimageviews from customtableviewcell
    var homeScreenClothes: [UIImageView] = []
    func didRetrieveHomeScreenClothes(category: String, clothes: [UIImageView]) {
        // Handle the homescreenClothes array in ViewController
        print("\n\nCategory: \(category), Clothes: \(clothes)\n\n")
        
        homeScreenClothes = clothes
    }
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let alarmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        button.setTitle("Alarm", for: .normal)
        button.backgroundColor =  UIColor(red: 142/255.0, green: 142/255.0, blue: 147/255.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let clothesButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        button.setTitle("Clothes", for: .normal)
        button.backgroundColor =  UIColor(red: 175/255.0, green: 82/255.0, blue: 222/255.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let weatherButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        button.setTitle("Weather", for: .normal)
        button.backgroundColor = UIColor(red: 91/255.0, green: 201/255.0, blue: 250/255.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //view.backgroundColor = .systemBlue
        backgroundImageView.image = UIImage(named: "backgroundImage")

        view.addSubview(alarmButton)
        alarmButton.addTarget(self, action: #selector(alarmButtonTap), for: .touchUpInside)
        
        view.addSubview(weatherButton)
        weatherButton.addTarget(self, action: #selector(weatherButtonTap), for: .touchUpInside)
        
        view.addSubview(clothesButton)
        clothesButton.addTarget(self, action: #selector(clothesButtonTap), for: .touchUpInside)
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        //didRetrieveHomeScreenClothes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        weatherSingleton = WeatherSingleton.getInstance()
    }
   
    
    @objc func alarmButtonTap() {
        tBar.selectedIndex = 2
        
        present(tBar, animated: true)
    }
    
    @objc func clothesButtonTap() {
        tBar.selectedIndex = 1
        present(tBar, animated: true)
    }
    
    @objc func weatherButtonTap() {
        tBar.selectedIndex = 0
        present(tBar, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        alarmButton.frame = CGRect(x: view.center.x - 100, y: view.center.y - 78, width: 200, height: 52)
        
        weatherButton.frame = CGRect(x: view.center.x - 100, y: alarmButton.frame.origin.y + alarmButton.frame.size.height + 10, width: 200, height: 52)
        
        clothesButton.frame = CGRect(x: view.center.x - 100, y: weatherButton.frame.origin.y + weatherButton.frame.size.height + 10, width: 200, height: 52)
        
        
    }
}

