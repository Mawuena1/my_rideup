import 'package:flutter/material.dart';

void switchScreen(
  BuildContext context, {
  required Widget Function(BuildContext) builder,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: builder,
    ),
  );
}
