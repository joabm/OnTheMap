//
//  MapClient.swift
//  OnTheMap
//
//  Created by Joab Maldonado on 9/1/22.
//

import Foundation
import UIKit
import MapKit

class MapClient {
    
    struct Auth {
        
        //static var sessionKey = ""
        static var uniqueKey = ""
    
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case getStudentLocations
        
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            case .getStudentLocations: return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
    }
    
    
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, discardFive: Bool, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            //print(String(data: data, encoding: .utf8)!)
            var newData = data
            if discardFive {
                let range = 5..<data.count
                newData = newData.subdata(in: range)
            }
            //print(String(data: newData, encoding: .utf8)!)
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    @discardableResult class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, discardFive: Bool, response: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
                return
            }
            var newData = data
            if discardFive {
                let range = 5..<data.count
                newData = newData.subdata(in: range)
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: ["username": "\(username)", "password": "\(password)"])
        taskForPOSTRequest(url: Endpoints.login.url, discardFive: true, response: LoginResponse.self, body: body) {
            (response, error) in
            if let response = response {
                Auth.uniqueKey = response.account.key
                completion(response.account.registered, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.login.url) //same url as login
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            Auth.uniqueKey = ""
            DispatchQueue.main.async {
                completion()
            }        }
        task.resume()
    }
    
    class func getStudentLocations(completion: @escaping ([StudentData], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocations.url, discardFive: false, response: StudentLocationResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
        
    }
    
}
