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

The two views which `DatePicker` is primarily composed of, `DateInputView` and `TimeInputView`, can be used independently.


#### Date Input View

The date input view displays three pickers for selecting day, month, and year.

```swift
DateInputView(selection: $value)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/DateInputView.png?raw=true" alt="" width="198" />

The date input view uses the current locale for labeling, ordering, and populating the day-month-year pickers.

```swift
DateInputView(selection: $value)
    .environment(\.locale, Locale(identifier: "fr"))
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/DateInputView~fr.png?raw=true" alt="" width="198" />


#### Time Input View

The time input view displays a clock dial for selecting hour and minute. In locales with AM/PM-based time, AM/PM buttons will be displayed. 24-hour mode is used otherwise.

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

The 24-hour mode indicator can be hidden.

```swift
TimeInputView(selection: $value)
    .twentyFourHourMode()
    .twentyFourHourIndicator(.hidden)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/TimeInputView~24hHidden.png?raw=true" alt="" width="198" />

Setting the tint will affect the selection indicator and AM/PM buttons.

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/TimeInputView~pink.png?raw=true" alt="" width="198" />
