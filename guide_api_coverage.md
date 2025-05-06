# API Coverage

This document reflects the current status of the SwiftLens framework: which Views and Modifiers are available for testing.

Please open a PR if any View or Modifier is not listed!
                                                                                                                    
## 🎮 Control Views
These are interactive views where SwiftLens can track user input:

| Status | View Type          | Lens Modifier                | Trackable Attributes            |
| ------ | ------------------ | ---------------------------- | ------------------------------- |
| ✅      | `Toggle`           | `.lensToggle(id:value:)`     | `value`, `isEnabled`            |
| ✅      | `Stepper`          | `.lensStepper(id:value:)`    | `value`, `isEnabled`            |
| ✅      | `Slider`           | `LensSlider(id:value:)`      | `value`, `isEnabled`            |
| ✅      | `Picker`           | `.lensPicker(id:selection:)` | `value`, `isEnabled`            |
| ✅      | `DatePicker`       | `.lensPicker(id:selection:)` | `value`, `isEnabled`            |
| ✅      | `MultiDatePicker`  | `.lensPicker(id:selection:)` | `value`, `isEnabled`            |
| ✅      | `ColorPicker`      | `.lensPicker(id:selection:)` | `value`, `isEnabled`            |
| ✅      | `TextField`        | `.lensTextField(id:text:)`   | `value`, `focused`, `isEnabled` |
| ✅      | `TextEditor`       | `.lensTextEditor(id:text:)`  | `value`, `isEnabled`            |
| ✅      | `Searchable`       | `.lensSearchable(id:text:)`  | `value` (search text)           |
| ✅      | `SecureField`      | `.lensTextEditor(id:text:)`  | `value`, `isEnabled`, `focused` |
| ✅      | `Button`           | `.lensButton(id:)`           | `isEnabled`, tap                |
| ✅      | `NavigationLink`   | `.lensButton(id:)`           | `isEnabled`, tap                |
| ❌      | `Link`             | –                            | no tracking yet                 |
| ❌      | `Menu`             | –                            | not yet tracked                 |
| ❌      | `ShareLink`        | –                            | not yet tracked                 |


This table shows how to simulate user interactions for each supported view using `LensInteractor`.

| View Type                   | Interactor Method                              | Example Usage                                    | Notes                                      |
| --------------------------- | ---------------------------------------------- | ------------------------------------------------ | ------------------------------------------ |
| **Button**                  | `tapButton(withID:)`                           | `sut.interactor.tapButton(withID: "submit")`     | Triggers `action` block                    |
| **Toggle**                  | `toggle(withID:)`<br>`toggle(withID:to:)`      | `toggle(id)` → toggles<br>`toggle(id, to: true)` | Updates bound value                        |
| **Picker**                  | `picker(withID:to:)`                           | `picker(id, to: .optionA)`                       | Supports `Picker`, `DatePicker`            |
| **Slider**                  | `slider(withID:to:)`                           | `slider(id, to: 0.5)`                            | Sends final value (on editing end)         |
| **Stepper**                 | `stepper(withID:to:)`                          | `stepper(id, to: 10)`                            | Updates value                              |
| **TextField**               | `textField(withID:to:)`                        | `textField(id, to: "email@example.com")`         | Updates text                               |
|                             | `textFieldMakeFocus(withID:)`<br>`...NotFocus` | `makeFocus(id)` → focus<br>`notFocus(id)` → blur | Focus state simulation                     |
| **Searchable**              | `textField(withID:to:)`                        | same as `TextField`                              | Binds to internal `TextField`              |
| **NavigationLink**          | *(No direct interactor)*                       | –                                                | Tapping only works outside List            |
| **Sheet / FullScreenCover** | *(Driven via `@Binding`)*                      | Set state directly in test                       | No `interactor` method; use VM/state setup |


### Example

```swift
sut.interactor.toggle(withID: "CheckList_toggle", to: true)
sut.interactor.tapButton(withID: "SubmitButton")
sut.interactor.textField(withID: "emailField", to: "hello@swiftlens.dev")
```

These calls mirror real user interactions, allowing stable and isolated view tests without needing UI test infrastructure.



## 🧱 Static Views

These are typically read-only views. You can track their presence **and pass custom metadata** using the `info:` parameter. You can track any SwiftUI view e.g.:

| Status | View Type      | Lens Modifier            | Trackable Attributes / Custom Info  |
| ------ | -------------- | ------------------------ | ----------------------------------- |
| ✅      | `Text`         | `.lensTracked(id:info:)` | any key-value pairs, e.g. `"value"` |
| ✅      | `Label`        | `.lensTracked(id:info:)` | any custom info                     |
| ✅      | `Image`        | `.lensTracked(id:info:)` | custom info (e.g. image name, size) |
| ✅      | `Divider`      | `.lensTracked(id:)`      | presence only                       |
| ✅      | `ProgressView` | `.lensTracked(id:info:)` | value, progress percentage, etc.    |
| ✅      | `EmptyView`    | `.lensTracked(id:)`      | presence only                       |

> 💡 You can attach custom view state using `info`, for example:
>
> ```swift
> Text(item.name)
>   .lensTracked(id: "item.\(item.id)", info: ["value": item.name])
> ```

