import Foundation
import Testing
@testable import SwiftLens
@testable import SwiftLensTestSupport

struct ControlViewTests {
    
    @Suite("Test Demo Toggle View")
    struct ToggleTests {
        @MainActor
        @Test("Initial views visible", arguments: [true, false])
        func toggle_ui_show_initial_state_for(isOn: Bool) async throws {
            
            // ---- SYSTEM ----
            let vm = ToggleViewModel()
            vm.isTrue = isOn
            
            let sut = LensWorkBench { sut in
                DemoToggleView(vm: vm)
            }
            
            // ---- WHEN ----
            
            // ---- THEN ----
            #expect(sut.observer.containsView(withID: "CheckList_toggle"))
            
            let visibileToggleState = sut.observer.toggleState(forViewID: "CheckList_toggle")
            #expect(visibileToggleState == isOn, "expect toggle to show state from viewmodel")
        }
        
        @MainActor
        @Test("Press toggle update ViewModel state")
        func toggleView_when_toggle_simulated_then_ViewModel_state_is_updated() async throws {
            // ---- SYSTEM ----
            let vm = ToggleViewModel()
            #expect(!vm.isTrue)
            let sut = LensWorkBench { sut in
                DemoToggleView(vm: vm)
            }
            
            // ---- WHEN ----
            sut.interactor.toggle(withID: "CheckList_toggle", to: true)
            
            // ---- THEN ----
            #expect(vm.isTrue)
        }
        
