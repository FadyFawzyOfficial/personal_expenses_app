import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final Function function;

  const AdaptiveFlatButton({this.text, this.function});

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? CupertinoButton(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: function,
        )
      : FlatButton(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          textColor: Theme.of(context).primaryColor,
          onPressed: function,
        );
}
