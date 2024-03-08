import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui_aqua_button_flutter/ui_aqua_button_flutter.dart';
import 'package:ui_extensions_flutter/ui_extensions_flutter.dart';
import 'package:ui_marquee_flutter/ui_marguee_flutter.dart';

import '../picker/ui_date_picker_wheel.dart';
import '../picker/ui_time_picker_wheel.dart';

part '../picker/date_time_caption.dart'; // Part file containing the DateTimeCaption class

const Size kDateTimePickerSize = Size(230, 250);

// Constants for colors, dimensions, and durations
const Color _kDatePickerColor = Colors.black;
const Color _kHeaderColor = Color.fromARGB(255, 14, 29, 97);
const Color _kTextColor = Color(0xffffd600);
const Color _kTimePickerColor = Color.fromARGB(255, 14, 4, 100);
const double _kItemExtent = 30.0;
const Duration _kCrossFadeDuration = Duration(milliseconds: 500);
const TextStyle _kPickerTextStyle = TextStyle(color: _kTextColor);
const TextStyle _kTitleTextStyle =
    TextStyle(fontWeight: FontWeight.bold, color: _kTextColor);
const Widget _kDateButtonText = DateTimeCaption(caption: 'Date');
const Widget _kTimeButtonText = DateTimeCaption(caption: 'Time');
final DateFormat _kDateFormat = DateFormat('EEE, MMM d, y h:mm:ss a');

// Enum for Opacity values
enum OpacityEnum {
  show(1.0),
  hide(0.0);

  final double value;

  const OpacityEnum(this.value);
}

/// A Flutter widget for selecting date and time.
class UIDateTimePicker extends StatefulWidget {
  // Constructor for UICalendarFlutter
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
    this.size = kDateTimePickerSize,
    this.textColor = _kTextColor,
    this.timePickerColor = _kTimePickerColor,
    this.timeText = _kTimeButtonText,
  })  : dateTime = dateTime ?? DateTime.now(),
        dateFormat = dateFormat ?? _kDateFormat;

  // Properties of the UICalendarFlutter widget
  final DateTime dateTime;
  final Function(DateTime) onDateTimeSelected;
  final bool showFirstWidget;
  final Color datePickerColor;
  final Color headerColor;
  final Color textColor;
  final Color timePickerColor;
  final DateFormat dateFormat;
  final Size size;
  final TextStyle pickerTextStyle;
  final TextStyle titleTextStyle;
  final Widget dateText;
  final Widget acceptButton;
  final Widget timeText;

  @override
  State<UIDateTimePicker> createState() => _UIDateTimePicker();
}

/// State class for UICalendarFlutter widget.
class _UIDateTimePicker extends State<UIDateTimePicker> {
  late DateTime dateTime;
  late bool showFirstWidget;

  @override
  void initState() {
    super.initState();
    // Initialize dateTime and showFirstWidget variables
    dateTime = widget.dateTime.copyWith(
      year: widget.dateTime.year,
      month: widget.dateTime.month,
      day: widget.dateTime.day,
      hour: widget.dateTime.hour,
      minute: widget.dateTime.minute,
      second: widget.dateTime.second,
      millisecond: 0,
      microsecond: 0,
    );
    showFirstWidget = widget.showFirstWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Prevents the height from being zero which throws sizing error
      height: max(widget.size.height, 0.00000000001),
      width: widget.size.width,
      color: Colors.transparent,
      child: _column(), //pickers(context),
    );
  }

  Widget _column() {
    return Column(
      children: [
        Flexible(flex: 4, child: _buildTitle()),
        Flexible(flex: 4, child: _buildDateTimeSelectionButtons()),
        Expanded(flex: 8, child: _buildPickerWheels()),
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      color: widget.headerColor,
      height: 44.0,
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: UIMarqueeWidget(
              message: widget.dateFormat.format(dateTime),
              rolloverPercentage: 0.85,
              pauseDuration: const Duration(milliseconds: 10),
              scrollVelocityInPixelsPerSecond: 30.0,
              textStyle: widget.titleTextStyle.copyWith(fontSize: 20),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () => widget.onDateTimeSelected(dateTime),
              child: widget.acceptButton,
            ).padding(left: 0.0, top: 4.0, bottom: 4.0),
          ),
        ],
      ).paddingAll(3.0),
    );
  }

  Widget _buildDateTimeSelectionButtons() {
    return SizedBox(
      height: 44.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => showFirstWidget = true),
              child: Container(
                color: widget.datePickerColor,
                child: Center(child: widget.dateText),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => showFirstWidget = false),
              child: Container(
                color: _kTimePickerColor,
                child: Center(child: widget.timeText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerWheels() {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: !showFirstWidget,
          child: AnimatedOpacity(
            opacity: showFirstWidget
                ? OpacityEnum.show.value
                : OpacityEnum.hide.value,
            duration: _kCrossFadeDuration,
            child: UIDatePickerWheel(
              dateTime: dateTime,
              backgroundColor: widget.datePickerColor,
              pickerItemExtent: _kItemExtent,
              textStyle: widget.pickerTextStyle,
              onDateSelected: (DateTime newDateTime) {
                setState(
                  () => dateTime = dateTime.copyWith(
                    year: newDateTime.year,
                    month: newDateTime.month,
                    day: newDateTime.day,
                    hour: dateTime.hour,
                    minute: dateTime.minute,
                    second: dateTime.second,
                  ),
                );
              },
            ),
          ),
        ),
        IgnorePointer(
          ignoring: showFirstWidget,
          child: AnimatedOpacity(
            opacity: showFirstWidget
                ? OpacityEnum.hide.value
                : OpacityEnum.show.value,
            duration: _kCrossFadeDuration,
            child: UITimePickerWheel(
              dateTime: dateTime,
              backgroundColor: widget.timePickerColor,
              textStyle: widget.pickerTextStyle,
              onTimeSelected: (DateTime newDateTime) {
                setState(
                  () => dateTime = dateTime.copyWith(
                    year: dateTime.year,
                    month: dateTime.month,
                    day: dateTime.day,
                    hour: newDateTime.hour,
                    minute: newDateTime.minute,
                    second: newDateTime.second,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
