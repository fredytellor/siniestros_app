import 'package:flutter/material.dart';
import 'package:siniestros_app/providers/methods.dart';
import 'package:siniestros_app/screens/home_screen.dart';
import 'package:siniestros_app/screens/inicio_password.dart';
import 'package:siniestros_app/screens/registro_correo.dart';
import 'package:siniestros_app/screens/registro_screen.dart';
import 'package:siniestros_app/screens/registro_vehiculo.dart';
import 'package:siniestros_app/screens/splash.dart';
import './screens/inicio.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // builder:(ctx)=>Methods(),
      create: (context) => Methods(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Siniestros',
        theme: ThemeData(
          // primarySwatch: Colors.red,
          primaryColor: Colors.indigo,
        ),
        routes: {
          '/': (BuildContext context) => Splash(),
          Inicio.routeName: (BuildContext context) => Inicio(),
          HomeScreen.routeName: (BuildContext context) => HomeScreen(),
          InicioPassword.routeName: (BuildContext context) => InicioPassword(),
          RegistroScreen.routeName: (BuildContext context) => RegistroScreen(),
          RegistroCorreo.routeName: (BuildContext context) => RegistroCorreo(),
          RegistroVehiculo.routeName: (BuildContext context) =>
              RegistroVehiculo(),
        },
      ),
    );
  }
}
