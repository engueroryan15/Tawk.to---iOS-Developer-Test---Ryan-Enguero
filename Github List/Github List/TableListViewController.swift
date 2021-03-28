//
//  TableListViewController.swift
//  Github List
//
//  Created by Ryan Enguero on 3/26/21.
//

import Foundation
import UIKit
import CoreData
import Network

class TableListViewController: UITableViewController, UISearchBarDelegate {

@IBOutlet weak var searchBar: UISearchBar!

var searchActive : Bool = false

var filtered:[UserListDB] = []
private var users: [UserList]?
var userList: [UserListDB] = []

let monitor = NWPathMonitor()

override func viewDidLoad() {
super.viewDidLoad()

/* Dark Mode*/
self.navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
overrideUserInterfaceStyle = .dark

/*Connection Checker*/
monitor.pathUpdateHandler = { path in
    if path.status == .satisfied {
        print("We're connected!")
        /* Network Handler for getting Userlist, saving to Coredata, fetching and reloading table*/
        NetworkHandler().fetchUserList { [weak self] (users) in
          self?.users = users
          DispatchQueue.main.async {
            print(self?.users as Any)
              CoreDataHandler().saveUpdateUserDataList(userList: (self?.users)!)
              self!.fetchDataAndReload()
            self?.tableView.reloadData()
            self?.navigationItem.title = ""
          }
        }
        
    } else {
        print("No connection.")
        DispatchQueue.main.async {
        self.fetchDataAndReload()
        self.tableView.reloadData()
        self.navigationItem.title = "No internet Connection"
        }
    }
    print(path.isExpensive)
}

let queue = DispatchQueue(label: "Monitor")
monitor.start(queue: queue)

self.searchBar.delegate = self.tableView.delegate as? UISearchBarDelegate

/*Obeserver for note changes - It will reload the table when note has changes*/
NotificationCenter.default.addObserver(self, selector: #selector(updateList), name: .updateList, object: nil)
}

/*Observer function reload data from Coredata*/
@objc func updateList(notification: Notification) {
DispatchQueue.main.async {
    self.fetchDataAndReload()
    self.tableView.reloadData()
}
}

/* Fetch data from DB*/
func fetchDataAndReload()  {
guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
  return
}

let managedContext = appDelegate.persistentContainer.viewContext
let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserListDB")


do {
  userList = try managedContext.fetch(fetchRequest) as! [UserListDB]
    
} catch let error as NSError {
  print("Could not fetch. \(error), \(error.userInfo)")
}
}

/* TableView Delegate*/
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
if(searchActive) {
    return filtered.count
}
return self.userList.count
}


override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

let cell : NormalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
let cellNote : NoteTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell") as! NoteTableViewCell
let cellInverted : InvertedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InvertedTableViewCell") as! InvertedTableViewCell

cell.avatarImg.layer.cornerRadius = cell.avatarImg.frame.width/2.0
cell.avatarImg.clipsToBounds = true

cellNote.avatarImg.layer.cornerRadius = cellNote.avatarImg.frame.width/2.0
cellNote.avatarImg.clipsToBounds = true

cellInverted.avatarImg.layer.cornerRadius = cellInverted.avatarImg.frame.width/2.0
cellInverted.avatarImg.clipsToBounds = true

if(searchActive) {
    
    let note = fetchNote(userID: Int(filtered[indexPath.row].id))
    if note.count > 0 {
        
        cellNote.lblUsername?.text = filtered[indexPath.row].login
        cellNote.detailsTxtView.text = filtered[indexPath.row].type
      
      if filtered[indexPath.row].avatar_url != nil{
        cellNote.avatarImg.downloaded(from: filtered[indexPath.row].avatar_url!)
      }
        return cellNote
        
    }else{
    
      cell.lblUsername?.text = filtered[indexPath.row].login
      cell.detailsTxtView.text = filtered[indexPath.row].type
    
    if filtered[indexPath.row].avatar_url != nil{
        cell.avatarImg.downloaded(from: filtered[indexPath.row].avatar_url!)
    }
        return cell
    }
    
}else{
   
    let note = fetchNote(userID: Int(self.userList[indexPath.row].id))
    if note.count > 0 {
        cellNote.lblUsername?.text = self.userList[indexPath.row].login
        cellNote.detailsTxtView.text = self.userList[indexPath.row].type
        
        if self.userList[indexPath.row].avatar_url != nil{
            if indexPath.row == 0{
                cellNote.avatarImg.downloaded(from: self.userList[indexPath.row].avatar_url!)
            }else if indexPath.row % 3 == 0{
                cellNote.avatarImg.downloadedInverted(from: self.userList[indexPath.row].avatar_url!)
            }else{
            cellNote.avatarImg.downloaded(from: self.userList[indexPath.row].avatar_url!)
            }
        }
        return cellNote
//                }
    }else if indexPath.row % 3 == 0{
        
        cellInverted.lblUsername?.text = self.userList[indexPath.row].login
        cellInverted.detailsTxtView.text = self.userList[indexPath.row].type
        
        if self.userList[indexPath.row].avatar_url != nil{
            cellInverted.avatarImg.downloadedInverted(from: self.userList[indexPath.row].avatar_url!)
        }
        return cellInverted
    }else{
        
    cell.lblUsername?.text = self.userList[indexPath.row].login
    cell.detailsTxtView.text = self.userList[indexPath.row].type
    
    if self.userList[indexPath.row].avatar_url != nil{
        cell.avatarImg.downloaded(from: self.userList[indexPath.row].avatar_url!)
    }
    }
    
    return cell
}

}

