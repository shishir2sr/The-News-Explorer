//
//  CustomError.swift
//  The News Explorer
//
//  Created by Yeasir Arefin Tusher on 14/1/23.
//

import Foundation

enum CustomError: Error {
    case invalidURL
    case invalidData
    case unableToComplete
    case invalidResponse
    case bookmarkExist
    case bookmarkFailed
    
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidData: return "Invalid Data"
        case .unableToComplete: return "Unable to complete your request. Internet may not be available"
        case .invalidResponse: return "Invalid api Response"
        case .bookmarkExist: return "Bokmark already exist!"
        case .bookmarkFailed: return "Item can't be added to the bookmark"
        }
    }
}
