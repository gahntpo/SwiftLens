import Foundation
import Testing
@testable import SwiftLens
@testable import SwiftLensTestSupport

struct LensAlertTests {

    @Suite("Alert with Boolean  Toggle")
    struct DemoFullAlertBooleanTests {
        
        @MainActor
        @Test("Alert appears with Boolean toggle")
        func open_alert() async throws {
            // ---- SYSTEM ----
            let sut = LensWorkBench { _ in
                DemoAlertView()
            }
            
            // ---- WHEN ----
            sut.interactor.tapButton(withID: "resetButton")
            
            // ---- THEN ----
            try await sut.observer.waitForViewVisible(withID: "alert.content")
            try await sut.observer.waitForViewVisible(withID: "alert.button.clear")
            try await sut.observer.waitForViewVisible(withID: "alert.button.cancel")
        }
        
        @MainActor
        @Test("Alert disappears after closing",
              .disabled("alert does not close"))
        func alert_open_and_close() async throws {
            // ---- SYSTEM ----
            let sut = LensWorkBench { _ in
                DemoAlertView()
            }
            
            try await sut.observer.waitForValue(forViewID: "countLabel", equals: 3)
            
            sut.interactor.tapButton(withID: "resetButton")
            
            // Alert becomes visible ----
            try await sut.observer.waitForViewVisible(withID: "alert.content")
            try await sut.observer.waitForViewVisible(withID: "alert.button.clear")
            try await sut.observer.waitForViewVisible(withID: "alert.button.cancel")
            
            // ---- WHEN ----
            sut.observer.printValues()
            sut.interactor.tapButton(withID: "alert.button.clear")
            
            // ---- THEN ----
            //ISSUE: alert does not reset preference keys
            try await sut.observer.waitForViewHidden(withID: "alert.content")
            
            try await sut.observer.waitForValue(forViewID: "countLabel", equals: 0)
        }
    }
    
    @Suite("Alert with Data")
    struct DemoFullAlertDataTests {
        @MainActor
        @Test("Alert appears")
        func alert_with_data_opens() async throws {
            // ---- SYSTEM ----
            let sut = LensWorkBench { _ in
                SaveButton()
            }
            
            // ---- WHEN ----
            sut.interactor.tapButton(withID:  "button.show.alert")
            
            // ---- THEN ----
            try await sut.observer.waitForViewVisible(withID: "alert.content")
            try await sut.observer.waitForViewVisible(withID: "alert.button.delete")
            try await sut.observer.waitForViewVisible(withID: "alert.button.retry")
        }
        
        @MainActor
        @Test("Alert open and close",
            .disabled("alert does not cloase"))
        func alert_with_data_open_and_close() async throws {
            // ---- SYSTEM ----
            let sut = LensWorkBench { _ in
                SaveButton()
            }
            
            sut.interactor.tapButton(withID:  "button.show.alert")
            try await sut.observer.waitForViewVisible(withID: "alert.content")
            try await sut.observer.waitForViewVisible(withID: "alert.button.delete")
            try await sut.observer.waitForViewVisible(withID: "alert.button.retry")
            
            // ---- WHEN ----
            sut.interactor.tapButton(withID: "alert.button.retry")
            
            // ---- THEN ----
            
          try await sut.observer.waitForViewHidden(withID: "alert.content")
          
        }
        
    }
    
    @Suite("Alert with Error ")
    struct DemoAlertErrorTests {
        @MainActor
        @Test("Alert appears with error")
        func alert_opens() async throws {
            // ---- GIVEN ----
            let sut = LensWorkBench { _ in
                SaveButton()
            }
        
            // ---- WHEN ----
            sut.interactor.tapButton(withID: "button.show.alert")
            
            // ---- THEN ----
            try await sut.observer.waitForViewVisible(withID: "alert.content")
            sut.observer.printValues()
            
            #expect(sut.observer.containsView(withID: "alert.button.delete"))
            #expect(sut.observer.containsView(withID: "alert.button.retry"))
            
            sut.observer.printValues()
            
        }
        
        @MainActor
        @Test("Alert open and close",
              .disabled("alert does not reset preference keys after closing"))
        func alert_open_and_close() async throws {
            // ---- GIVEN ----
            let sut = LensWorkBench { _ in
                SaveButton()
            }
            
            //open alert
            sut.interactor.tapButton(withID: "button.show.alert")
            
            try await sut.observer.waitForViewVisible(withID: "alert.content")
            try await sut.observer.waitForViewVisible(withID: "alert.button.delete")
            
            // ---- WHEN ----
            sut.interactor.tapButton(withID: "alert.delete")
            
            // ---- THEN ----
            //ISSUE: alert does not reset preference keys
            try await sut.observer.waitForViewHidden(withID: "alert.content")
        }
    }
}
