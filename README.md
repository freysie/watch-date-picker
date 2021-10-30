# Watch Date Picker

A customizable date picker for watchOS and SwiftUI.


## Installation

```swift
.package(url: "https://github.com/freyaariel/watch-date-picker.git", branch: "main")
```

```swift
import WatchDatePicker
```


## Overview

The `DatePicker` view displays a button with a title and the selected value. When pressed, it presents a sheet with user interfaces for selecting date and time.


### Date & Time Mode

```swift
DatePicker("Date & Time", selection: $value)
```

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Screenshots/DateAndTimeMode-1.png?raw=true" alt="" width="242" /> <img src="https://github.com/freyaariel/watch-date-picker/blob/main/Screenshots/DateAndTimeMode-2.png?raw=true" alt="" width="242" /> <img src="https://github.com/freyaariel/watch-date-picker/blob/main/Screenshots/DateAndTimeMode-3.png?raw=true" alt="" width="242" />


### Date Mode

```swift
DatePicker("Date", selection: $value, mode: .date, maximumDate: Date())
```

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Screenshots/DateMode-1.png?raw=true" alt="" width="242" /> <img src="https://github.com/freyaariel/watch-date-picker/blob/main/Screenshots/DateMode-2.png?raw=true" alt="" width="242" />


### Time Mode

```swift
DatePicker("Time", selection: $value, mode: .time, twentyFourHours: true)
```

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Screenshots/TimeMode-1.png?raw=true" alt="" width="242" /> <img src="https://github.com/freyaariel/watch-date-picker/blob/main/Screenshots/TimeMode-2.png?raw=true" alt="" width="242" />


### Outside of Lists

Both `DatePickerView` and `TimePickerView` can be used indepedently of `DatePicker`.


#### Date Picker View

```swift
DatePickerView(selection: $value)
```

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Screenshots/DatePickerView.png?raw=true" alt="" width="242" />


```swift
DatePickerView(selection: $value)
  .environment(\.locale, Locale(identifier: "fr"))
```

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Screenshots/DatePickerView~fr.png?raw=true" alt="" width="242" />


#### Time Picker View

```swift
TimePickerView(selection: $value)
```

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Screenshots/TimePickerView.png?raw=true" alt="" width="242" />


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

<img src="https://github.com/freyaariel/watch-date-picker/blob/main/Screenshots/TimePickerView~custom.png?raw=true" alt="" width="242" />


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
The radius of the date & time confirmation button.
Default is “Continue” if `mode` is `.dateAndTime`, or “Done” if `mode` is `.date`.
When `mode` is `.time` or nil, this value is ignored.

```swift
var selectionIndicatorRadius: CGFloat?
```
The radius of the time selection indicators.
Default is 2.0.
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

<!-- TODO: add more -->

