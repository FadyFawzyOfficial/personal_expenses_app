import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final Function function;

  const AdaptiveFlatButton({this.text, this.function});

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? CupertinoButton(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: function,
        )
      : TextButton(
          onPressed: function,
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
}
