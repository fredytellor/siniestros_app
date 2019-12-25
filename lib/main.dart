import 'package:flutter/material.dart';
import 'package:siniestros_app/screens/home_screen.dart';
import 'package:siniestros_app/screens/inicio_password.dart';
import 'package:siniestros_app/screens/registro_screen.dart';
import './screens/inicio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.indigo,
      ),
      routes: {
        '/': (BuildContext context) => Inicio(),
        HomeScreen.routeName: (BuildContext context) => HomeScreen(),
        InicioPassword.routeName:(BuildContext context)=>InicioPassword(),
        RegistroScreen.routeName:(BuildContext context)=>RegistroScreen(),
      },
    );
  }
}