/* method to run when table view cell is tapped */
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

self.navigationItem.title = ""

let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController

if(searchActive) {
    next.userDetails(userDetails: filtered[indexPath.row])
    next.isSearchActive = true
}else{
    if indexPath.row == 0{
        next.isInverted = false
    }else if indexPath.row % 3 == 0 {
        next.isInverted = true
    }else{
        next.isInverted = false
    }
    next.userDetails(userDetails: self.userList[indexPath.row])
    next.isSearchActive = false
}
self.navigationController?.pushViewController(next, animated: true)
}

override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
return 106
}

/* Search Bar Delegate */

func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchActive = true;
}

func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchActive = false;
self.searchBar.endEditing(true)
}

func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false;
self.searchBar.endEditing(true)
}

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false;
self.searchBar.endEditing(true)
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

filtered = self.userList.filter({ (text) -> Bool in
    let tmp: NSString = NSString(string: "\(String(describing: text.login))")
    let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
        return range.location != NSNotFound
    })
    if(filtered.count == 0){
        if searchText.isEmpty == true {
            searchActive = false;
        }else{
            searchActive = true;
        }
        
    } else {
        searchActive = true;
    }
    self.tableView.reloadData()
}

func fetchNote(userID: Int) -> String {
let appDelegate = UIApplication.shared.delegate as? AppDelegate

let managedContext = appDelegate!.persistentContainer.viewContext

let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest() // this provided by XCode code generation
fetchRequest.predicate = NSPredicate(format: "id = %i", userID)

var note = String()

do {
    let notes = try managedContext.fetch(fetchRequest)
    if notes.count > 0 {
//                self.reloadView(userDetails: userDetails![0], userListDB: userList)
        note = notes.last!.note!
        
    }
    
} catch let error as NSError {
  print("Could not fetch. \(error), \(error.userInfo)")
}

return note
}



}

extension UIImageView {

func maskCircle(anyImage: UIImage) {
self.contentMode = UIView.ContentMode.scaleAspectFill
self.layer.cornerRadius = self.frame.height / 2
self.layer.masksToBounds = false
self.clipsToBounds = true

// make square(* must to make circle),
// resize(reduce the kilobyte) and
// fix rotation.
self.image = anyImage
}

func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
contentMode = mode
URLSession.shared.dataTask(with: url) { data, response, error in
    guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data)
        else { return }
    DispatchQueue.main.async() { [weak self] in
        self?.image = image
    }
}.resume()
}
func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
guard let url = URL(string: link) else { return }
downloaded(from: url, contentMode: mode)
}


func downloadedInverted(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
contentMode = mode
URLSession.shared.dataTask(with: url) { data, response, error in
    guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data)
        else { return }
    DispatchQueue.main.async() { [weak self] in
       
        
        let beginImage = CIImage(image: image)
            if let filter = CIFilter(name: "CIColorInvert") {
                filter.setValue(beginImage, forKey: kCIInputImageKey)
                 let newImage = UIImage(ciImage: filter.outputImage!)
                self?.image = newImage
            }
    }
}.resume()
}
func downloadedInverted(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
guard let url = URL(string: link) else { return }
downloadedInverted(from: url, contentMode: mode)
}


}

extension Notification.Name {
static let updateList = Notification.Name("updateList")
}

