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
      contentPadding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 30,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: Text(
        widget.textTitle,
        style: TextStyle(
          color: Colors.red,
          fontSize: 30,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        widget.textContent,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: widget.buttonFunction,
          child: Text(widget.textButton),
        )
      ],
    );
  }
}
