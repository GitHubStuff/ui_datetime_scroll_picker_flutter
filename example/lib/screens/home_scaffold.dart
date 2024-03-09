// ignore_for_file: sort_child_properties_last

import 'package:dart_datetime/dart_datetime.dart';
import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

import 'package:ui_datetime_scroll_picker_flutter/ui_datetime_scroll_picker_flutter.dart';

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeWidget(context),
      floatingActionButton: null,
    );
  }

  Widget homeWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Assets.images.clockCalendar.image(),
            ),
          ),
          const SizedBox(height: 10),
          UIDateTimePicker(
              onDateTimeSelected: (dateTime) =>
                  debugPrint(dateTime.toIso8601String())),
          const SizedBox(height: 10),
          const SampleDateTimeWidget(),
          const SizedBox(height: 10),
          UISelectDateTimeUnit(
            initialUnit: DateTimeUnit.year,
            onChanged: (unit) => debugPrint(unit.toString()),
          ),
        ],
      ),
    );
  }
}

class SampleDateTimeWidget extends StatefulWidget {
  const SampleDateTimeWidget({super.key});

  @override
  State<SampleDateTimeWidget> createState() => _SampleDateTimeWidget();
}

class _SampleDateTimeWidget extends State<SampleDateTimeWidget> {
  final globalKey = GlobalKey();
  final gKey = GlobalKey();
  String content = 'Enter Event Date and Time';
  Widget prompt =
      const Text('Event Date and Time', style: TextStyle(fontSize: 21));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        ),
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
        ),
      ],
    );
  }
}
