# Watch Date Picker

A customizable date picker for watchOS and SwiftUI.


## Installation

Add the https://github.com/freysie/watch-date-picker package, then add the _WatchDatePicker_ product to your app’s WatchKit extension target.

<!---->
<!--## Documentation-->
<!---->
<!--Online documentation is available at [freysie.github.io/documentation/watchdatepicker](https://freysie.github.io/documentation/watchdatepicker/).-->
<!---->

## Overview

The `DatePicker` view displays a button with a title and the selected value. When pressed, it presents a user interface for selecting date, time, or both.

Watch Date Picker is designed to look and feel similar to the system’s date and time pickers, seen in apps such as Alarms, Calendar, and Reminders, with an API matching SwiftUI’s built-in `DatePicker`.


### Selecting Date and Time

```swift
DatePicker(
    "Date & Time",
    selection: $value
)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/DatePicker.png?raw=true" alt="" width="602" />


### Selecting a Date

```swift
DatePicker(
    "Date",
    selection: $value,
    displayedComponents: .date
)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/DatePicker_date.png?raw=true" alt="" width="400" />


### Selecting a Time

```swift
DatePicker(
    "Time",
    selection: $value,
    displayedComponents: .hourAndMinute
)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/DatePicker_hourAndMinute.png?raw=true" alt="" width="400" />


### Customization

`DateInputView` and `TimeInputView`, the two views which `DatePicker` is primarily composed of, can be used on their own.


#### Date Input View

The date input view displays three pickers for selecting day, month, and year.

```swift
DateInputView(selection: $value)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/DateInputView.png?raw=true" alt="" width="195" />

The date input view uses the current locale for labeling and ordering the day-month-year pickers.

```swift
DateInputView(selection: $value)
    .environment(\.locale, Locale(identifier: "fr"))
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/DateInputView_fr.png?raw=true" alt="" width="195" />


#### Time Input View

The time input view displays a clock dial for selecting hour and minute. In locales with AM/PM-based time, AM/PM buttons will be displayed, otherwise 24-hour mode is used.

```swift
TimeInputView(selection: $value)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/TimeInputView.png?raw=true" alt="" width="190.5" />

<!--The tint of the selection indicator and AM/PM buttons can be set using `tint()`. The following example shows a time input view with a pink tint.-->
<!---->
<!--```swift-->
<!--TimeInputView(selection: $value)-->
<!--    .tint(.pink)-->
<!--```-->
<!---->
<!--<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/TimeInputView_pink.png?raw=true" alt="" width="190.5" />-->

24-hour mode can be explicitly enabled or disabled regardless of locale.

```swift
TimeInputView(selection: $value)
    .timeInputViewTwentyFourHourMode()

TimeInputView(selection: $value)
    .timeInputViewTwentyFourHourMode(false)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/TimeInputView_24hr.png?raw=true" alt="" width="190.5" />

The 24-hour mode indicator can be hidden.

```swift
TimeInputView(selection: $value)
    .timeInputViewTwentyFourHourMode()
    .timeInputViewTwentyFourHourIndicator(.hidden)
```

<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/TimeInputView_24hrHidden.png?raw=true" alt="" width="190.5" />

<!--Setting the tint will affect the selection indicator and AM/PM buttons.-->
<!---->
<!--```swift-->
<!--TimeInputView(selection: $value)-->
<!--    .tint(.pink)-->
<!--```-->

<!--<img src="/Sources/WatchDatePicker/Documentation.docc/Resources/TimeInputView_pink.png?raw=true" alt="" width="190.5" />-->

See the documentation for more options.


## Localization

Watch Date Picker works in all languages supported by watchOS: Arabic, Bulgarian, Catalan, Chinese (Simplified), Chinese (Traditional), Croatian, Czech, Danish, Dutch, English, Finnish, French, German, Greek, Hebrew, Hindi, Hungarian, Indonesian, Italian, Japanese, Kazakh, Korean, Malay, Norwegian, Polish, Portuguese (Brazil), Portuguese (Portugal), Romanian, Russian, Slovak, Spanish, Spanish (Latin America), Swedish, Thai, Turkish, Ukrainian, and Vietnamese.

Translations are based on Apple’s glossaries, thus they should feel at home in each locale. 

A script is run to take [screenshots for every locale and screen size](https://freysie.github.io/watch-date-picker-qa/) to ensure everything renders correctly.

