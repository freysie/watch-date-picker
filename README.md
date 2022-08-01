# Watch Date Picker

A customizable date picker for watchOS and SwiftUI.


## Installation

Add the https://github.com/freyaalminde/watch-date-picker package, then add the _WatchDatePicker_ product to your app’s WatchKit extension target.


## Documentation

Online documentation is available at [freyaalminde.github.io/documentation/watchdatepicker](https://freyaalminde.github.io/documentation/watchdatepicker/).


## Overview

The `DatePicker` view displays a button with a title and the selected value. When pressed, it presents a sheet with user interfaces for selecting date and time.


### Selecting Date and Time

```swift
DatePicker(
  "Date & Time",
  selection: $value
)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/DateAndTimeMode.png?raw=true" alt="" width="594" />


### Selecting a Date

```swift
DatePicker(
  "Date",
  selection: $value,
  displayedComponents: .date
)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/DateMode.png?raw=true" alt="" width="396" />


### Selecting a Time

```swift
DatePicker(
  "Time",
  selection: $value,
  displayedComponents: .hourAndMinute
)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/Screenshots/TimeMode.png?raw=true" alt="" width="396" />


### Customization

The two main views which `DatePicker` is composed of, `DateInputView` and `TimeInputView`, can be used independently.


#### Date Input View

The date input view displays three pickers for selecting day, month, and year.

```swift
DateInputView(selection: $value)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/DateInputView.png?raw=true" alt="" width="198" />

The date input view uses the current locale for labeling, ordering, and populating the date component pickers.

```swift
DateInputView(selection: $value)
    .environment(\.locale, Locale(identifier: "fr"))
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/DateInputView~fr.png?raw=true" alt="" width="198" />


#### Time Input View

The time input view displays a clock dial for selecting hour and minute. In locales with AM/PM-based time, AM/PM buttons will be displayed. 

```swift
TimeInputView(selection: $value)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/TimeInputView.png?raw=true" alt="" width="198" />

<!--The tint of the selection indicator and AM/PM buttons can be set using `tint()`. The following example shows a time input view with a pink tint.-->
<!---->
<!--```swift-->
<!--TimeInputView(selection: $value)-->
<!--    .tint(.pink)-->
<!--```-->
<!---->
<!--<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/TimeInputView~pink.png?raw=true" alt="" width="198" />-->

24-hour mode can be explicitly enabled or disabled regardless of locale.

```swift
TimeInputView(selection: $value)
    .twentyFourHourMode()
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/TimeInputView~24h.png?raw=true" alt="" width="198" />

The 24-hour mode indicator can optionally be hidden.

```swift
TimeInputView(selection: $value)
    .twentyFourHourMode()
    .twentyFourHourIndicator(.hidden)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/TimeInputView~24hHidden.png?raw=true" alt="" width="198" />

<!--```swift-->
<!--TimeInputView(selection: $value)-->
<!--    .tint(.pink)-->
<!--    .monthBeforeDay(true)-->
<!--    .twentyFourHourMode(true)-->
<!--    .twentyFourHourIndicator(.hidden)-->
<!--```-->
<!--    // .confirmationTint(.pink)-->
<!--  selectionIndicatorRadius: 7,-->
<!--  selectionIndicatorColor: .mint,-->
<!--  focusColor: .purple,-->
<!--  amPMHighlightColor: .yellow,-->
<!--  markSize: CGSize(width: 5.5, height: 3),-->
<!--  markFill: AnyShapeStyle(Color.white.opacity(0.75)),-->
<!--  emphasizedMarkSize: CGSize(width: 2, height: 7),-->
<!--  emphasizedMarkFill: AnyShapeStyle(Color.pink)-->

<!--<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/TimeInputView~custom.png?raw=true" alt="" width="198" />-->

<!--

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
