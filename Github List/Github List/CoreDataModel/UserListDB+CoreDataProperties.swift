//
//  UserListDB+CoreDataProperties.swift
//  Github List
//
//  Created by Ryan Enguero on 3/28/21.
//
//

import Foundation
import CoreData


extension UserListDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserListDB> {
        return NSFetchRequest<UserListDB>(entityName: "UserListDB")
    }

    @NSManaged public var avatar_url: String?
    @NSManaged public var events_url: String?
    @NSManaged public var followers_url: String?
    @NSManaged public var following_url: String?
    @NSManaged public var gists_url: String?
    @NSManaged public var gravatar_id: String?
    @NSManaged public var html_url: String?
    @NSManaged public var id: Int16
    @NSManaged public var login: String?
    @NSManaged public var node_id: String?
    @NSManaged public var organizations_url: String?
    @NSManaged public var received_events_url: String?
    @NSManaged public var repos_url: String?
    @NSManaged public var site_admin: Bool
    @NSManaged public var starred_url: String?
    @NSManaged public var subscriptions_url: String?
    @NSManaged public var type: String?
    @NSManaged public var url: String?
    @NSManaged public var note: Note?

}

extension UserListDB : Identifiable {

}
