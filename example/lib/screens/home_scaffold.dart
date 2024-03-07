// ignore_for_file: sort_child_properties_last

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
        ],
      ),
    );
  }
}
