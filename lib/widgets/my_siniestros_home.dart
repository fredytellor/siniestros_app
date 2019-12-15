import 'package:flutter/material.dart';

class MySiniestrosHome extends StatefulWidget {
  MySiniestrosHome({Key key}) : super(key: key);

  @override
  _MySiniestrosHomeState createState() => _MySiniestrosHomeState();
}

class _MySiniestrosHomeState extends State<MySiniestrosHome> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Mis siniestros screen',
          style: TextStyle(
            color: Color.fromRGBO(199, 172, 0, 1),
          )),
    );
  }
}
