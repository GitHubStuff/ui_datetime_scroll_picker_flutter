import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';

const _wrapping = 3;
const _minYear = 1200;
const _maxYear = 2200;
const List<String> _monthAbbr = [
  'JAN',
  'FEB',
  'MAR',
  'APR',
  'MAY',
  'JUN',
  'JUL',
  'AUG',
  'SEP',
  'OCT',
  'NOV',
  'DEC',
];

enum DatePickerItem { year, month, day }

/// This class represents a custom date picker wheel widget for selecting dates.
class UIDatePickerWheel extends StatefulWidget {
  /// The current date time value.
  final DateTime dateTime;

  /// Callback function triggered when a date is selected.
  final Function(DateTime) onDateSelected;

  /// Background color of the picker.
  final Color? backgroundColor;

  /// Height of each picker item.
  final double pickerItemExtent;

  /// Text style for the picker items.
  final TextStyle? textStyle;

  /// List of month abbreviations.
  final List<String> months;

  /// Constructor for UIDatePickerWheel.
  const UIDatePickerWheel({
    super.key,
    required this.dateTime,
    required this.onDateSelected,
    this.backgroundColor,
    this.months = _monthAbbr,
    this.pickerItemExtent = 30.0,
    this.textStyle,
  });

  @override
  State<UIDatePickerWheel> createState() => _UIDatePickerWheel();
}

/// This class represents the state of the UIDatePickerWheel.
class _UIDatePickerWheel extends State<UIDatePickerWheel> {
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;
  late Color? backgroundColor;
  late TextStyle? textStyle;
  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController dayController;
  late DateTime previousDateTime;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.dateTime.year;
    selectedMonth = widget.dateTime.month;
    selectedDay = widget.dateTime.day;
    previousDateTime = widget.dateTime;
    backgroundColor = widget.backgroundColor;
    textStyle = widget.textStyle;
    yearController = FixedExtentScrollController(
      initialItem: selectedYear - _minYear,
    );
    monthController = FixedExtentScrollController(
      initialItem: selectedMonth + DateTime.monthsPerYear - 1,
    );
    dayController = FixedExtentScrollController(
      initialItem:
          selectedDay - 1 + getMaxDaysInMonth(selectedYear, selectedMonth),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
        color: backgroundColor,
        child: Row(
          children: [
            Expanded(child: monthPicker()),
            Expanded(child: dayPicker()),
            Expanded(child: yearPicker())
          ],
        ),
      );

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  /// Builds the month picker widget.
  Widget monthPicker() => buildNumberPicker(
        DatePickerItem.month,
        monthController,
        1,
        DateTime.monthsPerYear * _wrapping + 1,
        selectedMonth,
        (month) {
          while (month > DateTime.monthsPerYear) {
            month -= DateTime.monthsPerYear;
          }
          final maxDays = getMaxDaysInMonth(selectedYear, month);
          setState(() {
            selectedDay = min(selectedDay, maxDays);
            selectedMonth = month;
            dayController.jumpToItem(selectedDay - 1 + maxDays);
          });
          updateDateTime();
        },
      );

  /// Builds the day picker widget.
  Widget dayPicker() => buildNumberPicker(
        DatePickerItem.day,
        dayController,
        1,
        getMaxDaysInMonth(selectedYear, selectedMonth) * _wrapping,
        selectedDay,
        (day) {
          final maxDays = getMaxDaysInMonth(selectedYear, selectedMonth);
          selectedDay = ((day - 1) % maxDays + 1);
          updateDateTime();
        },
      );

  /// Builds the year picker widget.
  Widget yearPicker() => buildNumberPicker(
        DatePickerItem.year,
        yearController,
        _minYear,
        _maxYear,
        selectedYear,
        (year) {
          final maxDays = getMaxDaysInMonth(year, selectedMonth);
          setState(() {
            selectedDay = min<int>(selectedDay, maxDays);
            selectedYear = year;
            dayController.jumpToItem(selectedDay - 1 + maxDays);
          });
          updateDateTime();
        },
      );

  /// Builds the number picker widget.
  Widget buildNumberPicker(
    DatePickerItem item,
    FixedExtentScrollController scrollController,
    int minValue,
    int maxValue,
    int value,
    Function(int) onChanged,
  ) {
    return CupertinoPicker(
      itemExtent: widget.pickerItemExtent,
      onSelectedItemChanged: (int index) => onChanged(index + minValue),
      selectionOverlay: null,
      scrollController: scrollController,
      children: List<Widget>.generate(
        maxValue - minValue,
        (int index) {
          final currentIndex = index + minValue;
          switch (item) {
            case DatePickerItem.year:
              return Center(
                child: AutoSizeText(
                  currentIndex.toString(),
                  style: textStyle,
                ),
              );
            case DatePickerItem.month:
              return Center(
                child: AutoSizeText(
                  widget.months[(currentIndex - 1) % DateTime.monthsPerYear],
                  style: textStyle,
                ),
              );
            case DatePickerItem.day:
              return Center(
                child: AutoSizeText(
                  ((index) % (maxValue ~/ _wrapping) + 1).toString(),
                  style: textStyle,
                ),
              );
          }
        },
      ),
    );
  }

  /// Gets the maximum days in a month for a given year and month.
  int getMaxDaysInMonth(int year, int month) => DateTime(
        year,
        (month % DateTime.monthsPerYear) + 1,
        0,
      ).day;

  /// Updates the selected date time.
  void updateDateTime() {
    final updatedDateTime = DateTime(
      selectedYear,
      selectedMonth,
      selectedDay,
    );
    if (previousDateTime != updatedDateTime) {
      widget.onDateSelected(updatedDateTime);
    }
    previousDateTime = updatedDateTime;
  }
}
