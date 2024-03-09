import 'package:dart_datetime/dart_datetime.dart';
import 'package:flutter/material.dart';

class UISelectDateTimeUnit extends StatefulWidget {
  final DateTimeUnit initialUnit;
  final Function(DateTimeUnit) onChanged;
  final bool showMillsecond;
  final bool showMicroSecond;

  const UISelectDateTimeUnit({
    super.key,
    required this.initialUnit,
    required this.onChanged,
    this.showMillsecond = false,
    this.showMicroSecond = false,
  });

  @override
  State<UISelectDateTimeUnit> createState() => _UISelectDateTimeUnit();
}

class _UISelectDateTimeUnit extends State<UISelectDateTimeUnit> {
  late DateTimeUnit selectedValue;
  late bool showMillisecond;
  late bool showMicroSecond;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialUnit;
    showMicroSecond = widget.showMicroSecond;
    showMillisecond = showMicroSecond || widget.showMillsecond;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              radioButton(DateTimeUnit.year),
              radioButton(DateTimeUnit.month),
              radioButton(DateTimeUnit.day),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              radioButton(DateTimeUnit.hour),
              radioButton(DateTimeUnit.minute),
              radioButton(DateTimeUnit.second),
            ],
          ),
          if (showMicroSecond || showMillisecond)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (showMillisecond) radioButton(DateTimeUnit.msec),
                if (showMicroSecond) radioButton(DateTimeUnit.usec),
                Expanded(child: Container()),
              ],
            ),
        ],
      ),
    );
  }

  Widget radioButton(DateTimeUnit value) {
    return Flexible(
      child: InkWell(
        onTap: () => setSelectedValue(value),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Radio<String>(
              value: value.label,
              groupValue: selectedValue.label,
              onChanged: (value) =>
                  setSelectedValue(CaptilizeDateTimeUnit.from(value!)),
            ),
            Flexible(
                child: Text(
              value.label,
              overflow: TextOverflow.ellipsis,
            ))
          ],
        ),
      ),
    );
  }

  void setSelectedValue(DateTimeUnit value) {
    setState(() {
      selectedValue = value;
      widget.onChanged(value);
    });
  }
}

extension CaptilizeDateTimeUnit on DateTimeUnit {
  String get label => name[0].toUpperCase() + name.substring(1);
  static DateTimeUnit from(String string) {
    for (DateTimeUnit unit in DateTimeUnit.values) {
      if (unit.name.toLowerCase() == string.toLowerCase()) return unit;
    }
    throw ArgumentError('Invalid DateTimeUnit $string');
  }
}
