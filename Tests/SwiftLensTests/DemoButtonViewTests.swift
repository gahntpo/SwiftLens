//
//  Test.swift
//  SwiftLens
//
//  Created by Karin Prater on 29/04/2025.
//

import Foundation
import Testing
@testable import SwiftLens
@testable import SwiftLensTestSupport

struct DemoButtonViewTests {

    @Suite("Test DemoButtonView Initial Content")
    struct DemoButtonViewInitalTests {
        @MainActor
        @Test("Initial state with items")
        func demoButtonView_initial_items_visible() async throws {
            // ---- SYSTEM ----
            let vm = DefaultViewModel()
            let sut = UIUnderTest { sut in
                DemoButtonView(viewModel: vm)
            }
            
            // ---- WHEN ----
            
            // ---- THEN: View Model State ----
            #expect(vm.items.count == 3)
            
            // ---- THEN: Views Visible----
            for item in vm.items {
                #expect(sut.observer.containsView(withID: "item.\(item.id)"))
            }
        }
        
        @MainActor
        @Test("Initial state with button enabled")
        func demoButtonView_when_app_launches_then_button_is_visible_and_enabled() async throws {
            // ---- SYSTEM ----
            let vm = DefaultViewModel()
            let sut = UIUnderTest { sut in
                DemoButtonView(viewModel: vm)
            }
            
            // ---- WHEN ----
            
            // ---- THEN----
            #expect(sut.observer.containsView(withID: "RemoveLastButton"))
            #expect(sut.observer.isEnabledState(forViewID: "RemoveLastButton"))
        }
    }
    
    @Suite("Test DemoButtonView Empty Content")
    struct DemoButtonViewEmptyTests {
        @MainActor
        @Test("Empty state placeholder shown") func demoButtonView_when_no_items_then_empty_state_view_visible() async throws {
            // ---- SYSTEM ----
            let vm = DefaultViewModel()
            let sut = UIUnderTest { _ in
                DemoButtonView(viewModel: vm)
            }
            
            // ---- WHEN ----
            vm.items = [] // Remove all items
            
            // ---- THEN: Updates to View ----
            try await sut.observer.waitForViewCount(withViewIDPrefix: "item.", expected: 0)
            
            try await sut.observer.waitForViewVisible(withID: "demo_items_empty_placeholder")
        }
        
        @MainActor
        @Test("Empty state button disabled")
        func demoButtonView_when_no_items_then_button_disabled() async throws {
            // ---- SYSTEM ----
            let vm = DefaultViewModel()
            let sut = UIUnderTest { _ in
                DemoButtonView(viewModel: vm)
            }
            
            // ---- WHEN ----
            vm.items = [] // Remove all items
            
            // ---- THEN: Updates to View ----
            try await sut.observer.waitForViewCount(withViewIDPrefix: "item.", expected: 0)
            
            #expect(sut.observer.containsView(withID: "RemoveLastButton"))
            #expect(sut.observer.isDisabledState(forViewID: "RemoveLastButton"))
        }
    }
    
    
    // MARK: - VIEWMODEL LOGIC
    @Suite("Test View Model")
    struct DemoButtonViewModelTests {
        @MainActor
        @Test("Button triggers view model func")
        func demoButtonView_when_button_pressed_then_viewmodel_triggered() async throws {
            // ---- SYSTEM ----
            let vm = MockViewModel()
            let sut = UIUnderTest { sut in
                DemoButtonView(viewModel: vm)
            }
            
            // ---- WHEN ----
            sut.simulator.buttonTap(withID: "RemoveLastButton")
            
            // ---- THEN ----
            #expect(vm.didCallAction, "RemoveLastButton action not called")
        }
        
