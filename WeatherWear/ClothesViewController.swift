//
//  ViewController.swift
//  ImageTest
//
//  Created by Cassandra Davidson on 11/14/23.
//

import UIKit

class ClothesViewController: UIViewController{

    private let titleArray: NSArray = ["Hats","Tops","Bottoms", "Footwear", "Outerwear"]
    
    let tops = [UIImage(named: "jacket"), UIImage(named: "tshirt")]
   
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 218/255.0, green: 182/255.0, blue: 236/255.0, alpha: 1.0)

        //let barHeight: CGFloat = 0
        let displayWidth: CGFloat = self.view.frame.width
        //let displayHeight: CGFloat = self.view.frame.height
        

//        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
//        self.navigationItem.leftBarButtonItem = backButton
        
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
        //tableView = UITableView(frame: CGRect(x: 50, y: barHeight+100, width: displayWidth, height: displayHeight - barHeight))
        tableView.backgroundColor = UIColor(red: 218/255.0, green: 182/255.0, blue: 236/255.0, alpha: 1.0)
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.rowHeight = UITableView.automaticDimension
        
        
        //adding to subview
        self.view.addSubview(tableView)
        self.view.addSubview(label)
        self.view.addSubview(backButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //to edit height of UITableView
        let topPadding: CGFloat = 0
        let bottomPadding: CGFloat = 0
        tableView.frame = CGRect(x: 0, y: topPadding, width: view.bounds.width, height: view.bounds.height - topPadding - bottomPadding)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
        
        let category = titleArray[indexPath.row] as! String
        cell.configure(category: category)
        
        return cell
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor(red: 180/255.0, green: 93/255.0, blue: 224/255.0, alpha: 1.0)
//
//    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
}

