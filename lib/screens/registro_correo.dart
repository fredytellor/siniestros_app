import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siniestros/providers/methods.dart';
import 'package:siniestros/screens/registro_screen.dart';
import 'package:siniestros/widgets/dialogs.dart';

import 'inicio.dart';

class RegistroCorreo extends StatefulWidget {
  static const routeName = '/registro-correo';

  @override
  _RegistroCorreoState createState() => _RegistroCorreoState();
}

class _RegistroCorreoState extends State<RegistroCorreo> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Methods methods = Provider.of<Methods>(context);

    void _validarCorreo() async {
      var result = await methods.consultarInicioEmail(emailController.text);
      if (!result) {
        methods.user.profile_info['email'] = emailController.text;
        Navigator.of(context).pushReplacementNamed(RegistroScreen.routeName);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return Dialogs(
                textTitle: 'ops, ya existe!',
                buttonFunction: () {
                  Navigator.of(context).pop();
                },
                textButton: 'cerrar',
                textContent:
                    'intenta iniciar sesion o recuperar contraseña si la olvidaste',
              );
            });
      }
    }

    Widget _buildContent(BoxConstraints constraints) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(
              50,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Text(
                'Ingresa tu \n   correo',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: constraints.maxWidth / 15),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth / 10,
                  vertical: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        onSaved: (value) {
                          emailController.text = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value.trim())) {
                            return 'Introduce un correo valido';
                          } else {
                            return null;
                          }
                        },
                        controller: emailController,
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          labelStyle: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: constraints.maxHeight / 20,
                      ),
                      SizedBox(
                        height: constraints.maxHeight / 80,
                      ),
                      FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            _validarCorreo();
                          }
                        },
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Continuar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: constraints.maxHeight / 20,
                      ),
                      SizedBox(
                        height: constraints.maxHeight / 26,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            height: constraints.maxHeight,
            child: Scaffold(
              // resizeToAvoidBottomInset: false,
              body: Container(
                child: SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        color: Colors.indigo,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                            color: Color.fromRGBO(1, 1, 1, 0),
                            height: constraints.maxHeight * 0.8,
                            width: constraints.maxWidth,
                            child: _buildContent(constraints)),
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * 0.2,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed(Inicio.routeName);
                                  },
                                  color: Colors.indigo,
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: constraints.maxWidth / 8),
                                  child: Text(
                                    'Registro',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: constraints.maxWidth * 0.1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
