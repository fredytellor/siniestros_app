import 'package:flutter/material.dart';

class NewSiniestrosHome extends StatefulWidget {
  final BoxConstraints constraints;

  NewSiniestrosHome(this.constraints);

  @override
  _NewSiniestrosHomeState createState() => _NewSiniestrosHomeState();
}

class _NewSiniestrosHomeState extends State<NewSiniestrosHome> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        height:300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, children: <Widget>[
          Center(
            child: Text(
              'New siniestros screen!',
              style: TextStyle(
                color: Color.fromRGBO(199, 172, 0, 1),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