In your test, this allows fine-grained assertions:

```swift
#expect(observer.value(forViewID: "item.\(id)", key: "value") == "My Item")
```


## 📦 Container Views

Use `.lensGroup(id:)` or `LensList` to observe dynamic content in your tests.

| Status | View Type       | Lens Tool               | Trackable Attributes        |
| ------ | --------------- | ----------------------- | --------------------------- |
| ✅      | `List`          | `.lensGroup(id:)`       | groups nested captures      |
| ✅      | `List` (with NavigationLink in NavigationStack)         | `.lensGroup(id:)`       | groups nested captures      |
| ✅      | `VStack/HStack` | `.lensGroup(id:)`       | groups nested captures      |
| ✅      | `ScrollView`    | `.lensGroup(id:)`       | groups nested captures      |
| ✅      | `ForEach`       | Use with `.lensTracked` | dynamic ID-based children   |
| ✅      | `Group`         | Use with `.lensTracked` | dynamic ID-based children   |
| ✅      | `LazyVStack`    | `.lensGroup(id:)`        | groups nested captures      |
| ✅      | `Grid`          | `.lensGroup(id:)`        | groups nested captures      |
| ✅      | `LazyVGrid`     | `.lensGroup(id:)`        | groups nested captures      |

```swift
let columns = [GridItem(.flexible()), GridItem(.flexible())]

LazyVGrid(columns: columns) {
    ForEach(items) { item in
        Text(item.title)
            .lensTracked(id: "item.\(item.id)")
    }
}
.lensGroup(id: "grid.section")
```

In your test, this allows you to wait for views inside the container to appear:

```swift
try await sut.observer.waitForViewCount(withViewIDPrefix: "item.", expected: 5)
```


## 📲 Presentation Views

These modifiers allow testing of modal navigation and presented content.

| Status | View Type            | Lens Modifier                           | Trackable Attributes                 |
| ------ | -------------------- | --------------------------------------- | ------------------------------------ |
| ✅      | `sheet`              | `.lensSheet(id:isPresented:)`           | child views inside sheet            |
| ✅      | `sheet(item:)`       | `.lensSheet(id:item:)`                  | child views inside sheet            |
| ✅      | `fullScreenCover`    | `.lensFullScreenCover(id:isPresented:)` | child views inside fullScreenCover  |
| ✅      | `fullScreenCover(item:)` | `.lensFullScreenCover(id:item:)`.   | child views inside fullScreenCover  |
| ✅      | `NavigationLink`     | `.lensButton(id:)`                      | isFocused (use SwiftLens instead of List when used inside NavigationStack)  |
| ❌      | `Popover`            | –                                       | no tracking yet                      |
| ❌      | `Alert`              | –                                       | not yet supported                    |
| ❌      | `ActionShee          | –                                       | not yet supported                    |
| ❌      | `ConfirmationDialog` | –                                       | –                                    |

You can track and simulate navigation flows. For the following NavigationStack:
```swift
struct DemoNavigationView: View {
    
    @ObservedObject var fetcher: CategoryFetcher
    
    var body: some View {
            NavigationStack {
                DemoListView(fetcher: fetcher)
                .navigationDestination(for: Category.self) { category in
                    CategoryDetailView(category: category)
                }
            }
    }
}

struct CategoryDetailView: View {
    let category: Category
    var body: some View {
        VStack {
            Text("Detail")
            Text(category.title)
        }
        .lensTracked(id: "detail.category.\(category.id)")
    }
}

struct DemoListView: View {
    
    @ObservedObject var fetcher: CategoryFetcher
    
    var body: some View {
        VStack {
            switch fetcher.state {
                case .idle:
                   LensList {
                     ForEach(fetcher.categories) { category in
                        NavigationLink(value: category) {
                             Label(category.title, systemImage: category.icon)
                        }
                        .lensButton(id: "link.category.\(category.id)")
                    }
                  }
                case .loading:
                    ProgressView()
                case .error(let string):
                    Text(string)
                        .foregroundStyle(.pink)
            }
        }
        .task {
            await fetcher.loadCategories()
        }
        .lensGroup(id: "category.list.view.\(fetcher.state.description)")
    }
}
```

You can test if the navigation link will go to the detail view:
```swift
@MainActor
@Test func testListView_in_navigationstack_when_press_category_link_then_show_detail() async throws {
    // ---- SYSTEM ----
    let service = MockFetcherService()
    let fetcher = CategoryFetcher(service: service)
    fetcher.categories = Category.allCases
    
    let sut = LensWorkBench { sut in
        DemoNavigationView(fetcher: fetcher)
    }
    
    guard let targetCategory = service.categories.first else {
        #expect(Bool(false), "No Category found")
        return
    }
    
    let buttonID = "link.category.\(targetCategory.id)"
    try await sut.observer.waitForViewVisible(withID: buttonID)
   
    // ---- WHEN ----
    sut.interactor.tapButton(withID: buttonID)
    
    // ---- THEN: detail is shown ----
    try await sut.observer.waitForViewVisible(withID: "detail.category.\(targetCategory.id)")
}
```

