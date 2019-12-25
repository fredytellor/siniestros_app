import 'package:flutter/material.dart';

class RegistroScreen extends StatefulWidget {
  static const routeName = '/registro-screen';
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('registro'),
      ),
    );
  }
}
