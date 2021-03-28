//
//  NetworkHandler.swift
//  Github List
//
//  Created by Ryan Enguero on 3/27/21.
//

import UIKit

class NetworkHandler: NSObject {
let userUrlList = "https://api.github.com/users?since=0" as String?
let userDetails = "https://api.github.com/users/" as String?

func fetchUserList(completionHandler: @escaping ([UserList]) -> Void) {
    let url = URL(string: userUrlList!)!

    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
      if let error = error {
        print("Error with fetching films: \(error)")
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error with the response, unexpected status code: \(String(describing: response ?? nil))")
        return
      }
    
        if let data = data,

         let userlist = try? JSONDecoder().decode([UserList].self, from: data) {
        completionHandler(userlist)
      }
    })
    task.resume()
  }


func fetchUserDetails(username: String,completionHandler: @escaping (UserDetail) -> Void) {
    let url = URL(string: userDetails! + username as String)!

    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
      if let error = error {
        print("Error with fetching films: \(error)")
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        print("Error with the response, unexpected status code: \(String(describing: response ?? nil))")
        return
      }
    
        if let data = data,

         let userlist = try? JSONDecoder().decode(UserDetail.self, from: data) {
        completionHandler(userlist)
      }
    })
    task.resume()
  }

}
