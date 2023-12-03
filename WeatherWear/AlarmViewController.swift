//
//  AlarmViewController.swift
//  WeatherWear
//
//  Created by Zander Chown on 11/13/23.
//

import UIKit
import EventKit
import NotificationCenter

class AlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var models = [AlarmListItem]()
    
    private var timePicker = UIDatePicker()
    
    private let eventStore = EKEventStore()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("got permission")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
//        
//        eventStore.requestAccess(to: .event) { success, error  in
//            if success {
//                print("got permission")
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }
        
        getEventPerm()
       
    }
    
    func getEventPerm() {
//        commented out because not required for the notification type we are using
//
//        if #available(iOS 17.0, *) {
//            print("getting event permission")
//            eventStore.requestFullAccessToEvents() { success, error in
//                if success {
//                    print("event perms")
//                } else if let error = error {
//                    print(error.localizedDescription)
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//            print("wrong version bad news")
//        }
//        eventStore.requestAccess(to: .event, completion: {(accessGranted: Bool, error: Error?) in
//
//            if accessGranted == true {
//                print("Access Has Been Granted")
//                }
//            else {
//                print("Change Settings to Allow Access")
//            }
//            })
        
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        getAllItems()
    }
    
//    add functionality to choose a date
    
    @objc public func didTapAdd() {

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
        
//        This code does not do what I hoped adding events to the calander still results in the same type of notification
//
        
//        let d = timeFormat.date(from: timeFormat.string(from: item.dateTime ?? Date()))
//        let currentStatus = EKEventStore.authorizationStatus(for: EKEntityType.event)
//        if currentStatus == EKAuthorizationStatus.notDetermined {
//            print("dont know")
//            getEventPerm()
//        } else if currentStatus == EKAuthorizationStatus.authorized {
//            print("good to go")
//        } else {
//            print("not good")
//            getEventPerm()
//        }
//        let event = {
//            let e = EKEvent(eventStore: eventStore)
//            e.title =  "Alarm!"
//            e.notes = "alarm"
//            e.calendar = eventStore.defaultCalendarForNewEvents
//            e.startDate = item.dateTime?.addingTimeInterval(60)
//            e.endDate = item.dateTime?.addingTimeInterval(120)
//            return e
//        }()
//        
//        
//        let alarm = EKAlarm(relativeOffset: -60)
//        event.addAlarm(alarm)
//    
//        do {
//            try eventStore.save(event, span: .thisEvent)
//        } catch {
//            print("uh oh")
//        }
//        
//        let e = eventStore.events(matching: eventStore.predicateForEvents(withStart: item.dateTime?.addingTimeInterval(60) ?? Date(), end: item.dateTime?.addingTimeInterval(60) ?? Date(), calendars: nil))
//        if e.count == 0{
//            print("not added")
//        }
        
        print("added request")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        models.sort(by: {sortTimeFormat.string(from: $0.dateTime!) < sortTimeFormat.string(from: $1.dateTime!)})
        let model = models[indexPath.row]
        scheduleAlarm(item: model)
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
           print("delete failed to context save")
        }
    }
    
//   ToDo
    func updateItem(item: AlarmListItem) {
    }
    
}

