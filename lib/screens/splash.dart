import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siniestros_app/providers/methods.dart';
import 'package:siniestros_app/screens/home_screen.dart';
import 'package:siniestros_app/screens/inicio.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isActive;
  Methods methods;
  DocumentSnapshot docActive;

  void isASesionActive() async {
    var result = await FirebaseAuth.instance.currentUser();
    if (result != null) {
      if (result.uid != null) {
        docActive = await isRegistered(result.uid);
        if (docActive != null) {
          methods.user.setUsuario(
              docActive.data['profile_info'], docActive.data['ubicacion']);
          methods.uid = docActive.documentID;
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed(Inicio.routeName);
        }
        isActive = true;
      } else {
        isActive = false;
      }
    } else {
      isActive = false;
    }
    didChangeDependencies();
  }

  Future<DocumentSnapshot> isRegistered(String uid) async {
    DocumentSnapshot doc =
        await Firestore.instance.collection('usuarios').document(uid).get();

    if (doc != null) {
      return doc;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    // FirebaseAuth.instance.signOut();
    isASesionActive();
  }

  @override
  void didChangeDependencies() {
    /*if (isActive != null) {
      if (isActive == true) {
        Navigator.of(context)
            .pushReplacementNamed(HomeScreen.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(Inicio.routeName);
      }
    }*/
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    methods = Provider.of<Methods>(context);

    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
