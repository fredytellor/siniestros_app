import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:siniestros_app/models/siniestro.dart';
import 'package:siniestros_app/models/usuario.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Methods with ChangeNotifier {
  String _email;
  Usuario user = new Usuario();
  String uid;
  Siniestro siniestro = new Siniestro();
  List siniestros;
  List causas = [];
  List bienes = [];

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
        'registrador': newSiniestro.registradorUid,
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

  showFlushBar({
    BuildContext context,
    String title,
    String message,
    Icon icon,
    bool blockBackground = false,
    bool blurSnack = false,
    int duration,
    bool button = false,
    String buttonText = 'Activar',
    Function buttonFunction,
    FlushbarPosition position = FlushbarPosition.BOTTOM,
  }) {
    try {
      Flushbar(
        backgroundColor:
            blurSnack ? Colors.indigo.withOpacity(0.95) : Colors.indigo,
        title: title,
        message: message,
        icon: icon,
        barBlur: blurSnack ? 2 : 0.0,
        routeBlur: blockBackground ? 2 : 0.0,
        blockBackgroundInteraction: blockBackground,
        mainButton: button
            ? FlatButton(
                onPressed: buttonFunction,
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            : Center(),
        duration: Duration(
          seconds: duration != null ? duration : 3,
        ),
        flushbarPosition: position,
      )..show(context);
    } catch (error) {
      print('show flushbar error: ' + error.toString());
    }
  }

  void getUsuario(String uid) async {
    var result =
        await Firestore.instance.collection('usuarios').document(uid).get();

    if (result != null) {
      user.setUsuario(result.data['profile_info'], result.data['ubicacion']);
      print(result.data['profile_info'].toString() +
          ' // ' +
          result.data['ubicacion'].toString());
    } else {
      print('no se pudo setear el usuario');
    }
  }

  void getSiniestros() async {
    var result =
        await Firestore.instance.collection('siniestros').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    //documents.forEach((data) => print(data.data));
    siniestros = documents;
    siniestros.forEach((data) => print(data.data));
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
      'registrador': newSiniestro.registradorUid,
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
        FirebaseStorage().ref().child('/sinestros_fotos/$idSiniestro');
    StorageUploadTask upload =
        storageReference.putData(imagen.readAsBytesSync());

    url = await (await upload.onComplete).ref.getDownloadURL();

    print('Foto del siniestro cargada al storage y url obtenida');
    return url;
  }

  Future<String> cargarCroquis({File croquis, String idSiniestro}) async {
    String url;
    StorageReference storageReference =
        FirebaseStorage().ref().child('/sinestros_croquis/$idSiniestro');
    StorageUploadTask upload =
        storageReference.putData(croquis.readAsBytesSync());

    url = await (await upload.onComplete).ref.getDownloadURL();

    print(
      'Foto del siniestro cargada al storage y url obtenida',
    );
    return url;
  }

  void closeDBSesion() async {
    await FirebaseAuth.instance.signOut();
    uid = null;
    siniestro = new Siniestro();
    user = new Usuario();
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

  Future<bool> crearIntervencion(
      Map<String, dynamic> newIntervencion, String idSiniestro) async {
    var result = false;
    try {
      await Firestore.instance
          .collection('siniestros')
          .document(idSiniestro)
          .collection('intervenciones')
          .add(newIntervencion)
          .then((_) {
        result = true;
      });
      return result;
    } catch (error) {
      print(error);
      return result;
    }
  }

  loadRegisterData() async {
    var infoDoc =
        await Firestore.instance.collection('public').document('info').get();
    print(infoDoc.data);
    bienes = infoDoc.data['bienes'];
    causas = infoDoc.data['causas'];
  }
} //fin methods
