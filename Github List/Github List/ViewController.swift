//
//  ViewController.swift
//  Github List
//
//  Created by Ryan Enguero on 3/26/21.
//

import UIKit
import CoreData
import Foundation
import Network

class ViewController: UIViewController, UITextViewDelegate {

@IBOutlet weak var avatarDetailImg: UIImageView!
@IBOutlet weak var lblFollowers: UILabel!
@IBOutlet weak var txtDetails: UITextView!
@IBOutlet weak var txtNotes: UITextView!

var isInverted : Bool = false
    var isSearchActive: Bool = false

let monitor = NWPathMonitor()

//    var userDetails = UserListDB()
private var details: UserDetail?
private var userDetails: [UserDetails]?
@IBOutlet weak var lblFollowing: UILabel!

override func viewDidLoad() {
    super.viewDidLoad()
    
    overrideUserInterfaceStyle = .dark
    
    self.txtNotes.layer.borderWidth = 2
    self.txtNotes.layer.borderColor = UIColor.white.cgColor
    self.txtDetails.layer.borderWidth = 2
    self.txtDetails.layer.borderColor = UIColor.white.cgColor

}

func userDetails(userDetails: UserListDB) {
    print("userdetails: \(userDetails)")
    
    monitor.pathUpdateHandler = { path in
        if path.status == .satisfied {
            print("We're connected!")
            
            NetworkHandler().fetchUserDetails(username: userDetails.login!) { [weak self] (details) in
                self?.details = details
                DispatchQueue.main.async {
                  print(self?.details as Any)
                    CoreDataHandler().saveUpdateUserDetails(userDetails: (self?.details)!)
                self!.fetchDetails(userList: userDetails)
                    
                }
            }
            
        } else {
            print("No connection.")
            DispatchQueue.main.async {
                self.fetchDetails(userList: userDetails)
            }
            
        }

        print(path.isExpensive)
    }
    
    let queue = DispatchQueue(label: "Monitor")
    monitor.start(queue: queue)
    
}

func fetchDetails(userList: UserListDB)  {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<UserDetails> = UserDetails.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id = %i", userList.id)
    

    do {
        userDetails = try managedContext.fetch(fetchRequest)
        if userDetails!.count > 0 {
            self.reloadView(userDetails: userDetails![0], userListDB: userList)
        }
        
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
}

func fetchNote(userID: Int)  {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id = %i", userID)
    

    do {
        let notes = try managedContext.fetch(fetchRequest)
        if notes.count > 0 {
            self.txtNotes.text = notes.last!.note
        }
        
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
}


func reloadView(userDetails: UserDetails,userListDB: UserListDB) {
    self.navigationItem.title = userDetails.name
    
    if isInverted == true {
        self.avatarDetailImg.downloadedInverted(from: userListDB.avatar_url!)
    }else{
        self.avatarDetailImg.downloaded(from: userListDB.avatar_url!)
    }
    
    self.lblFollowers.text = "followers: \(userDetails.followers)"
    self.lblFollowing.text = "following: \(userDetails.following)"
    self.txtDetails.text = "name: \(userDetails.name ?? "")\n\ncompany: \(userDetails.company ?? "")\n\nblog: \(userDetails.blog ?? "")\n\nbio: \(userDetails.bio ?? "")"
    self.fetchNote(userID: Int(userDetails.id))
}

@IBAction func saveNote(_ sender: Any) {
    print("Save Note")
    
    CoreDataHandler().saveNotes(userID: Int(self.details!.id), note: self.txtNotes.text)
    if isSearchActive == false{
        NotificationCenter.default.post(name: .updateList, object: "", userInfo: nil)
    }
    
    // Create the alert controller
        let alertController = UIAlertController(title: "Note", message: "Saving successful", preferredStyle: .alert)

        // Create the actions
    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        
        }
        // Add the actions
        alertController.addAction(okAction)

        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    
}


func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       if(text == "\n") {
           textView.resignFirstResponder()
           return false
       }
       return true
   }
}

