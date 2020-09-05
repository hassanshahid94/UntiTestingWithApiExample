//
//  ServerManager.swift
//  UntiTestingWithApiExample
//
//  Created by Hassan on 9/5/20.
//  Copyright © 2020 Hassan. All rights reserved.
//

import Foundation
import Alamofire

class ServerManager {
    
    public static func login(email: String, password: String, completion: @escaping (String, LoginResponseTest?) -> Void)
    {
        let urlString = "\(Constants.baseURL)\(APIEndpoints.login.rawValue)"
        guard let url = URL(string: urlString) else {return}
        var request        = URLRequest(url: url)
        request.httpMethod = "POST"
        let params:Parameters = ["email": email, "password": password]
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody   = try JSONSerialization.data(withJSONObject: params)
        } catch let error {
            print("Error : \(error.localizedDescription)")
        }
        Alamofire.request(request).responseJSON{ (response) in

            if let status = response.response?.statusCode {
                switch(status){
                    
                case 200: //success
                    //to get JSON return value
                    if let result = response.result.value {
                        let jdict = result as! NSDictionary
                        
                        let data = LoginResponseTest(fromDictionary: jdict as! [String: Any])
                        
                        completion("success", data)
                        
                    }
                case 400:  // query is missing
                    
                    completion("Query is missing.", nil)
                    
                case -1009:
                    
                    completion("The Internet connection appears to be offline.", nil)
                    
                default:
                    completion("Something went wrong. Please try again.", nil)
                }
            } else {
                completion((response.error?.localizedDescription)!, nil)
            }
        }
    }
}

enum APIEndpoints: String
{
    //Rest API URL
    case login             = "v1/user/login"
}
