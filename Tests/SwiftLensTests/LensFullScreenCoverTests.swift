//
//  Test.swift
//  SwiftLens
//
//  Created by Karin Prater on 26/05/2025.
//

import Foundation
import Testing
@testable import SwiftLens
@testable import SwiftLensTestSupport

struct LensFullScreenCoverTests {

    @Suite("FullScreenCover with Boolean Toggle")
    struct DemoFullScreenCoverBooleanTests {
        
        @MainActor
        @Test("Open fullScreenCover")
        func open_fullScreenCover() async throws {
            // —— SYSTEM  ——
            let sut = LensWorkBench { sut in
                DemoFullScreenCoverView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowPresentationButton")
            
            // ---- WHEN ----
            sut.interactor.tapButton(withID: "ShowPresentationButton")
            
            // ---- THEN  ----
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            try await sut.observer.waitForViewVisible(withID: "fullscreencover.content.group")
        }
        
        @MainActor
        @Test("Open and Close fullScreenCover")
        func open_and_close_fullScreenCover() async throws {
            // —— SYSTEM  ——
            let sut = LensWorkBench { sut in
                DemoFullScreenCoverView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowPresentationButton")
            // open sheet:
            sut.interactor.tapButton(withID: "ShowPresentationButton")
            try await sut.observer.waitForViewVisible(withID: "CloseSheetButton")
            
            // ---- WHEN ----
            sut.interactor.tapButton(withID: "CloseSheetButton")
            
            // ---- THEN  ----
            // wait for sheet to disappear:
            try await sut.observer.waitForViewHidden(withID: "fullscreencover.content.group")
            
            #expect(sut.observer.containsNotView(withID: "FavoriteText"), "text inside sheet should not be shown")
            #expect(sut.observer.containsNotView(withID: "CloseSheetButton"), "button inside sheet should not be shown")
            #expect(sut.observer.containsNotView(withID: "FavoriteButton"),"button inside sheet should not be shown")
        }
    }
    
    
    @Suite("FullScreenCover with Item Toggle")
    struct DemoFullScreenCoverItemTests {
        
        @MainActor
        @Test("Open fullScreenCover")
        func open_fullScreenCover() async throws {
            // —— SYSTEM  ——
            let sut = LensWorkBench { sut in
                DemoFullScreenCoverItemView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowPresentationButton")
            
            // ---- WHEN ----
            sut.interactor.tapButton(withID: "ShowPresentationButton")
            
            // ---- THEN  ----
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            try await sut.observer.waitForViewVisible(withID: "fullscreencover.content.group")
        }
        
        @MainActor
        @Test("Open and Close fullScreenCover")
        func open_and_close_fullScreenCover() async throws {
            // —— SYSTEM  ——
            let sut = LensWorkBench { sut in
                DemoFullScreenCoverItemView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowPresentationButton")
            // open sheet:
            sut.interactor.tapButton(withID: "ShowPresentationButton")
            try await sut.observer.waitForViewVisible(withID: "fullscreencover.content.group")
            
            // ---- WHEN ----
            sut.interactor.tapButton(withID: "CloseSheetButton")
            
            // ---- THEN  ----
            // wait for sheet to disappear:
            try await sut.observer.waitForViewHidden(withID: "fullscreencover.content.group")
            
            #expect(sut.observer.containsNotView(withID: "FavoriteText"), "text inside sheet should not be shown")
            #expect(sut.observer.containsNotView(withID: "CloseSheetButton"), "button inside sheet should not be shown")
            #expect(sut.observer.containsNotView(withID: "FavoriteButton"),"button inside sheet should not be shown")
        }
    }
}
