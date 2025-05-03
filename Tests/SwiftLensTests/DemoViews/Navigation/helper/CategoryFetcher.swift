//
//  CategoryFetcher.swift
//  UserInteractionSimulationProject
//
//  Created by Karin Prater on 03/05/2025.
//

import Foundation

class CategoryFetcher: ObservableObject {
    
    enum State: Equatable {
        case idle
        case loading
        case error(String)
        
        var description: String {
            switch self {
                case .idle: "idle"
                case .loading: "loading"
                case .error(_): "error"
            }
        }
    }
    
    @Published var state: State = .idle
    @Published var categories = [Category]() //  Category.allCases //
    
    private let service: FetcherService

    init(service: FetcherService = DefaultFetcherService()) {
        self.service = service
    }
    
    @MainActor
    func loadCategories() async {
        guard categories.count == 0 else {
            return
        }
    
        state = .loading
        
        do {
            self.categories = try await service.fetchCategories()
            self.state = .idle
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
    
}
