import Foundation
import Testing
@testable import SwiftLens
@testable import SwiftLensTestSupport

struct ControlViewTests {
    
    @Suite("Test Demo Toggle View")
    struct ToggleTests {
        @MainActor
        @Test("Initial views visible")
        func demoToggleView_initial_visible() async throws {
            
            // ---- SYSTEM ----
            let vm = ToggleViewModel()
            
            let sut = UIUnderTest { sut in
                DemoToggleView(vm: vm)
            }
            
            // ---- WHEN ----
            #expect(!vm.isTrue)
            
            
            // ---- THEN ----
            #expect(sut.observer.containsView(withID: "CheckList_toggle"))
            #expect(sut.observer.isToggleOff(forViewID: "CheckList_toggle"))
            #expect(sut.observer.containsNotView(withID: "text.toggled.visible"))
        }
        
        @MainActor
        @Test("Press toggle update ViewModel state")
        func demoToggleView_when_toggle_update_ViewModel_state() async throws {
            // ---- SYSTEM ----
            let vm = ToggleViewModel()
            
            let sut = UIUnderTest { sut in
                DemoToggleView(vm: vm)
            }
            
            // ---- WHEN ----
            sut.simulator.toggle(withID: "CheckList_toggle", to: true)
            
            // ---- THEN ----
            #expect(vm.isTrue)
        }
        
        @MainActor
        @Test("Press toggle update UI")
        func demoToggleView_when_toggle_update_UI() async throws {
            // ---- SYSTEM ----
            let vm = ToggleViewModel()
            
            let sut = UIUnderTest { sut in
                DemoToggleView(vm: vm)
            }
            
            // ---- WHEN ----
            sut.simulator.toggle(withID: "CheckList_toggle", to: true)
            
            // ---- THEN ----
            try await sut.observer.waitForValue(forViewID: "CheckList_toggle", equals: true)
            
            #expect(sut.observer.isToggleOn(forViewID: "CheckList_toggle"))
            #expect(sut.observer.values.containsView(withID: "text.toggled.visible"))
        }
    }
    
    @Suite("Test Demo Picker View")
    struct PickerTests {
        
        @MainActor
        @Test("Initial views state")
        func demoPickerView_initial_visible() async throws {
            // ---- SYSTEM ----
            let sut = UIUnderTest { sut in
                DemoPickerView()
            }
            
            // ---- WHEN ----
          
            
            // ---- THEN ----
            #expect(sut.observer.containsView(withID: "demo_picker"))
            #expect(sut.observer.value(forViewID: "demo_picker", key: "value") as? FoodCategory == .american)
            
            #expect(sut.observer.containsView(withID: "demo_date_picker"))
        }
        
        @MainActor
        @Test("Press picker to change state")
        func demoPickerView_when_picker_changed_then_state_change() async throws {
            // ---- SYSTEM ----
            let sut = UIUnderTest { sut in
                DemoPickerView()
            }
            
            // ---- WHEN ----
            let newSelection = FoodCategory.chinese
            sut.simulator.picker(withID: "demo_picker", to: newSelection)
            
            // ---- THEN ----
            try await sut.observer.waitForValue(forViewID: "demo_picker", equals: newSelection)
           // #expect(sut.observer.value(forViewID: "demo_picker", key: "value") as? FoodCategory == newSelection)
        }
        
        @MainActor
        @Test("Press date picker to change state")
        func demoPickerView_when_date_picker_changed_then_state_change() async throws {
            // ---- SYSTEM ----
            let sut = UIUnderTest { sut in
                DemoPickerView()
            }
            
            // ---- WHEN ----
            let newDate = Date()
            sut.simulator.picker(withID: "demo_date_picker", to: newDate)
            
            // ---- THEN ----
            try await sut.observer.waitForValue(forViewID: "demo_date_picker", equals: newDate)
            //try await Task.sleep(nanoseconds: 1000_000_000) // 1 milli second
            
            #expect(sut.observer.containsView(withID: "demo_date_picker"))
            #expect(sut.observer.value(forViewID: "demo_date_picker", key: "value") as? Date == newDate)
        }
    }
    

    @Suite("Test Demo Slider View")
    struct SliderTests {
        
        @MainActor
        @Test("Initial views state")
        func demoSliderView_initial_visible() async throws {
            // ---- SYSTEM ----
            let sut = UIUnderTest { sut in
                DemoSliderView()
            }
            
            // ---- WHEN ----
            
            
            // ---- THEN ----
            #expect(sut.observer.containsView(withID: "demo-slider"))
            #expect(sut.observer.value(forViewID: "demo-slider", key: "value") as? Double == 1)
        }
        
