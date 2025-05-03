//
//  Test.swift
//  SwiftLens
//
//  Created by Karin Prater on 03/05/2025.
//

import Foundation
import Testing
@testable import SwiftLens
@testable import SwiftLensTestSupport
import SwiftUI

struct NavigationListTests {

    @available(iOS 16.0, *)
    @MainActor
    @Test func testListView_when_appear_load_categories_into_list() async throws {
        // ---- SYSTEM ----
        let service = MockFetcherService()
        let fetcher = CategoryFetcher(service: service)
        
        let sut = UIUnderTest { sut in
            DemoListView(fetcher: fetcher,
                         containerStyle: .list,
                         rowContentStyle: .navigationlink)
        }
        
        // ---- WHEN ----
        
        
        // ---- THEN ----
       // try await Task.sleep(nanoseconds: 1000_000_000)
        try await sut.observer.waitForViewCount(
            withViewIDPrefix: "link.category.",
            expected: service.categories.count
        )
        for category in service.categories {
            #expect(sut.observer.containsView(
                withID: "link.category.\(category.id)"
            ))
        }
    }
    
    @available(iOS 16.0, *)
    @MainActor
    @Test func testListView_in_navigationstack_when_appear_load_categories_into_list() async throws {
        // ---- SYSTEM ----
        let service = MockFetcherService()
        let fetcher = CategoryFetcher(service: service)
        
        let sut = UIUnderTest { sut in
            DemoNavigationView(fetcher: fetcher,
                                  containerStyle: .list,
                                  rowContentStyle: .navigationlink)
        }
        
        // ---- WHEN ----
        
        
        // ---- THEN ----
       // try await Task.sleep(nanoseconds: 1000_000_000)
        try await sut.observer.waitForViewCount(
            withViewIDPrefix: "link.category.",
            expected: service.categories.count
        )
        
        for category in service.categories {
            #expect(sut.observer.containsView(
                withID: "link.category.\(category.id)"
            ))
        }
    }
    
    
    @available(iOS 16.0, *)
    @MainActor
    @Test func testListView_in_tabview_in_navigationstack_when_appear_load_categories_into_list() async throws {
        // ---- SYSTEM ----
        let service = MockFetcherService()
        let fetcher = CategoryFetcher(service: service)
        
        let sut = UIUnderTest { sut in
            TabView {
                DemoNavigationView(fetcher: fetcher,
                                      containerStyle: .list,
                                      rowContentStyle: .navigationlink)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                
                Text("SearchTabView")
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
                
                Text("SettingsTabView")
                    .tabItem { Label("Settings", systemImage: "gear") }
                
            }
        }
        
        // ---- WHEN ----
        
        
        // ---- THEN ----
       // try await Task.sleep(nanoseconds: 1000_000_000)
        try await sut.observer.waitForViewCount(
            withViewIDPrefix: "link.category.",
            expected: service.categories.count
        )
        
        for category in service.categories {
            #expect(sut.observer.containsView(
                withID: "link.category.\(category.id)"
            ))
        }
    }
    
    /*
    @available(iOS 16.0, *)
    @MainActor
    @Test func testListView_in_navigationstack_when_press_category_link_then_show_detail() async throws {
        // ---- SYSTEM ----
        let service = MockFetcherService()
        let fetcher = CategoryFetcher(service: service)
        
        let sut = UIUnderTest { sut in
            DemoNavigationView(fetcher: fetcher,
                                  containerStyle: .scrollview,  // ❌ does not work for: list, form
                                  rowContentStyle: .navigationlink)
        }
        
        guard let targetCategory = service.categories.first else {
            #expect(Bool(false), "No Category found")
            return
        }
        
        let buttonID = "link.category.electronics"//"link.category.\(targetCategory.id)"
        try await sut.observer.waitForViewVisible(withID: buttonID)
       
        // ---- WHEN ----
       
        // works for: scrollview, lazyvstack inside scrollview, vstack
        // ❌ does not: list, form
        // not able to navigate to detail with button press simulation
        // -> custom button style with onReceive is not working
        sut.simulator.buttonTap(withID: buttonID)
        
        // ---- THEN: detail is shown ----
        try await sut.observer.waitForViewVisible(withID: "detail.category.\(targetCategory.id)")
    }
     */

}
