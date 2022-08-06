# Watch Date Picker

A customizable date picker for watchOS and SwiftUI.

| 🚧 | The next version of Watch Date Picker is under development. It will align the API to that of the standard SwiftUI date picker, and it will update the visual appearance to more closely match the system’s date picker. | &nbsp;&nbsp;&nbsp;&nbsp;[VIEW&nbsp;BRANCH](https://github.com/freyaalminde/watch-date-picker/tree/feature/improved-api)&nbsp;&nbsp;&nbsp;&nbsp; |
| - |:-| - |


## Installation

Add the https://github.com/freyaalminde/watch-date-picker package, then add the _WatchDatePicker_ product to your app’s WatchKit extension target.


## Documentation

Online documentation is available at [freyaalminde.github.io/documentation/watchdatepicker](https://freyaalminde.github.io/documentation/watchdatepicker/).


## Overview

The `DatePicker` view displays a button with a title and the selected value. When pressed, it presents a sheet with user interfaces for selecting date and time.


### Date & Time Mode

```swift
DatePicker("Date & Time", selection: $value)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/DateAndTimeMode.png?raw=true" alt="" width="594" />


### Date Mode

```swift
DatePicker("Date", selection: $value, mode: .date, maximumDate: Date())
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/DateMode.png?raw=true" alt="" width="396" />


### Time Mode

```swift
DatePicker("Time", selection: $value, mode: .time, twentyFourHours: true)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/TimeMode.png?raw=true" alt="" width="396" />


### Outside of Lists

Both `DatePickerView` and `TimePickerView` can be used independently of `DatePicker`.


#### Date Picker View

```swift
DatePickerView(selection: $value)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/DatePickerView.png?raw=true" alt="" width="198" />


```swift
DatePickerView(selection: $value)
  .environment(\.locale, Locale(identifier: "fr"))
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/DatePickerView~fr.png?raw=true" alt="" width="198" />


#### Time Picker View

```swift
TimePickerView(selection: $value)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/TimePickerView.png?raw=true" alt="" width="198" />


```swift
TimePickerView(
  selection: $value,
  selectionIndicatorRadius: 7,
  selectionIndicatorColor: .mint,
  focusColor: .purple,
  amPMHighlightColor: .yellow,
  markSize: CGSize(width: 5.5, height: 3),
  markFill: AnyShapeStyle(Color.white.opacity(0.75)),
  emphasizedMarkSize: CGSize(width: 2, height: 7),
  emphasizedMarkFill: AnyShapeStyle(Color.pink)
)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/TimePickerView~custom.png?raw=true" alt="" width="198" />

<!--

**ℹ️ Note:**

The API exposed by `WatchDatePicker` is different from that of SwiftUI’s built-in date picker. When sharing code between multiple platforms, `#if os(watchOS)`, target memberships, or namespaces can be used to disambiguate.


## Topics

### Setting Date Picker Mode

```swift
var mode: DatePicker.Mode
```
Mode that determines the appearance of a date picker. Default is `.dateAndTime`.


### Customizing Appearance

```swift
var confirmationColor: Color? 
```
The color for the date & time confirmation button.
Default is `.green`.
When `mode` is not `.dateAndTime`, this value is ignored.

```swift
var confirmationTitleKey: LocalizedStringKey?
```
The title of the date & time confirmation button.
Default is “Continue” if `mode` is `.dateAndTime`, or “Done” if `mode` is `.date`.
When `mode` is `.time` or nil, this value is ignored.

```swift
var selectionIndicatorRadius: CGFloat?
```
The radius of the time selection indicators.
Default is 2.25.
When `mode` is `.date`, this value is ignored.

```swift
var selectionIndicatorColor: Color?
```
The color for the time selection indicators.
Default is `.accentColor`.
When `mode` is `.date`, this value is ignored.

```swift
var focusColor: Color?
```
The color for the focus outline of time fields.
Default is `.green`.

-->

<!-- TODO: add more -->