        @MainActor
        @Test("Change slider views state")
        func demoSliderView_change_slider_state() async throws {
            // ---- SYSTEM ----
            let sut = UIUnderTest { sut in
                DemoSliderView()
            }
            
            // ---- WHEN ----
            let newValue = Double(2)
            sut.simulator.slider(withID: "demo-slider", to: newValue)
            
            // ---- THEN ----
            try await sut.observer.waitForValue(forViewID: "demo-slider", equals: newValue)
            //try await Task.sleep(nanoseconds: 1000_000_000) // 1 milli second
            
            #expect(sut.observer.value(forViewID: "demo-slider", key: "value") as? Double == newValue)
        }
    }
    
    @Suite("Test Demo Stepper View")
    struct StepperTests {
        
        @MainActor
        @Test("Initial views state")
        func demoStepperView_initial_visible() async throws {
            // ---- SYSTEM ----
            let sut = UIUnderTest { sut in
                DemoStepperView()
            }
            
            // ---- WHEN ----
            
            
            // ---- THEN ----
            #expect(sut.observer.containsView(withID: "demo_stepper"))
            #expect(sut.observer.value(forViewID: "demo_stepper", key: "value") as? CGFloat == 1)
        }
        
        @MainActor
        @Test("Change slider views state")
        func demoStepperView_change_slider_state() async throws {
            // ---- SYSTEM ----
            let sut = UIUnderTest { sut in
                DemoStepperView()
            }
            
            // ---- WHEN ----
            let newValue = CGFloat(2)
            sut.simulator.stepper(withID: "demo_stepper", to: newValue)
            
            // ---- THEN ----
            try await sut.observer.waitForValue(forViewID: "demo_stepper", equals: newValue)

            #expect(sut.observer.value(forViewID: "demo_stepper", key: "value") as? CGFloat == newValue)
        }
    }
    
    @Suite("Test DemoTextFieldView Initial Content")
    struct DemoTextFieldViewTests {
        @MainActor
        @Test("Initial state with empty text")
        func demoButtonView_initial_items_visible() async throws {
            // ---- SYSTEM ----
            let vm = DefaultTextViewModel()
            let sut = UIUnderTest { sut in
                DemoTextFieldView(viewModel: vm)
            }
            
            // ---- WHEN ----
            
            // ---- THEN ----
            #expect(vm.text == "")
            #expect(sut.observer.containsView(withID: "demo_textfield"))
            #expect(sut.observer.textFieldText(forViewID: "demo_textfield") == "")

        }
        
        @MainActor
        @Test("Change text field´s text")
        func demoButtonView_when_textfield_change_viewmodel_update() async throws {
            // ---- SYSTEM ----
            let vm = DefaultTextViewModel()
            let sut = UIUnderTest { sut in
                DemoTextFieldView(viewModel: vm)
            }
            
            // ---- WHEN ----
            let newValue = "new text"
            sut.simulator.textField(withID: "demo_textfield", to: newValue)
            
            // ---- THEN ----
            #expect(vm.text == newValue)
            
            try await sut.observer.waitForView(withID: "demo_textfield", hasValue: newValue)
            
            #expect(sut.observer.containsView(withID: "demo_textfield"))
            #expect(sut.observer.textFieldText(forViewID: "demo_textfield") == newValue)

        }
        
        @MainActor
        @Test("Press Enter trigger view model func")
        func demoButtonView_when_textfield_enter_then_viewmodel_func_called() async throws {
            // ---- SYSTEM ----
            let vm = MockTextViewModel()
            let sut = UIUnderTest { sut in
                DemoTextFieldView(viewModel: vm)
            }
            
            // ---- WHEN ----
            let newValue = "new text"
            sut.simulator.textField(withID: "demo_textfield", to: newValue)
            sut.simulator.textFieldMakeFocus(withID: "demo_textfield")
            
            try await sut.observer.waitForTextFieldFocused(withID: "demo_textfield", isFocused: true)
            
            //Problem: dont know how to programmatically trigger submit
            //Could use ViewInspector with callOnCommit
            let enter = "\n"
            sut.simulator.textField(withID: "demo_textfield", to: enter)
            
           // try await sut.observer.waitForTextFieldFocused(withID: "demo_textfield", isFocused: false)
            
            // ---- THEN ----
            // #expect(vm.didCallAction, "Submit action not called")

        }
    }
}

