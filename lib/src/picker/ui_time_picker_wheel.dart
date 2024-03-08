import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';

const int _midnight = 0;
const int _minutesInHour = 60;
const int _noon = 12;

/// Internally, hour goes from 0 to 23, so we use 12 to represent 12:00 PM
/// and 0 to represent 12:00 AM
const int _normalizedHour = 12;
const int _secondsInMinute = 60;

/// To 'mimic' a large scrollwheel, we multiply the number of items by 5
/// and set the initial item to the middle of the list.
/// This is to allow the user to [fake] scroll in either direction without
/// reaching the end of the list.
const int _wrapping = 5;

enum Meridian {
  am('AM'),
  pm('PM');

  final String label;
  const Meridian(this.label);
}

enum TimePickerItem {
  hour,
  minute,
  second,
  meridian;
}

extension TimePickerNum on DateTime {
  Meridian get meridian => hour < _noon ? Meridian.am : Meridian.pm;
}

class UITimePickerWheel extends StatefulWidget {
  final DateTime dateTime;
  final Function(DateTime) onTimeSelected;
  final Color? backgroundColor;
  final double pickerItemExtent;
  final TextStyle? textStyle;

  const UITimePickerWheel({
    super.key,
    required this.dateTime,
    required this.onTimeSelected,
    this.backgroundColor,
    this.pickerItemExtent = 30.0,
    this.textStyle,
  });

  @override
  State<UITimePickerWheel> createState() => _UITimePickerWheel();
}

class _UITimePickerWheel extends State<UITimePickerWheel> {
  late int selectedHour;
  late int selectedMinute;
  late int selectedSecond;
  late Meridian selectedMeridian;
  late Color? backgroundColor;
  late TextStyle? textStyle;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController secondController;
  late FixedExtentScrollController meridianController;
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    backgroundColor = widget.backgroundColor;
    textStyle = widget.textStyle;
    dateTime = widget.dateTime;
    selectedHour = meridianHour(dateTime.hour, dateTime.meridian);
    selectedMinute = dateTime.minute;
    selectedSecond = dateTime.second;
    selectedMeridian = dateTime.meridian;

    /// Set the initial item to the middle of the list
    hourController = FixedExtentScrollController(
      initialItem: selectedHour + (_normalizedHour * (_wrapping ~/ 2)),
    );
    minuteController = FixedExtentScrollController(
      initialItem: selectedMinute + (_minutesInHour * (_wrapping ~/ 2)),
    );
    secondController = FixedExtentScrollController(
      initialItem: selectedSecond + (_secondsInMinute * (_wrapping ~/ 2)),
    );
    meridianController = FixedExtentScrollController(
      initialItem: selectedMeridian.index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: hourPicker()),
          Text(':', style: textStyle),
          Expanded(child: minutePicker()),
          Text(':', style: textStyle),
          Expanded(child: secondPicker()),
          Expanded(child: meridianPicker()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    meridianController.dispose();
    super.dispose();
  }

  Widget hourPicker() => buildNumberPicker(
        TimePickerItem.hour,
        hourController,
        _normalizedHour * _wrapping,
        selectedHour,
        (hour) {
          setState(() => selectedHour = meridianHour(hour, selectedMeridian));
          updateDateTime();
        },
      );

  Widget minutePicker() => buildNumberPicker(
        TimePickerItem.minute,
        minuteController,
        _minutesInHour * _wrapping,
        selectedMinute,
        (minute) {
          setState(() => selectedMinute = minute % _minutesInHour);
          updateDateTime();
        },
      );

  Widget secondPicker() => buildNumberPicker(
        TimePickerItem.second,
        secondController,
        _secondsInMinute * _wrapping,
        selectedSecond,
        (second) {
          setState(() => selectedSecond = second % _secondsInMinute);
          updateDateTime();
        },
      );

  Widget meridianPicker() => buildNumberPicker(
        TimePickerItem.meridian,
        meridianController,
        Meridian.values.length,
        selectedMeridian.index,
        (meridian) {
          setState(() {
            selectedMeridian = Meridian.values[meridian];
            selectedHour = meridianHour(selectedHour, selectedMeridian);
          });
          updateDateTime();
        },
      );

  Widget buildNumberPicker(
    TimePickerItem item,
    FixedExtentScrollController scrollController,
    int maxValue,
    int value,
    Function(int) onChanged,
  ) {
    return CupertinoPicker(
      itemExtent: widget.pickerItemExtent,
      onSelectedItemChanged: (int index) => onChanged(index),
      selectionOverlay: null,
      scrollController: scrollController,
      children: List<Widget>.generate(
        maxValue,
        (int index) {
          switch (item) {
            case TimePickerItem.hour:
              final hour = (index % _normalizedHour) == _midnight
                  ? _normalizedHour // 12:00 AM
                  : (index % _normalizedHour);
              return Center(
                child: AutoSizeText(
                  hour.toString(),
                  style: textStyle,
                ),
              );
            case TimePickerItem.minute:
            // _secondsInMinute == _minutesInHour
            case TimePickerItem.second:
              return Center(
                child: AutoSizeText(
                  (index % _secondsInMinute).toString().padLeft(2, '0'),
                  style: textStyle,
                ),
              );
            case TimePickerItem.meridian:
              return Center(
                child: AutoSizeText(
                  Meridian.values[index].label,
                  style: textStyle,
                ),
              );
          }
        },
      ),
    );
  }

  int meridianHour(int hour, Meridian meridian) => (meridian == Meridian.am)
      ? (hour % _normalizedHour)
      : (hour % _normalizedHour) + _noon;

  void updateDateTime() {
    final updatedDateTime = DateTime(
      widget.dateTime.year,
      widget.dateTime.month,
      widget.dateTime.day,
      selectedHour,
      selectedMinute,
      selectedSecond,
    );
    if (dateTime != updatedDateTime) {
      widget.onTimeSelected(updatedDateTime);
    }
    dateTime = updatedDateTime;
  }
}