        @Test("Func removelast reduces items")
        func demoButtonView_when_viewmodel_removeLast_called_then_items_reduce() async throws {
            // ---- SYSTEM ----
            let vm = DefaultViewModel()
            #expect(vm.items.count == 3)
            
            // ---- WHEN ----
            let removedId = vm.items.last?.id ?? UUID()
            vm.removeLast()
            
            // ---- THEN ----
            #expect(vm.items.count == 2, "Button action should reduce item count from 3 to 2")
            #expect(vm.items.contains(where: { $0.id == removedId }) == false)
        }
        
        @Test("Func removelast does not crash when items empty")
        func demoButtonView_when_removeLast_called_on_empty_viewModel_then_no_crash() {
            // ---- SYSTEM ----
            let vm = DefaultViewModel()
            vm.items.removeAll()
            
            // ---- WHEN ----
            vm.removeLast()
            
            // ---- THEN ----
            #expect(vm.items.isEmpty)
        }
    }
    
    // MARK: - END-TO-END INTERACTION
    
    @Suite("Test END-TO-END INTERACTION")
    struct EndToEndInteractionTests {
        
        @MainActor
        @Test("Press button and remove last item from UI")
        func demoButtonView_when_button_pressed_then_item_removed_from_UI() async throws {
            // ---- SYSTEM ----
            let vm = DefaultViewModel()
            let sut = UIUnderTest { sut in
                DemoButtonView(viewModel: vm)
            }
            
            // ---- WHEN ----
            let removedId = vm.items.last?.id ?? UUID()
            sut.simulator.buttonTap(withID: "RemoveLastButton")
            
            // ---- THEN: Updates to View ----
            try await sut.observer.waitForViewHidden(withID: "item.\(removedId)")   // only one of this is necessary for waiting
            try await sut.observer.waitForViewCount(withViewIDPrefix: "item.", expected: 2)
            
            for item in vm.items {
                #expect(sut.observer.containsView(withID: "item.\(item.id)"))
            }
            
            #expect(sut.observer.viewCount(withIDPrefix: "item.") == 2)
            #expect(sut.observer.containsNotView(withID: "item.\(removedId)"))
        }
        
        // MARK: - MULTIPLE INTERACTIONS
        
        @MainActor
        @Test("Press button multiple times until only one item")
        func demoButtonView_when_button_pressed_multiple_times_then_all_but_one_item_removed() async throws {
            // ---- SYSTEM ----
            let vm = DefaultViewModel()
            let sut = UIUnderTest { sut in
                DemoButtonView(viewModel: vm)
            }
            
            // ---- WHEN ----
            sut.simulator.buttonTap(withID: "RemoveLastButton")
            sut.simulator.buttonTap(withID: "RemoveLastButton")
            
            // ---- THEN: View Model items update ----
            #expect(vm.items.count == 1)
            
            // ---- THEN: Updates to View ----
            try await sut.observer.waitForViewCount(withViewIDPrefix: "item.", expected: 1)
            
            #expect(sut.observer.enabledState(forViewID: "RemoveLastButton") == true)
        }
        
        @MainActor
        @Test("Press button multiple times until empty item")
        func demoButtonView_when_button_pressed_multiple_times_then_all_items_removed() async throws {
            // ---- SYSTEM ----
            let vm = DefaultViewModel()
            let sut = UIUnderTest { sut in
                DemoButtonView(viewModel: vm)
            }
            
            // ---- WHEN ----
            sut.simulator.buttonTap(withID: "RemoveLastButton")
            sut.simulator.buttonTap(withID: "RemoveLastButton")
            sut.simulator.buttonTap(withID: "RemoveLastButton")
            
            // ---- THEN: View Model items update ----
            #expect(vm.items.isEmpty)
            
            // ---- THEN: Updates to View ----
            try await sut.observer.waitForViewCount(withViewIDPrefix: "item.", expected: 0)
            
            #expect(sut.observer.enabledState(forViewID: "RemoveLastButton") == false)
            #expect(sut.observer.isDisabledState(forViewID: "RemoveLastButton"))
        }
    }
}


