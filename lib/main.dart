import 'package:flutter/material.dart';
import './screens/inicio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.red,
        primaryColor: Colors.indigo
      ),
      home: Inicio(),
    );
  }
}
