import 'package:flutter/material.dart';
import 'package:ui_extensions_flutter/ui_extensions_flutter.dart';

import '../../ui_datetime_scroll_picker_flutter.dart';

class UIDateTimePrompt extends StatefulWidget {
  late final DateTime? initialDateTime;
  final Function()? onDoubleTap;
  final Function(DateTime?) onSelected;
  final Offset offset;
  final Widget promptWidget;

  UIDateTimePrompt({
    super.key,
    DateTime? initialDateTime,
    required this.onSelected,
    this.offset = const Offset(5, 30),
    this.onDoubleTap,
    required this.promptWidget,
  }) {
    this.initialDateTime = initialDateTime ?? DateTime.now();
  }

  @override
  State<UIDateTimePrompt> createState() => _UIDateTimePrompt();
}

class _UIDateTimePrompt extends State<UIDateTimePrompt> {
  final globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onDoubleTap: widget.onDoubleTap,
        onTap: () async {
          final result = await Navigator.of(context).push(
            dateTimeOverlayRoute(
              globalKey: globalKey,
              dateTime: widget.initialDateTime,
              offset: widget.offset,
            ),
          );
          widget.onSelected(result);
        },
        child: SizedBox(
          key: globalKey,
          width: double.infinity,
          height: 48.0,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.promptWidget,
              ]),
        ).paddingSymmetric(horizontal: 8.0));
  }
}
