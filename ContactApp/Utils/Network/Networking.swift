//
//  Networking.swift
//  Contact
//
//  Created by Tity Septiani on 7/15/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation

class Networking {
    private var baseURL:String
    typealias NetworkingCompletion = (CTResponse) -> Void
    
    init(baseURL:String) {
        self.baseURL = baseURL
    }
    
    func get(pathURL:String,parameters:[String:Any]? = nil, completion: @escaping NetworkingCompletion) {
        requestWithMethod(pathURL:pathURL, method: "GET", completion: completion)
    }
    
    func post(pathURL:String,parameters:[String:Any]? = nil, completion: @escaping NetworkingCompletion) {
        requestWithMethod(pathURL:pathURL, method: "POST", bodyParameters:parameters, completion: completion)
    }
    
    func put(pathURL:String,parameters:[String:Any]? = nil, completion: @escaping NetworkingCompletion) {
        requestWithMethod(pathURL:pathURL, method: "PUT", bodyParameters:parameters, completion: completion)
    }
    
    func delete(pathURL:String,parameters:[String:Any]? = nil, completion: @escaping NetworkingCompletion) {
        requestWithMethod(pathURL:pathURL, method: "DELETE", completion: completion)
    }
    
    private func requestWithMethod(pathURL:String, method:String, queryParameters:[String:String]? = nil, bodyParameters:[String:Any]? = nil, completion: @escaping NetworkingCompletion) {
        if let request = URLRequest.requestWithURL(URL(string: pathURL, relativeTo: URL(string: baseURL))!,method: method,queryParameters: queryParameters, bodyParameters: bodyParameters, headers: nil) {
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                var err = error
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                        let desc = "HTTP Response: \(httpResponse.statusCode)"
                        err = NSError(domain: "Custom", code: 0, userInfo: [NSLocalizedDescriptionKey: desc])
                    }
                }
                
                let customResponse = CTResponse(data: data, response: response, error: err)
                completion(customResponse)
            }
            task.resume()
        }
    }
}

extension URLRequest {
    static func requestWithURL(_ url:URL, method:String, queryParameters:[String:String]?, bodyParameters:[String:Any]?, headers:[String:String]?) -> URLRequest? {
        var theURL:URL
        if let queryParameters = queryParameters {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = queryParameters.map({ (key,value) in
                URLQueryItem(name: key, value: value)
            })
            
            theURL = (components?.url)!
        } else {
            theURL = url
        }
        
        //        URLRequest
        var request = URLRequest(url: theURL)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let bodyParameters = bodyParameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            }
            catch let requestError {
                print(requestError)
            }
        }
        
        if let headers = headers {
            for (field,value) in headers {
                request.addValue(value, forHTTPHeaderField: field)
            }
        }
        
        return request
    }
}

struct CTResponse {
    let data: Data?
    let response: URLResponse?
    var error: Error?
    
    
    var HTTPResponse: URLResponse? {
        return response
    }
    
    var responseJSON: Any? {
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                return json
            }
            catch let err {
                print(err)
            }
        }
        
        return nil
    }
}
