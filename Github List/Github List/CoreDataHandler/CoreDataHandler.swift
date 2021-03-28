//
//  CoreDataHandler.swift
//  Github List
//
//  Created by Ryan Enguero on 3/27/21.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {

func saveUpdateUserDataList(userList: [UserList]) {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    for user in userList {

        let managedContext = appDelegate.persistentContainer.viewContext
    
        let fetchRequest: NSFetchRequest<UserListDB> = UserListDB.fetchRequest() // this provided by XCode code generation
        fetchRequest.predicate = NSPredicate(format: "id = %i", user.id)
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            if test.count < 1  {
                
   
    let entity = NSEntityDescription.entity(forEntityName: "UserListDB", in: managedContext)!
    let userListDB = NSManagedObject(entity: entity, insertInto: managedContext) as! UserListDB
            
                userListDB.login = user.login
                userListDB.id = Int16(user.id)
                userListDB.node_id = user.node_id
                userListDB.avatar_url = user.avatar_url
                userListDB.gravatar_id = user.gravatar_id
                userListDB.url = user.url
                userListDB.html_url = user.html_url
                userListDB.followers_url = user.followers_url
                userListDB.following_url = user.following_url
                userListDB.gists_url = user.gists_url
                userListDB.starred_url = user.starred_url
                userListDB.subscriptions_url = user.subscriptions_url
                userListDB.organizations_url = user.organizations_url
                userListDB.repos_url = user.repos_url
                userListDB.events_url = user.events_url
                userListDB.received_events_url = user.received_events_url
                userListDB.type = user.type
                userListDB.site_admin = user.site_admin
                
                do {
                  try managedContext.save()
                } catch let error as NSError {
                  print("Could not save. \(error), \(error.userInfo)")
                }
                
            }
          } catch {
            print(error)
          }
        
        
        
    }
    

   
}


func saveUpdateUserDetails(userDetails: UserDetail) {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

        let managedContext = appDelegate.persistentContainer.viewContext
    
        let fetchRequest: NSFetchRequest<UserDetails> = UserDetails.fetchRequest() // this provided by XCode code generation
        fetchRequest.predicate = NSPredicate(format: "id = %i", userDetails.id)
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            if test.count < 1  {
                
   
    let entity = NSEntityDescription.entity(forEntityName: "UserDetails", in: managedContext)!
    let userDetailsDB = NSManagedObject(entity: entity, insertInto: managedContext) as! UserDetails
            
                userDetailsDB.bio = userDetails.bio
                userDetailsDB.blog = userDetails.blog
                userDetailsDB.company = userDetails.company
                userDetailsDB.created_at = userDetails.created_at
                userDetailsDB.email = userDetails.email
                userDetailsDB.followers = userDetails.followers
                userDetailsDB.following = userDetails.following
                userDetailsDB.hireable = userDetails.hireable
                userDetailsDB.id = userDetails.id
                userDetailsDB.location = userDetails.location
                userDetailsDB.name = userDetails.name
                userDetailsDB.public_gists = userDetails.public_gists
                userDetailsDB.public_repos = userDetails.public_repos
                userDetailsDB.twitter_username = userDetails.twitter_username
                userDetailsDB.updated_at = userDetails.updated_at
                
                do {
                  try managedContext.save()
                } catch let error as NSError {
                  print("Could not save. \(error), \(error.userInfo)")
                }
                
            }
          } catch {
            print(error)
          }
        
        
        
    }


func saveNotes(userID: Int, note: String) {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
        let managedContext = appDelegate.persistentContainer.viewContext
   
    let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
    let notesDB = NSManagedObject(entity: entity, insertInto: managedContext) as! Note
            
                notesDB.id = Int16(userID)
                notesDB.note = note
               
                
                do {
                  try managedContext.save()
                } catch let error as NSError {
                  print("Could not save. \(error), \(error.userInfo)")
                }
    }
}
