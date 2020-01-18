import 'package:flutter/material.dart';

class MySiniestrosHome extends StatefulWidget {
   final BoxConstraints constraints;

  MySiniestrosHome(this.constraints);


  @override
  _MySiniestrosHomeState createState() => _MySiniestrosHomeState();
}

class _MySiniestrosHomeState extends State<MySiniestrosHome> {
  @override
  Widget build(BuildContext context) {
      return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: widget.constraints.maxHeight * 0.9,
      padding: EdgeInsets.only(
        top: widget.constraints.maxHeight * 0.1,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Center(
        child: Text('Mis siniestros'),
      ),
    );
  }
}
