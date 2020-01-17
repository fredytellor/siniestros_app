import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siniestros_app/models/usuario.dart';

class Methods with ChangeNotifier {
  String _email;
  Usuario user = new Usuario();
  String uid;

  String get email {
    return _email;
  }

  void setEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void closeDBSesion() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> consultarInicioEmail(String email) async {
    try {
      var result =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email: email);
      if (result.contains('password')) {
        print(result);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<Map> iniciarconCorreo(String email, String password) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return {
        'status': true,
        'error': '',
        'uid': result.user.uid,
      };
    } catch (error) {
      print(error);
      if (error.code == 'ERROR_WRONG_PASSWORD') {
        return {
          'status': false,
          'error': 'Contraseña incorrecta',
          'uid': '',
        };
      }
      return null;
    }
  }

  Future<String> crearAutenticacion(String email, String pasword) async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pasword);

      if (result != null) {
        return result.user.uid;
      } else {
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> crearUsuario(Map<String, dynamic> newUser) async {
    var result = false;
    try {
      Firestore.instance
          .collection('usuarios')
          .document(uid)
          .setData(newUser)
          .then((_) {
        result = true;
      });
      return result;
    } catch (error) {
      print(error);
      return result;
    }
  }
} //fin methods
