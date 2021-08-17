import 'package:flutter/material.dart';
import 'package:url_shortener_app/src/models/ErrorModel.dart';

void showInSnackBar(BuildContext context, List<DataError> errors) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 4),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: errors
            .map((error) => Text(
                  '- ${error.msg}',
                  style: TextStyle(fontSize: 18),
                ))
            .toList(),
      ),
    ),
  );
}
