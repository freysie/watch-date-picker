# Watch Date Picker

A customizable date picker for watchOS and SwiftUI.


## Installation

```swift
.package(url: "https://github.com/freyaariel/watch-date-picker.git", from: "0.1.0")
```

```swift
import WatchDatePicker
```


## Documentation

Online documentation is available at [freyaariel.github.io/documentation/watchdatepicker](https://freyaariel.github.io/documentation/watchdatepicker/).


## Overview

The `DatePicker` view displays a button with a title and the selected value. When pressed, it presents a sheet with user interfaces for selecting date and time.


### Date & Time Mode

```swift
DatePicker("Date & Time", selection: $value)
```

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/DateAndTimeMode.png?raw=true" alt="" width="594" />


### Date Mode

```swift
DatePicker("Date", selection: $value, displayedComponents: [.date])
```

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/DateMode.png?raw=true" alt="" width="396" />


### Time Mode

```swift
DatePicker("Time", selection: $value, displayedComponents: [.hourAndMinute])
```

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/TimeMode.png?raw=true" alt="" width="396" />


### Outside of Lists

Both `DatePickerView` and `TimePickerView` can be used independently of `DatePicker`.


#### Date Picker View

```swift
DatePickerView(selection: $value)
```

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/DatePickerView.png?raw=true" alt="" width="198" />


```swift
DatePickerView(selection: $value)
  .environment(\.locale, Locale(identifier: "fr"))
```

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/DatePickerView~fr.png?raw=true" alt="" width="198" />


#### Time Picker View

```swift
TimePickerView(selection: $value)
```

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/TimePickerView.png?raw=true" alt="" width="198" />


```swift
TimePickerView(selection: $value)
  .datePickerShowsMonthBeforeDay(true)
  .datePickerConfirmationTitle("Select Time")
  .datePickerConfirmationTint(.pink)
  .datePickerFocusTint(.purple)
  .datePickerAMPMHighlightTint(.red)
  .datePickerMark { Circle() }
  .datePickerHeavyMark { Rectangle() }
  .datePickerSelectionIndicator { Circle().size(width: 7, height: 7).fill(.mint) }
  .datePickerTwentyFourHour(true)
  .datePickerTwentyFourHourIndicator(.hidden)
```
<!--  selectionIndicatorRadius: 7,-->
<!--  selectionIndicatorColor: .mint,-->
<!--  focusColor: .purple,-->
<!--  amPMHighlightColor: .yellow,-->
<!--  markSize: CGSize(width: 5.5, height: 3),-->
<!--  markFill: AnyShapeStyle(Color.white.opacity(0.75)),-->
<!--  emphasizedMarkSize: CGSize(width: 2, height: 7),-->
<!--  emphasizedMarkFill: AnyShapeStyle(Color.pink)-->

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/TimePickerView~custom.png?raw=true" alt="" width="198" />

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
