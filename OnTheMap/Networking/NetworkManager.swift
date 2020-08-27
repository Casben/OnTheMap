//
//  NetworkManager.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/18/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import Foundation

struct NetworkManager {
    static let shared = NetworkManager()
    
    func getStudentLocations(completed: @escaping (StudentLocationList?, Error?) -> Void) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completed(nil, error)
                return
            }
            
            guard let data = data else {return}
            
            do {
                let deocder = JSONDecoder()
                let locations = try deocder.decode(StudentLocationList.self, from: data)
                completed(locations, nil)
            } catch {
                completed(nil, error)
            }
        }
        task.resume()
        
    }
    
    func sendStudentLocation(with student: StudentInformation, completed: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(TabBarVC.studentKey!)\", \"firstName\": \"\(student.firstName!)\", \"lastName\": \"\(student.lastName!)\",\"mapString\": \"\(student.mapString!)\", \"mediaURL\": \"\(student.mediaURL!)\",\"latitude\": \(student.latitude!), \"longitude\": \(student.longitude!)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            completed(false, error)
              return
          }
            guard let data = data else {return}
            completed(true, nil)
        
            print("data from POST method:")
          print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
}
