//
//  AlarmListItem+CoreDataProperties.swift
//  WeatherWear
//
//  Created by Zander Chown on 11/28/23.
//
//

import Foundation
import CoreData


extension AlarmListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmListItem> {
        return NSFetchRequest<AlarmListItem>(entityName: "AlarmListItem")
    }

    @NSManaged public var dateTime: Date?
    @NSManaged public var enabled: Bool

}

extension AlarmListItem : Identifiable {

}
