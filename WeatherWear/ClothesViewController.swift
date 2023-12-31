//
//  ViewController.swift
//  ImageTest
//
//  Created by Cassandra Davidson on 11/14/23.
// UIColor(red: 91/255.0, green: 201/255.0, blue: 250/255.0, alpha: 1.0)

import UIKit

class ClothesViewController: UIViewController{//, CustomTableViewCellDelegate{

    private let titleArray: NSArray = ["Hats","Tops","Bottoms", "Footwear", "Outerwear"]
    
    let tops = [UIImage(named: "jacket"), UIImage(named: "tshirt")]
   
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(red: 218/255.0, green: 182/255.0, blue: 236/255.0, alpha: 1.0)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return tableView
    }()
    
    //hide top nav bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
//    func didRetrieveHomeScreenClothes(category: String, clothes: [UIImageView]) {
//        // Handle the homescreenClothes array in ClothesViewController
//        print("Category: \(category), Clothes: \(clothes)")
//
//        // Forward the category and clothes to ViewController
//        delegate?.didRetrieveHomeScreenClothes(category: category, clothes: clothes)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 218/255.0, green: 182/255.0, blue: 236/255.0, alpha: 1.0)

        //let barHeight: CGFloat = 0
        let displayWidth: CGFloat = self.view.frame.width
        //let displayHeight: CGFloat = self.view.frame.height
        
        //adding back button
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.frame = CGRect(x: 16, y: 50, width: 30, height: 30)
        backButton.tintColor = .white
      
        //setting title
        let label = UILabel(frame: CGRect(x: 0, y: 50, width: displayWidth, height: 50))
        label.text = "More Outfits"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Verdana", size: 24)
      
        //setting table view
        tableView.backgroundColor = UIColor(red: 218/255.0, green: 182/255.0, blue: 236/255.0, alpha: 1.0)
        tableView.dataSource = self
        tableView.delegate = self
        
        //adding to subview
        self.view.addSubview(tableView)
        self.view.addSubview(label)
        self.view.addSubview(backButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //to edit height of UITableView
        let topPadding: CGFloat = 100
        let bottomPadding: CGFloat = 0
        tableView.frame = CGRect(x: 0, y: topPadding, width: view.bounds.width, height: view.bounds.height - topPadding - bottomPadding)
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

}

//used to supply behavior
extension ClothesViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked: \(titleArray[indexPath.row])")
    }
    
    //edit height of cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }

}

//used to supply data
extension ClothesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        
        //cell.delegate = self
        
        let category = titleArray[indexPath.row] as! String
        cell.configure(category: category)
        cell.backgroundColor = UIColor(red: 218/255.0, green: 182/255.0, blue: 236/255.0, alpha: 1.0)
        tableView.separatorStyle = .none

        
        return cell
    }
    
}

