//
//  APIError.swift
//  UserInteractionSimulationProject
//
//  Created by Karin Prater on 03/05/2025.
//


import SwiftUI

extension EnvironmentValues {
    @Entry var service: FetcherService = DefaultFetcherService()
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case serverError(statusCode: Int)
    case productNotFound(id: Int)
    case mockDataNotFound(String)
}

protocol FetcherService {
    func fetchCategories() async throws -> [Category]
}

struct DefaultFetcherService: FetcherService {
  
    init() { }
    
    func fetchCategories() async throws -> [Category] {
        //should get this from server but API does not have endpoint
        return Category.allCases
    }
}

struct MockFetcherService: FetcherService {
    
    var error: APIError? = nil
    var delay: UInt64? = nil     // in nanoseconds
    
    var categories: [Category] = Category.allCases
    
    init() {
    }
    
    func fetchCategories() async throws -> [Category] {
        if let error { throw error }
        if let delay  {
            try await Task.sleep(nanoseconds: delay)
        }
        
        return categories
    }
}
