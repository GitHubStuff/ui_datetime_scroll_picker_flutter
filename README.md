# Purpose

Provides a date/time picker that uses Cupertino Scroll Widgets to set month/day/year and hour/minute/second in a small sized widget (optimal size is 230w X 250h)

<!--
The comments below are from the Flutter/Dart package generation. Feel free to use or ignore
-->

<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

## Features

Uses less space then other widgets.

## Getting started

```yaml
dependencies:
  ui_datetime_scroll_picker_flutter:
    git: https://github.com/GitHubStuff/ui_datetime_scroll_picker_flutter.git
```

## Usage

```dart
UIDateTimePicker(
    onDateTimeSelected: (dateTime) => debugPrint(dateTime.toIso8601String())),
```

## Widget declaration

```dart
UIDateTimePicker({
    super.key,
    required this.onDateTimeSelected,
    DateTime? dateTime,
    DateFormat? dateFormat,
    this.pickerTextStyle = _kPickerTextStyle,
    this.titleTextStyle = _kTitleTextStyle,
    this.datePickerColor = _kDatePickerColor,
    this.dateText = _kDateButtonText,
    this.headerColor = _kHeaderColor,
    this.acceptButton = const AquaButton(
      mainRadius: 22.0,
      materialColor: Colors.green,
    ),
    this.showFirstWidget = true,
    this.size = _kDefaultSize,
    this.textColor = _kTextColor,
    this.timePickerColor = _kTimePickerColor,
    this.timeText = _kTimeButtonText,
  })  : dateTime = dateTime ?? DateTime.now(),
        dateFormat = dateFormat ?? _kDateFormat;
```

## Finally

Be kind to each other!
