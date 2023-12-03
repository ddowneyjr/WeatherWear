//
//  AlarmViewController.swift
//  WeatherWear
//
//  Created by Zander Chown on 11/13/23.
//

import UIKit

class AlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var models = [AlarmListItem]()
    
    private var timePicker = UIDatePicker()
    
    private let timeFormat = {
        let tf = DateFormatter()
        tf.dateFormat = "hh:mm a"
        return tf
    }()
    
    private let sortTimeFormat = {
        let tf = DateFormatter()
        tf.dateFormat = "a hh:mm"
        return tf
    }()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView:UITableView = {
        let table = UITableView()
        table.register(AlarmCell.self, forCellReuseIdentifier: "alarmcell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.backgroundColor = .lightGray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        getAllItems()
    }
    
//    add functionality to choose a date
    @objc private func didTapAdd() {
        timePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timePickerChange(sender:)), for: UIControl.Event.valueChanged)
       
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(backgroundTap(gesture:)));
        self.view.addGestureRecognizer(gestureRecognizer)
        
        timePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height/2 + 60), width: self.view.frame.width, height: 150.0)
        timePicker.backgroundColor = .darkGray
        self.view.addSubview(timePicker)
    }
    
    @objc private func timePickerChange(sender: UIDatePicker) {
        print("tpc")
        timeFormat.dateFormat =  "hh:mm a"
    }
    
    @objc private func backgroundTap(gesture: UITapGestureRecognizer) {
        timeSelected(sender: timePicker)
    }
    
    @objc private func timeSelected(sender: UIDatePicker) {
        print("select")
        createItem(dt: sender.date)
        sender.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        models.sort(by: {sortTimeFormat.string(from: $0.dateTime!) < sortTimeFormat.string(from: $1.dateTime!)})
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmcell", for: indexPath) as! AlarmCell
        cell.setButtonTitle(title: model.dateTime)
        return cell
    }
   
//   add sort feature to sort by Time
    func getAllItems() {
        models.sort(by: {sortTimeFormat.string(from: $0.dateTime!) < sortTimeFormat.string(from: $1.dateTime!)})
        do {
            models = try context.fetch(AlarmListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
//           ToDo
        }
    }
    
    func createItem() -> AlarmListItem {
        let newItem = AlarmListItem(context: context)
//      default values to current time and disabled
        newItem.dateTime = Date()
        newItem.enabled = false
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
//          ToDo
        }
        
        return newItem
    }
    
    func createItem(dt: Date) -> AlarmListItem {
        let newItem = AlarmListItem(context: context)
        newItem.dateTime = dt
        newItem.enabled = false
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
//           ToDo
        }
        return newItem
    }
    
    func deleteItem(item: AlarmListItem) {
        context.delete(item)
        
        do {
            try context.save()
        }
        catch {
//           ToDo
        }
    }
    
//   ToDo
    func updateItem(item: AlarmListItem) {
    }
}

