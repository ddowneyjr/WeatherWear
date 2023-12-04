//
//  DateEntitity+CoreDataProperties.swift
//  WeatherWear
//
//  Created by Zander Chown on 12/4/23.
//
//

import Foundation
import CoreData


extension DateEntitity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DateEntitity> {
        return NSFetchRequest<DateEntitity>(entityName: "DateEntitity")
    }

    @NSManaged public var date: Date?

}

extension DateEntitity : Identifiable {

}