        @MainActor
        @Test("Press toggle update UI")
        func toggleView_when_toggle_isOn_then_condional_view_is_shown() async throws {
            // ---- SYSTEM ----
            let vm = ToggleViewModel()
            
            let sut = LensWorkBench { sut in
                DemoToggleView(vm: vm)
            }
            
            // ---- WHEN ----
            sut.interactor.toggle(withID: "CheckList_toggle", to: true)
            
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
        func picker_ui_show_initial_selection() async throws {
            // ---- SYSTEM ----
            let sut = LensWorkBench { sut in
                DemoPickerView()
            }
            
            // ---- WHEN ----
          
            // ---- THEN ----
            #expect(sut.observer.containsView(withID: "demo_picker"))
            #expect(sut.observer.value(forViewID: "demo_picker", key: "value") as? FoodCategory == .american)
            
            #expect(sut.observer.containsView(withID: "demo_date_picker"))
        }
        
        @MainActor
        @Test("Press picker to change state", arguments: [FoodCategory.chinese, .indian, .italian, .mexican])
        func picker_change_selection(to newSelection: FoodCategory) async throws {
            // ---- SYSTEM ----
            let sut = LensWorkBench { sut in
                DemoPickerView()
            }
            
            // ---- WHEN ----
            sut.interactor.picker(withID: "demo_picker", to: newSelection)
            
            // ---- THEN ----
            try await sut.observer.waitForValue(forViewID: "demo_picker", equals: newSelection)
           // #expect(sut.observer.value(forViewID: "demo_picker", key: "value") as? FoodCategory == newSelection)
        }
        
        @MainActor
        @Test("Press date picker to change state")
        func date_picker_change_selection() async throws {
            // ---- SYSTEM ----
            let sut = LensWorkBench { sut in
                DemoPickerView()
            }
            
            // ---- WHEN ----
            let newDate = Date()
            sut.interactor.picker(withID: "demo_date_picker", to: newDate)
            
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
        func slider_ui_shows_initial_selection() async throws {
            // ---- SYSTEM ----
            let sut = LensWorkBench { sut in
                DemoSliderView()
            }
            
            // ---- WHEN ----
            
            // ---- THEN ----
            #expect(sut.observer.containsView(withID: "demo-slider"))
            #expect(sut.observer.value(forViewID: "demo-slider", key: "value") as? Double == 1)
        }
        
        @MainActor
        @Test("Change slider views state", arguments: [Double(2), Double(400.5), Double(23.005)])
       func slider_change_selection(to newValue: Double) async throws {
            // ---- SYSTEM ----
            let sut = LensWorkBench { sut in
                DemoSliderView()
            }
            
            // ---- WHEN ----
            sut.interactor.slider(withID: "demo-slider", to: newValue)
            
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
        func stepper_ui_shows_initial_selection() async throws {
            // ---- SYSTEM ----
            let sut = LensWorkBench { sut in
                DemoStepperView()
            }
            
            // ---- WHEN ----
            
            // ---- THEN ----
            #expect(sut.observer.containsView(withID: "demo_stepper"))
            #expect(sut.observer.value(forViewID: "demo_stepper", key: "value") as? CGFloat == 1)
        }
        
        @MainActor
        @Test("Change slider views state", arguments: [0.1, 23.4, 100])
         func steper_change_selection(to newValue: CGFloat) async throws {
            // ---- SYSTEM ----
            let sut = LensWorkBench { sut in
                DemoStepperView()
            }
            
            // ---- WHEN ----
            sut.interactor.stepper(withID: "demo_stepper", to: newValue)
            
            // ---- THEN ----
            try await sut.observer.waitForValue(forViewID: "demo_stepper", equals: newValue)

            #expect(sut.observer.value(forViewID: "demo_stepper", key: "value") as? CGFloat == newValue)
        }
    }
    
    //MARK: - TextField
    @Suite("Test DemoTextFieldView Initial Content")
    struct DemoTextFieldViewTests {
        @MainActor
        @Test("Initial state with empty text")
        func textField_ui_shows_initial_text() async throws {
            // ---- SYSTEM ----
            let vm = DefaultTextViewModel()
            let sut = LensWorkBench { sut in
                DemoTextFieldView(viewModel: vm)
            }
            
            // ---- WHEN ----
            
            // ---- THEN ----
            #expect(vm.text == "")
            #expect(sut.observer.containsView(withID: "demo_textfield"))
            #expect(sut.observer.textFieldText(forViewID: "demo_textfield") == "")

        }
        
        @MainActor
        @Test("Change text field state", arguments: ["f", "fi", "first", "first long text"])
        func textfield_change_selection(to newValue: String) async throws {
            // ---- SYSTEM ----
            let vm = DefaultTextViewModel()
            let sut = LensWorkBench { sut in
                DemoTextFieldView(viewModel: vm)
            }
            
            // ---- WHEN ----
            sut.interactor.textField(withID: "demo_textfield", to: newValue)
            
            // ---- THEN ----
            try await sut.observer.waitForView(withID: "demo_textfield", hasValue: newValue)
            #expect(sut.observer.textFieldText(forViewID: "demo_textfield") == newValue)
        }
        
        
        @MainActor
        @Test("Change text field´s text and pass value to view model")
        func textfield_change_then_viewmodel_update() async throws {
            // ---- SYSTEM ----
            let vm = DefaultTextViewModel()
            let sut = LensWorkBench { sut in
                DemoTextFieldView(viewModel: vm)
            }
            let newValue = "new text"
            
            // ---- WHEN ----
            sut.interactor.textField(withID: "demo_textfield", to: newValue)
            
            // ---- THEN ----
            #expect(vm.text == newValue)
            
            try await sut.observer.waitForView(withID: "demo_textfield", hasValue: newValue)
            
            #expect(sut.observer.containsView(withID: "demo_textfield"))
            #expect(sut.observer.textFieldText(forViewID: "demo_textfield") == newValue)

        }
        
        @MainActor
        @Test("Press Enter trigger view model func")
        func press_enter_then_viewmodel_func_called() async throws {
            // ---- SYSTEM ----
            let vm = MockTextViewModel()
            let sut = LensWorkBench { sut in
                DemoTextFieldView(viewModel: vm)
            }
            
            // ---- WHEN ----
            let newValue = "new text"
            sut.interactor.textField(withID: "demo_textfield", to: newValue)
            sut.interactor.textFieldMakeFocus(withID: "demo_textfield")
            
            try await sut.observer.waitForTextFieldFocused(withID: "demo_textfield", isFocused: true)
            
            //Problem: dont know how to programmatically trigger submit
            //Could use ViewInspector with callOnCommit
            let enter = "\n"
            sut.interactor.textField(withID: "demo_textfield", to: enter)
            
           // try await sut.observer.waitForTextFieldFocused(withID: "demo_textfield", isFocused: false)
            
            // ---- THEN ----
            // #expect(vm.didCallAction, "Submit action not called")

        }
    }
    
    @Suite("Test DemoSearchableView Initial Content")
    struct DemoSearchableTextFieldViewTests {
        
        @available(iOS 16.0, *)
        @MainActor
        @Test("Initial state with empty text")
        func searchable_textField_shows_initially_empty_text() async throws {
            // ---- SYSTEM ----
            let vm = SearchViewModel()
            let sut = LensWorkBench { sut in
                DemoSearchableView(viewModel: vm)
            }
            #expect(vm.searchText == "")
            
            // ---- WHEN ----
            
            // ---- THEN ----
           
            #expect(sut.observer.containsView(withID: "searchtext"))
            #expect(sut.observer.textFieldText(forViewID: "searchtext") == "")
        }
        
        @available(iOS 16.0, *)
        @MainActor
        @Test("Change text field state", arguments: ["f", "fi", "first", "first long text"])
        func searchable_textfield_change_selection(to newValue: String) async throws {
            // ---- SYSTEM ----
            let vm = SearchViewModel()
            let sut = LensWorkBench { sut in
                DemoSearchableView(viewModel: vm)
            }
            
            // ---- WHEN ----
            sut.interactor.textField(withID: "searchtext", to: newValue)
            
            // ---- THEN ----
            try await sut.observer.waitForView(withID: "searchtext", hasValue: newValue)
            #expect(sut.observer.textFieldText(forViewID: "searchtext") == newValue)
        }
        
        @available(iOS 16.0, *)
        @MainActor
        @Test("Change text field´s text", arguments: [("f", 1), ("first", 1), ("first text", 0)])
        func searchable_selection_updates_search_results_in_list(for newValue: String,
                                                                 toResultCount: Int) async throws {
            // ---- SYSTEM ----
            let vm = SearchViewModel()
            let sut = LensWorkBench { sut in
                DemoSearchableView(viewModel: vm)
            }
            
            // ---- WHEN ----
            sut.interactor.textField(withID: "searchtext", to: newValue)
            
            // ---- THEN ----
            #expect(vm.searchText == newValue)
            
            //visible search result: only one item in list:
            try await sut.observer.waitForViewCount(withViewIDPrefix: "item.",
                                                    expected: toResultCount)
        }
    }
}

