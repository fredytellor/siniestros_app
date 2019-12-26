import 'package:flutter/material.dart';

class Dialogs extends StatefulWidget {
  final String textTitle;
  final String textContent;
  final String textButton;
  final Function buttonFunction;

  Dialogs({
    @required this.textTitle,
    @required this.textContent,
    @required this.textButton,
    @required this.buttonFunction,
  });

  @override
  _DialogsState createState() => _DialogsState();
}

class _DialogsState extends State<Dialogs> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text(
        widget.textTitle,
        style: TextStyle(
          color: Colors.red,
          fontSize: 30,
        ),
      )),
      content: Text(widget.textContent),
      actions: <Widget>[
        FlatButton(
          onPressed: widget.buttonFunction,
          child: Text(widget.textButton),
        )
      ],
    );
  }
}
