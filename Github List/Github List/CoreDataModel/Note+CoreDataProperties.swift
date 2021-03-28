//
//  Note+CoreDataProperties.swift
//  Github List
//
//  Created by Ryan Enguero on 3/28/21.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: Int16
    @NSManaged public var note: String?
    @NSManaged public var notedetails: UserDetails?
    @NSManaged public var notelist: UserListDB?

}

extension Note : Identifiable {

}
