import Foundation
import Testing
@testable import SwiftLens
@testable import SwiftLensTestSupport

struct PresentationViewTests {

    @Suite("Sheets with Boolean Toggle")
    struct DemoSheetBooleanTests {
        @MainActor
        @Test("Open when sheet position outside VStack")
        func sheetDemoView_when_button_pressed_then_open_sheet() async throws {
            // —— SYSTEM ——
            let sut = LensWorkBench { sut in
                DemoSheetBooleanView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            
            // ---- WHEN ----
            sut.interactor.tapButton(withID: "ShowDetailsButton")
            
            // ---- THEN  ----
            try await sut.observer.waitForViewVisible(withID: "sheet.content.group")
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            
            let sheetContent = sut.observer.view(withID: "sheet.content.group")
            
           // sut.observer.printValues()
            
            #expect(sheetContent?.children.findView(withID: "FavoriteButton") != nil,
                    "should see favorite button that is inside the sheet content")
            
        }

        @MainActor
        @Test("Open when sheet position at button level")
        func sheetDemoView_Two_when_ShowDetailsButton_then_open_sheet() async throws {
            // —— SYSTEM SETUP ——
            let sut = LensWorkBench { sut in
                DemoSheetTwoView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            
            // ---- WHEN ----
            sut.interactor.tapButton(withID: "ShowDetailsButton")
            
            // ---- THEN  ----
            try await sut.observer.waitForViewVisible(withID: "sheet.content.group")
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            
            let sheetContent = sut.observer.view(withID: "sheet.content.group")
            
           // sut.observer.printValues()
            
            #expect(sheetContent?.children.findView(withID: "FavoriteButton") != nil,
                    "should see favorite button that is inside the sheet content")
        }
        
        @MainActor
        @Test("Open when sheet position at untracked view")
        func sheetDemoView_Three_when_ShowDetailsButton_then_open_sheet() async throws {
            // —— SYSTEM SETUP ——
            let sut = LensWorkBench { sut in
                DemoSheetThreeView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            
            // ---- WHEN ----
            sut.interactor.tapButton(withID: "ShowDetailsButton")
            
            // ---- THEN  ----
            try await sut.observer.waitForViewVisible(withID: "sheet.content.group")
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            
            let sheetContent = sut.observer.view(withID: "sheet.content.group")
            
           // sut.observer.printValues()
            
            #expect(sheetContent?.children.findView(withID: "FavoriteButton") != nil,
                    "should see favorite button that is inside the sheet content")
        }
        
        @MainActor
        @Test("Open and Close sheet")
        func open_and_close_sheet() async throws {
            // —— SYSTEM ——
            let sut = LensWorkBench { sut in
                DemoSheetBooleanView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            sut.interactor.tapButton(withID: "ShowDetailsButton")
            // wait for sheet open:
            try await sut.observer.waitForViewVisible(withID: "sheet.content.group")
            try await sut.observer.waitForViewVisible(withID: "CloseSheetButton")
            
            // ---- WHEN ----
            sut.interactor.tapButton(withID: "CloseSheetButton")
            
            // ---- THEN  ----
            try await sut.observer.waitForViewHidden(withID:  "sheet.content.group")
            
            #expect(sut.observer.containsNotView(withID: "FavoriteText"), "text inside sheet should not be shown")
            #expect(sut.observer.containsNotView(withID: "CloseSheetButton"), "button inside sheet should not be shown")
            #expect(sut.observer.containsNotView(withID: "FavoriteButton"),"button inside sheet should not be shown")
        }
    }
    
    //DemoSheetItemView
    
    @Suite("Sheet with Item Toggle")
    struct DemoSheetItemTests {
        @MainActor
        @Test("Open when sheet position outside VStack")
        func sheetDemoItemView_when_ShowDetailsButton_then_open_sheet() async throws {
            // —— SYSTEM SETUP ——
            let sut = LensWorkBench { sut in
                DemoSheetItemView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            
            sut.observer.printValues()
            
            // —— SHOW SHEET ——
            sut.interactor.tapButton(withID: "ShowDetailsButton")
            
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            
            // —— ACTION: close the sheet ——
            sut.interactor.tapButton(withID: "CloseSheetButton")
            
            // —— ASSERT: sheet’s button is no longer in the hierarchy ——
            try await sut.observer.waitForViewHidden(withID: "sheet.content.group")
            
            sut.observer.printValues()
            
            #expect(sut.observer.values.count == 2, "View should only have 2 views tracked")
        }
        
        @MainActor
        @Test("Open when sheet position at button level")
        func sheetDemoView_Two_when_ShowDetailsButton_then_open_sheet() async throws {
            // —— SYSTEM SETUP ——
            let sut = LensWorkBench { sut in
                DemoSheetItemTwoView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            
            // —— SHOW SHEET ——
            sut.interactor.tapButton(withID: "ShowDetailsButton")
            
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            
            // —— ACTION: close the sheet ——
            sut.interactor.tapButton(withID: "CloseSheetButton")
            
            // —— ASSERT: sheet’s button is no longer in the hierarchy ——
            try await sut.observer.waitForViewHidden(withID: "FavoriteButton")
            #expect(sut.observer.values.count == 2, "View should only have 2 views tracked")
        }
        
        @MainActor
        @Test("Open when sheet position at untracked view")
        func sheetDemoView_Three_when_ShowDetailsButton_then_open_sheet() async throws {
            // —— SYSTEM SETUP ——
            let sut = LensWorkBench { sut in
                DemoSheetItemThreeView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            
            // —— SHOW SHEET ——
            sut.interactor.tapButton(withID: "ShowDetailsButton")
            
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            
            // —— ACTION: close the sheet ——
            sut.interactor.tapButton(withID: "CloseSheetButton")
            
            // —— ASSERT: sheet’s button is no longer in the hierarchy ——
            try await sut.observer.waitForViewHidden(withID: "FavoriteButton")
            #expect(sut.observer.values.count == 2, "View should only have 2 views tracked")
        }
        
        @MainActor
        @Test("Open and Close sheet")
        func open_and_close_sheet() async throws {
            // —— SYSTEM ——
            let sut = LensWorkBench { sut in
                DemoSheetItemView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            sut.interactor.tapButton(withID: "ShowDetailsButton")
            // wait for sheet open:
            try await sut.observer.waitForViewVisible(withID: "sheet.content.group")
            try await sut.observer.waitForViewVisible(withID: "CloseSheetButton")
            
            // ---- WHEN ----
            sut.interactor.tapButton(withID: "CloseSheetButton")
            
            // ---- THEN  ----
            try await sut.observer.waitForViewHidden(withID:  "sheet.content.group")
            
            #expect(sut.observer.containsNotView(withID: "FavoriteText"), "text inside sheet should not be shown")
            #expect(sut.observer.containsNotView(withID: "CloseSheetButton"), "button inside sheet should not be shown")
            #expect(sut.observer.containsNotView(withID: "FavoriteButton"),"button inside sheet should not be shown")
        }
    }
    
    //MARK: - fullScreenCover
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
