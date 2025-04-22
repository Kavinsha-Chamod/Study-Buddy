//
//  CountdownSession+CoreDataProperties.swift
//  Study Buddy
//
//  Created by Kavinsha Chamod on 2025-04-22.
//
//

import Foundation
import CoreData


extension CountdownSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountdownSession> {
        return NSFetchRequest<CountdownSession>(entityName: "CountdownSession")
    }

    @NSManaged public var startDate: Date?
    @NSManaged public var duration: Int32
    @NSManaged public var completed: Bool
    @NSManaged public var remainingTime: Int32

}

extension CountdownSession : Identifiable {

}
