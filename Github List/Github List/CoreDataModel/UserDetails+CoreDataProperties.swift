//
//  UserDetails+CoreDataProperties.swift
//  Github List
//
//  Created by Ryan Enguero on 3/28/21.
//
//

import Foundation
import CoreData


extension UserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails")
    }

    @NSManaged public var bio: String?
    @NSManaged public var blog: String?
    @NSManaged public var company: String?
    @NSManaged public var created_at: String?
    @NSManaged public var email: String?
    @NSManaged public var followers: Int16
    @NSManaged public var following: Int16
    @NSManaged public var hireable: String?
    @NSManaged public var id: Int16
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var public_gists: Int16
    @NSManaged public var public_repos: Int16
    @NSManaged public var twitter_username: String?
    @NSManaged public var updated_at: String?
    @NSManaged public var note: Note?

}

extension UserDetails : Identifiable {

}
