import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siniestros_app/models/siniestro.dart';
import 'package:siniestros_app/models/usuario.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Methods with ChangeNotifier {
  String _email;
  Usuario user = new Usuario();
  String uid;
  Siniestro siniestro = new Siniestro();

  String get email {
    return _email;
  }

  void setEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  Future<String> crearSiniestro(Siniestro newSiniestro) async {
    String docId;
    try {
      Map<String, dynamic> newMapedSiniestro = {
        'ubicacion': newSiniestro.ubicacion,
        'ciudad': newSiniestro.ciudad,
        'fecha': newSiniestro.fecha,
        'dia': newSiniestro.dia,
        'descripcion': newSiniestro.descripcion,
        'condicionCarretera': newSiniestro.condicionCarretera,
        'causaPrimaria': newSiniestro.causaPrimaria,
        'factorAmbiental': newSiniestro.factorAmbiental,
        'foto': newSiniestro.foto,
        'registrador':newSiniestro.registradorUid,
      };

      await Firestore.instance
          .collection('siniestros')
          .add(newMapedSiniestro)
          .then((doc) {
        print(doc.documentID);
        docId = doc.documentID;
      });

      return docId;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> updateSiniestro(
      {String siniestroId, Siniestro newSiniestro}) async {
    bool result = false;
    Map<String, dynamic> newMapedSiniestro = {
      'ubicacion': newSiniestro.ubicacion,
      'ciudad': newSiniestro.ciudad,
      'fecha': newSiniestro.fecha,
      'dia': newSiniestro.dia,
      'descripcion': newSiniestro.descripcion,
      'condicionCarretera': newSiniestro.condicionCarretera,
      'causaPrimaria': newSiniestro.causaPrimaria,
      'factorAmbiental': newSiniestro.factorAmbiental,
      'foto': newSiniestro.foto,
      'registrador':newSiniestro.registradorUid,
    };
    await Firestore.instance
        .collection('siniestros')
        .document(siniestroId)
        .setData(newMapedSiniestro)
        .then((_) {
      result = true;
    });

    return result;
  }

  Future<String> cargarFoto({File imagen, String idSiniestro}) async {
    String url;
    StorageReference storageReference =
        FirebaseStorage().ref().child('/sinestros_fotos/${idSiniestro}');
    StorageUploadTask upload =
        storageReference.putData(imagen.readAsBytesSync());

    url = await (await upload.onComplete).ref.getDownloadURL();

    print('Foto del siniestro cargada al storage y url obtenida');
    return url;
  }

  void closeDBSesion() async {
    await FirebaseAuth.instance.signOut();
    uid=null;
    siniestro=null;
    user=null;
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

  void showSnackbar({BuildContext context, int duracion, String mensaje}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: Duration(
          seconds: duracion,
        ),
        content: Text(mensaje),
      ),
    );
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
