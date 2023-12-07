//
//  WeatherSingletonItem+CoreDataProperties.swift
//  WeatherWear
//
//  Created by Derrell Downey on 12/5/23.
//
//

import Foundation
import CoreData


extension WeatherSingletonItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherSingletonItem> {
        return NSFetchRequest<WeatherSingletonItem>(entityName: "WeatherSingletonItem")
    }

    @NSManaged public var myInstanceItem: NSObject?

}

extension WeatherSingletonItem : Identifiable {

}
