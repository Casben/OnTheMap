//
//  NetworkAuthenticationManager.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/20/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit
struct NetworkAuthenticationManager {
    static let shared = NetworkAuthenticationManager()
    
    func authenticateUser(withEmail email: String, password: String, completed: @escaping (ResposneData?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            completed(nil, error)
              return
          }
            guard let response = response else { return }
            guard let data = data else { return }
            let loginResponse = response as! HTTPURLResponse
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(ResposneData.self, from: newData)
                
                if loginResponse.statusCode == 200 {
                    completed(responseData, nil)
                } else {
                    completed(nil, error)
                }
            } catch {
                completed(nil, error)
            }
            
            
        }
        task.resume()
    }
    
    func retrieveUserInfo(withKey key: String, completed: @escaping (UserProfile?, Error?) -> Void) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(key)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            completed(nil, error)
              return
          }
            guard let data = data else { return }
            
          let range = 5..<data.count
          let newData = data.subdata(in: range)
            
            do {
                let decoder = JSONDecoder()
                let userInfo = try decoder.decode(UserProfile.self, from: newData)
                completed(userInfo, nil)
            } catch {
                completed(nil, error)
            }
            
        }
        task.resume()
    }
    
    func endSession(completed: @escaping (Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            completed(error)
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
}
