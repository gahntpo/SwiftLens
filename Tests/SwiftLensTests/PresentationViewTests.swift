import Foundation
import Testing
@testable import SwiftLens
@testable import SwiftLensTestSupport

struct PresentationViewTests {

    @Suite("Test Open And Close Sheets with Boolean Toggle")
    struct DemoSheetBooleanTests {
        @MainActor
        @Test("Sheet position outside VStack")
        func sheetDemoView_when_ShowDetailsButton_then_open_sheet() async throws {
            // —— SYSTEM SETUP ——
            let sut = UIUnderTest { sut in
                DemoSheetBooleanView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            
            // —— SHOW SHEET ——
            sut.simulator.buttonTap(withID: "ShowDetailsButton")
            
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            
            // —— ACTION: close the sheet ——
            sut.simulator.buttonTap(withID: "CloseSheetButton")
            
            // —— ASSERT: sheet’s button is no longer in the hierarchy ——
            try await sut.observer.waitForViewHidden(withID: "FavoriteButton")
            #expect(sut.observer.values.count == 2, "View should only have 2 views tracked")
        }
        
        @MainActor
        @Test("Sheet position at button level")
        func sheetDemoView_Two_when_ShowDetailsButton_then_open_sheet() async throws {
            // —— SYSTEM SETUP ——
            let sut = UIUnderTest { sut in
                DemoSheetTwoView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            
            // —— SHOW SHEET ——
            sut.simulator.buttonTap(withID: "ShowDetailsButton")
            
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            
            // —— ACTION: close the sheet ——
            sut.simulator.buttonTap(withID: "CloseSheetButton")
            
            // —— ASSERT: sheet’s button is no longer in the hierarchy ——
            try await sut.observer.waitForViewHidden(withID: "FavoriteButton")
            #expect(sut.observer.values.count == 2, "View should only have 2 views tracked")
        }
        
        @MainActor
        @Test("Sheet position at untracked view")
        func sheetDemoView_Three_when_ShowDetailsButton_then_open_sheet() async throws {
            // —— SYSTEM SETUP ——
            let sut = UIUnderTest { sut in
                DemoSheetThreeView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            
            // —— SHOW SHEET ——
            sut.simulator.buttonTap(withID: "ShowDetailsButton")
            
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            
            // —— ACTION: close the sheet ——
            sut.simulator.buttonTap(withID: "CloseSheetButton")
            
            // —— ASSERT: sheet’s button is no longer in the hierarchy ——
            try await sut.observer.waitForViewHidden(withID: "FavoriteButton")
            #expect(sut.observer.values.count == 2, "View should only have 2 views tracked")
        }
    }
    
    //DemoSheetItemView
    
    @Suite("Test Open And Close Sheets with Item Toggle")
    struct DemoSheetItemTests {
        @MainActor
        @Test("Sheet position outside VStack")
        func sheetDemoItemView_when_ShowDetailsButton_then_open_sheet() async throws {
            // —— SYSTEM SETUP ——
            let sut = UIUnderTest { sut in
                DemoSheetItemView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            
            // —— SHOW SHEET ——
            sut.simulator.buttonTap(withID: "ShowDetailsButton")
            
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            
            // —— ACTION: close the sheet ——
            sut.simulator.buttonTap(withID: "CloseSheetButton")
            
            // —— ASSERT: sheet’s button is no longer in the hierarchy ——
            try await sut.observer.waitForViewHidden(withID: "FavoriteButton")
            #expect(sut.observer.values.count == 2, "View should only have 2 views tracked")
        }
        
        @MainActor
        @Test("Sheet position at button level")
        func sheetDemoView_Two_when_ShowDetailsButton_then_open_sheet() async throws {
            // —— SYSTEM SETUP ——
            let sut = UIUnderTest { sut in
                DemoSheetItemTwoView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            
            // —— SHOW SHEET ——
            sut.simulator.buttonTap(withID: "ShowDetailsButton")
            
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            
            // —— ACTION: close the sheet ——
            sut.simulator.buttonTap(withID: "CloseSheetButton")
            
            // —— ASSERT: sheet’s button is no longer in the hierarchy ——
            try await sut.observer.waitForViewHidden(withID: "FavoriteButton")
            #expect(sut.observer.values.count == 2, "View should only have 2 views tracked")
        }
        
        @MainActor
        @Test("Sheet position at untracked view")
        func sheetDemoView_Three_when_ShowDetailsButton_then_open_sheet() async throws {
            // —— SYSTEM SETUP ——
            let sut = UIUnderTest { sut in
                DemoSheetItemThreeView()
            }
            
            try await sut.observer.waitForViewVisible(withID: "ShowDetailsButton")
            
            // —— SHOW SHEET ——
            sut.simulator.buttonTap(withID: "ShowDetailsButton")
            
            try await sut.observer.waitForViewVisible(withID: "FavoriteButton")
            
            // —— ACTION: close the sheet ——
            sut.simulator.buttonTap(withID: "CloseSheetButton")
            
            // —— ASSERT: sheet’s button is no longer in the hierarchy ——
            try await sut.observer.waitForViewHidden(withID: "FavoriteButton")
            #expect(sut.observer.values.count == 2, "View should only have 2 views tracked")
        }
    }
}
