//
//  AlarmViewController.swift
//  WeatherWear
//
//  Created by Zander Chown on 11/13/23.
//

import UIKit
import EventKit
import NotificationCenter

class AlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AlarmCellSubscriber {
    private var models = [AlarmListItem]()
    
//    gross variable because it won't let me curry objc functions
    private var updateIndex: IndexPath? = nil
    
    private var timePicker = {
        let t = UIDatePicker()
        t.preferredDatePickerStyle = UIDatePickerStyle.wheels
        t.setValue(UIColor.black, forKeyPath: "textColor")
        
        t.datePickerMode = .time
          
        t.backgroundColor = .white
        
        return t
    }()
 
    
    private let eventStore = EKEventStore()
    
    private let maskingView = {
        let m = UIView()
        m.backgroundColor = .clear
        return m
    }()
    
    private let timeFormat = {
        let tf = DateFormatter()
        tf.dateFormat = "hh:mm a"
        return tf
    }()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView:UITableView = {
        let table = UITableView()
        table.register(AlarmCell.self, forCellReuseIdentifier: "alarmcell")
        return table
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timePicker.addTarget(self, action: #selector(timePickerChange(sender:)), for: UIControl.Event.valueChanged)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
//                print("got permission")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
   
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
        
        //adding back button
        let backButton = {
            let b = UIBarButtonItem(title: "", image: UIImage(systemName: "arrow.left"), target: self, action: #selector(backButtonTapped))
            b.tintColor = .white
            return b
        }()
        
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.rightBarButtonItem = {
            let t = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
            t.tintColor = .white
            return t
        }()
        
        getAllItems()
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
//    add functionality to choose a date
    @objc public func didTapAdd() {

        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(backgroundTap(gesture:)));
//        self.view.addGestureRecognizer(gestureRecognizer)
        timePicker.addGestureRecognizer(gestureRecognizer)
        
        timePicker.frame = CGRect(x: 25, y: (self.view.frame.height / 3), width: self.view.frame.width - 50, height: 300)
        
        timePicker.layer.cornerRadius = 20
        timePicker.layer.masksToBounds = true
        
        timePicker.date = Date()
        maskingView.frame = self.view.frame
        maskingView.addSubview(timePicker)
        maskingView.addGestureRecognizer(gestureRecognizer)
        self.view.addSubview(maskingView)
        
    }
    
    @objc private func timePickerChange(sender: UIDatePicker) {
        timeFormat.dateFormat =  "hh:mm a"
    }
    
    @objc private func backgroundTap(gesture: UITapGestureRecognizer) {
        timeSelected(sender: timePicker)
//        self.view.removeGestureRecognizer(gesture)
//        timePicker.removeGestureRecognizer(gesture)
        timePicker.removeFromSuperview()
        maskingView.removeGestureRecognizer(gesture)
        maskingView.removeFromSuperview()
    }
    
    @objc private func timeSelected(sender: UIDatePicker) {
//        print("select")
        createItem(dt: sender.date)
        sender.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(item: models.remove(at: indexPath.row))
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
//           do nothng
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func scheduleAlarm (item: AlarmListItem) {
//        update this with weather and clothing information
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let content = {
            let c = UNMutableNotificationContent()
            c.title = "test alarm"
            c.subtitle = "test"
            c.sound = UNNotificationSound.default
            return c
        }()
        
        var dateComp = DateComponents()
        dateComp.calendar = Calendar.current
        dateComp.hour = Calendar.current.component(.hour, from: item.dateTime ?? Date())
        dateComp.minute = Calendar.current.component(.minute, from: item.dateTime ?? Date())
        
        let dTrigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: dTrigger)
        UNUserNotificationCenter.current().add(request)
        
//        print("added request")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        models.sort(by: {sortTimeFormat.string(from: $0.dateTime!) < sortTimeFormat.string(from: $1.dateTime!)})
        models.sort(by: {getSortValue(d: $0.dateTime ?? Date()) < getSortValue(d: $1.dateTime ?? Date())})
//        print("sort done")
        let model = models[indexPath.row]
        scheduleAlarm(item: model)
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmcell", for: indexPath) as! AlarmCell
        cell.addSubscriber(sub: self)
        cell.setButtonTitle(title: model.dateTime)
        cell.path = indexPath
        return cell
    }
    
//    needed so 12 shows up first
    func getSortValue(d: Date) -> Float{
        let t = DateFormatter()
        t.dateFormat = "hh"
        
        let m = DateFormatter()
        m.dateFormat = "mm"
        
        let p = DateFormatter()
        p.dateFormat = "a"
        
        let h = String((Int(t.string(from: d)) ?? 0) % 12)
        
        var result: Float = (Float(h) ?? 0) + ((Float(m.string(from: d)) ?? 0)/100)
//        print(p.string(from: d))
        if p.string(from: d) == "AM"{
            result -= 12
        }
//        print(result)
        return result
    }
    
//   add sort feature to sort by Time
    func getAllItems() {
//        models.sort(by: {sortTimeFormat.string(from: $0.dateTime!) < sortTimeFormat.string(from: $1.dateTime!)})
        models.sort(by: {getSortValue(d: $0.dateTime ?? Date()) < getSortValue(d: $1.dateTime ?? Date())})
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
            self.view.backgroundColor = .red
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
            self.view.backgroundColor = .red
        }
        return newItem
    }
    
    func deleteItem(item: AlarmListItem) {
        context.delete(item)
        
        do {
            try context.save()
        }
        catch {
           print("delete failed to context save")
        }
    }
    
//   ToDo
    func updateItem(item: AlarmListItem, update: Date) {
        item.dateTime = update
        
        getAllItems()
    }
   
//    lets use something better in the future that doesn't involve deleting the element
    func alarmUpdate(index: IndexPath?) {
//        print("alarm update")
        updateIndex = index
        
        let gestureRecognizer = {
            let g = UITapGestureRecognizer()
            g.addTarget(self, action: #selector(backgroundTapUpdate(gesture:)))
            return g
        }()
        
//      add to timePickerView not view
        self.view.addGestureRecognizer(gestureRecognizer)
//        self.tableView.addGestureRecognizer(gestureRecognizer)
//        for t in tab
//            
//        }
//        self.view.subviews.
//        timePicker.addGestureRecognizer(gestureRecognizer)
//        self.view.addGestureRecognizer(gestureRecognizer)
        
        timePicker.frame = CGRect(x: 25, y: (self.view.frame.height / 3), width: self.view.frame.width - 50, height: 300)
        
        timePicker.layer.cornerRadius = 20
        timePicker.layer.masksToBounds = true
        
        if updateIndex ?? nil != nil {
            timePicker.date = models[updateIndex?.row ?? 0].dateTime ?? Date()
//            self.view.addSubview(timePicker)
            maskingView.frame = self.view.frame
            maskingView.addSubview(timePicker)
            maskingView.addGestureRecognizer(gestureRecognizer)
            self.view.addSubview(maskingView)
            
        }
    }
    
    @objc func backgroundTapUpdate(gesture: UITapGestureRecognizer) {
        print("background")
//        print(gesture.location(in: timePicker))
//        print(timePicker.bounds.contains(gesture.location(in: timePicker)))
        updateItem(item: models[updateIndex?.row ?? 0], update: timePicker.date)
//        timePicker.removeGestureRecognizer(gesture)
        timePicker.removeFromSuperview()
        maskingView.removeGestureRecognizer(gesture)
        maskingView.removeFromSuperview()
    }
    
}

