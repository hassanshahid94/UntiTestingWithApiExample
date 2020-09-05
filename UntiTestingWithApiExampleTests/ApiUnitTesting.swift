//
//  ApiUnitTesting.swift
//  UntiTestingWithApiExampleTests
//
//  Created by Hassan on 9/5/20.
//  Copyright © 2020 Hassan. All rights reserved.
//

import XCTest
@testable import UntiTestingWithApiExample

class ApiUnitTesting: XCTestCase {
    
    func testLoginSuccess() {
        
        let data = readData(fileName: "example")
        let expected = LoginResponseTest(fromDictionary: data as! [String: Any])
        let expectatio = expectation(description: "POST \(Constants.baseURL)\(APIEndpoints.login.rawValue)")

        ServerManager.login(email: "abc@gmail.com", password: "password") { (status, data) in

            XCTAssertEqual(data?.success!, expected.success!)
            expectatio.fulfill()
        }
        self.waitForExpectations(timeout: 5) { (error) in
            print ("\(error?.localizedDescription)")
        }
    }
    
    
    //Reading Json File response
    func readData(fileName: String) -> AnyObject? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json")
        {
            do
            {let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    return jsonResult as AnyObject
                }
            } catch {
                // handle error
            }
        }
        return nil
        
    }
    
}


