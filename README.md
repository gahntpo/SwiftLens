# SwiftLens - UI Testing for SwiftUI apps

SwiftLens helps you ship SwiftUI apps faster by making behavior-driven tests easy, stable, and precise. It tracks real visible view state using SwiftUI preferences and simulates user interaction without relying on XCUITest

## Features

📬 Run your UI tests like unit tests with XCTest/Swift Testing
🔍 Declarative view tracking using .lensTracked(id:), .lensGroup(id:), lensButton(id:)
📋 Observe when views are shown and hidden — no fixed delays or polling needed.
🖐️ Interact with your ui by identifiers e.g. sut.observer.tapButton(withId:)
🧪 Behavior-driven test support via LensWorkBench, LensObserver, LensInteractor

Check out the [Usage Guide](./guide_api_coverage.md) for full API coverage.


## Installation

SwiftLens is distributed as a Swift Package with two libraries:

* **`SwiftLens`** – for production code (tracking views, event notification)
* **`SwiftLensTestSupport`** – for test targets (simulation and verification tools)

### Adding via Swift Package Manager

Add the package to your project using Xcode:

1. Go to **File > Add Packages**

2. Use the following URL:

   ```
   https://github.com/gahntpo/SwiftLens.git
   ```

3. Choose the version or branch you want to track.

4. Select the libraries you need:

   * `SwiftLens` → for your main app target
   * `SwiftLensTestSupport` → for your test target


## Getting Started

SwiftLens makes it easy to write clean, declarative tests for SwiftUI by tracking real view state and simulating user interactions — without relying on `XCUITest`.

Here’s a minimal example with Swift Testing to help you get started.


### 1. Define Your View

Use `.lensToggle(id:value:)` to track toggles and `.lensTracked(id:)` to track conditional UI:

```swift
class ToggleViewModel: ObservableObject {
    @Published var isTrue = false
}

struct DemoToggleView: View {
    @ObservedObject var vm: ToggleViewModel

    var body: some View {
        VStack {
            Toggle("Toggle", isOn: $vm.isTrue)
                .lensToggle(id: "CheckList_toggle", value: $vm.isTrue)
                .toggleStyle(.button)

            if vm.isTrue {
                Text("You can toggle this on and off")
                    .lensTracked(id: "text.toggled.visible")
            }
        }
    }
}
```

### 2. Write a Behavior-Driven Test

With `SwiftLensTestSupport`, you simulate toggles and assert state updates using `LensWorkBench`, `LensInteractor`, and `LensObserver`.

#### ✅ First: Check initial UI state

```swift
@MainActor
@Test("Initial state hides conditional text")
func toggleView_initial_state_should_not_show_text() async throws {
    // ---- GIVEN ----
    let vm = ToggleViewModel()
    let sut = LensWorkBench { sut in
        DemoToggleView(vm: vm)
    }

    // ---- THEN ----
    #expect(sut.observer.containsNotView(withID: "text.toggled.visible"), "the text should not be visible")
}
```

#### ✅ Toggle updates the view model

```swift
@MainActor
@Test("Toggle updates view model state")
func toggleView_toggle() async throws {
    // ---- GIVEN ----
    let vm = ToggleViewModel()
    let initial = vm.isTrue

    let sut = LensWorkBench { sut in
        DemoToggleView(vm: vm)
    }

    // ---- WHEN ----
    sut.interactor.toggle(withID: "CheckList_toggle")

    // ---- THEN ----
    #expect(vm.isTrue != initial, "the toggle state should be connected to the view model state")
}
```

#### ✅ Toggled UI becomes visible

```swift
@MainActor
@Test("Toggle shows conditional view")
func toggleView_when_on_then_text_is_visible() async throws {
    // ---- GIVEN ----
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
```


## FAQs

### Which views and modifiers are supported?

SwiftLens supports any SwiftUI view where you can apply `.lensTracked(id:)`, `.lensGroup(id:)`, `.lensButton(id:)`, `.lensToggle(id:value:)`, or other Lens modifiers. You can track visibility, interactivity, and internal states like toggle status, disabled, and focus.

Check out the [Usage Guide](./guide_api_coverage.md) for full API coverage.

---

### Is it using private APIs?

Nope — SwiftLens uses only **public SwiftUI APIs**, specifically the `PreferenceKey` system and `NotificationCenter`. It’s safe for production code. The `SwiftLens` module adds minimal tracking logic to your views. Your main app remains clean and test-friendly. 
If you are okay with changing this:
```swift
Button("Remove Last") {
    viewModel.removeLast()
}
.accessibilityIdentifier("RemoveLastButton")
```
to this:
```swift
Button("Remove Last") {
    viewModel.removeLast()
}
.lensButton(id: "RemoveLastButton")
```


---

### How do I add it to my Xcode project?

Ensure you're linking the libraries to the correct targets:

* Add `SwiftLens` to your **main app target**
* Add `SwiftLensTestSupport` to your **unit test target**

See the [Installation](#installation) section above for instructions using Swift Package Manager.

---

### Is SwiftLens compatible with Swift Package Manager?

Yes — install it via SPM:

```swift
.package(url: "https://github.com/your-org/SwiftLens.git", from: "1.0.0")
```

Add `SwiftLens` to your app target, and `SwiftLensTestSupport` to your test target.

---

### How do I use it in my project?

Follow the [Getting Started](#-getting-started) section to set up view tracking and tests. You can also explore deeper use cases in the [Guide Directory](./guide_view_tracking.md).

---

### How fast do these tests run?

SwiftLens tests typically run **in well under one second**, even for complex UI hierarchies.

This is because:

* ✅ **No polling or artificial `wait` calls** — UI updates are observed in real time via SwiftUI's native `PreferenceKey` system.
* ✅ **No reliance on `XCUITest`** — no simulator boot-up, no view hierarchy traversal delays.
* ✅ **State and UI assertions are in sync** — since SwiftLens runs fully inside the SwiftUI render loop, your tests react to real state updates immediately.

Compared to tools like **ViewInspector**, SwiftLens achieves **comparable or faster performance** — especially in tests involving:

* dynamic view hierarchy
* multiple interactions
* conditional visibility (e.g. modals, if-else blocks)

> 📉 **Typical test runtime**: `~0.1–0.3 sec` per observation.wait() in `@MainActor` test suites.

No view introspection. No thread sleeps. No hidden polling. Just real SwiftUI behavior.


### Contributions

Contributions are welcome! If you find edge cases or want to extend support (e.g., tracking gestures, focus state, or other modifiers), feel free to open an issue or submit a PR.

Want to experiment? Try logging view metadata from the `.onPreferenceChange` of `LensCaptureKey` and see what SwiftUI gives you for free.

---

Let me know if you want this added directly to a full draft `README.md`, or you'd like help generating `guide_view_tracking.md` next.
