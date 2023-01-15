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
    
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidData: return "Invalid Data"
        case .unableToComplete: return "Unable to complete your request"
        case .invalidResponse: return "Invalid Response"
        }
    }
}
