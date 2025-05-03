//
//  Category.swift
//  UserInteractionSimulationProject
//
//  Created by Karin Prater on 03/05/2025.
//


import Foundation

enum Category: String, CaseIterable, Identifiable {
    case electronics
    case jewellery = "jewelery"
    case menCloth = "men's clothing"
    case womenCloth = "women's clothing"
    
    var title: String {
        switch self {
            case .electronics: return "Electronics"
            case .jewellery: return "Jewellery"
            case .menCloth: return "Men's Clothing"
            case .womenCloth: return "Women's Clothing"
        }
    }
    
    var icon: String {
        
        switch self {
            case .electronics:
                "laptopcomputer"
            case .jewellery:
                "pencil.and.ruler"
            case .menCloth:
                "tshirt"
            case .womenCloth:
                "figure.stand.dress"
        }
    }
    
    var id: Self { return self }
}
