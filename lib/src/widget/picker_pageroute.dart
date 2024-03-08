import 'package:flutter/material.dart';
import 'package:ui_positioned_overlay_flutter/ui_positioned_overlay_flutter.dart';

import 'ui_datetime_picker.dart';

PageRouteBuilder dateTimeOverlayRoute<T>({
  required GlobalKey globalKey,
  DateTime? dateTime,
  Offset offset = const Offset(0, 0),
}) {
  return PageRouteBuilder(
    opaque: false,
    pageBuilder: (context, _, __) {
      return UIPositionedOverlayWidget<T?>(
        triggerKey: globalKey,
        offset: offset,
        builder: (context, dismiss) {
          return Card(
            color: Colors.transparent,
            elevation: 0.0,
            child: SizedBox(
              height: kDateTimePickerSize.height,
              width: kDateTimePickerSize.width,
              child: UIDateTimePicker(
                dateTime: dateTime,
                onDateTimeSelected: (dateTime) => dismiss(dateTime),
              ),
            ),
          );
        },
      );
    },
  );
}
