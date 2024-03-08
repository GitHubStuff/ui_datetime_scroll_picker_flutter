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

### pubspec.yaml

```yaml
dependencies:
  ui_datetime_scroll_picker_flutter:
    git: https://github.com/GitHubStuff/ui_datetime_scroll_picker_flutter.git
```

### .dart files

```dart
import 'package:ui_datetime_scroll_picker_flutter/ui_datetime_scroll_picker_flutter.dart';
```

## Usage

There are three was to utilize this package:

1 - To have the DateTime Picker appears as an overlay, use **dateTimeOverlayRoute**:

```dart
TextButton(
          key: globalKey,
          onPressed: () async {
            final dateTime = await Navigator.of(context).push(
              dateTimeOverlayRoute<DateTime?>(
                globalKey: globalKey,
                dateTime: DateTime.now(),
                offset: const Offset(0, -180),
              ),
            );
            if (dateTime != null) {
              setState(() => content = dateTime.toIso8601String());
            }
          },
          child: Text(content),
        )
```

2 - Call **UIDateTime** directly:

```dart
          UIDateTimePicker(
              onDateTimeSelected: (dateTime) =>
                  debugPrint(dateTime.toIso8601String()))
```

3 - Call **UIDateTimePrompt** :

```dart
UIDateTimePrompt(
          key: gKey,
          initialDateTime: DateTime.now(),
          onSelected: (dateTime) {
            setState(() {
              final str = dateTime?.toIso8601String() ?? 'No Date Selected';
              prompt = Text(str, style: const TextStyle(fontSize: 21));
            });
          },
          promptWidget: prompt,
        )
```

## Widget declaration

PageRouteBuilder:

```dart
PageRouteBuilder dateTimeOverlayRoute<T>({
  required GlobalKey globalKey,
  DateTime? dateTime,
  Offset offset = const Offset(0, 0),
})
```

UIDateTimePicker

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

UIDateTimePrompt

```dart
class UIDateTimePrompt extends StatefulWidget {
  late final DateTime? initialDateTime;
  final Function()? onDoubleTap;
  final Function(DateTime?) onSelected;
  final Offset offset;
  final Widget promptWidget;
```

## Example

The ***/example*** folder has examples for all methods.

## Finally

Be kind to each other!
