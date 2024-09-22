//
//  NetworkLogger.swift
//  Assignment
//
//  Created by M.Shariq Hasnain on 31/05/2024.
//

import Foundation
import Alamofire

class NetworkLogger {

    static func log(url: String, type: HTTPMethod, param :[String : Any]? = nil, header: [String : String]? = nil) {
        #if DEBUG
        print("\n----- Request -----")
        defer { print("\n----- End Request -----\n") }
        print("URL: \(url)")
        print("Method: \(type.rawValue)")
        if let headers = header {
            print("Headers: \(headers)")
        }
        if let body = param {
            print("Body: \(body)")
        }
        #endif
    }

    static func log(response: DefaultDataResponse?, data: Data?) {
        #if DEBUG
        print("\n----- Response -----")
        defer { print("\n----- End Response -----\n") }
        if let response = response {
            print("Status Code: \(response.response?.statusCode ?? 000)")
            if let headers = response.response?.allHeaderFields as? [String: Any] {
                print("Headers: \(headers)")
            }
        }
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("Response Data: \(responseString)")
        }
        #endif
    }
}

