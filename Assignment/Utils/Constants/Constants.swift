//
//  Constants.swift
//  Assignment
//
//  Created by M.Shariq Hasnain on 31/05/2024.
//

import Foundation

public enum HTTPMethodTypes: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
    case patch   = "PATCH"
    
    func value() -> String{
        return self.rawValue
    }
}

public enum ErrorTypes: String {
    case TokenExpiry    = "token"
    case ServerError    = "internal server error"
}

let baseURL = "https://api.openweathermap.org/"

//MARK: HOME
let listingsURL = "\(baseURL)data/2.5/forecast"
