import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siniestros_app/screens/home_screen.dart';
import 'package:siniestros_app/screens/inicio.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isActive;

  void isASesionActive() async {
    var result = await FirebaseAuth.instance.currentUser();
    if (result != null) {
      if (result.uid != null) {
        isActive = true;
      } else {
        isActive = false;
      }
    } else {
      isActive = false;
    }
    didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    isASesionActive();
  }

  @override
  void didChangeDependencies() {
    if (isActive != null) {
      if (isActive == true) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(Inicio.routeName);
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //Methods methods = Provider.of<Methods>(context);
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
