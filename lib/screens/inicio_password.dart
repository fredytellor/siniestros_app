import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siniestros_app/providers/methods.dart';
import 'package:siniestros_app/screens/home_screen.dart';
import 'package:siniestros_app/screens/inicio.dart';
import 'package:siniestros_app/widgets/dialogs.dart';

class InicioPassword extends StatefulWidget {
  static const routeName = '/inicio-password';

  @override
  _InicioPasswordState createState() => _InicioPasswordState();
}

class _InicioPasswordState extends State<InicioPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Methods methods = Provider.of<Methods>(context);
    final String correo = methods.email;

    void _iniciarSesion() async {
      var result =
          await methods.iniciarconCorreo(correo, passwordController.text);

      if (result['status'] == true) {
        methods.uid = result['uid'];
        Navigator.of(context)
            .pushReplacementNamed(HomeScreen.routeName /*,arguments: null*/);
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return Dialogs(
              textTitle: 'Ops!',
              buttonFunction: () {
                Navigator.of(context).pop();
              },
              textButton: 'Intentar de nuevo',
              textContent: result['error'],
            );
          },
        );
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
                ' Ingresa tu\ncontraseña',
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
                        obscureText: true,
                        onSaved: (value) {
                          passwordController.text = value;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value.isEmpty || value.trim().length < 6) {
                            return 'Contraseña incorrecta';
                          } else {
                            return null;
                          }
                        },
                        controller: passwordController,
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        decoration: InputDecoration(
                          helperText: correo,
                          labelText: 'Contraseña',
                          helperStyle: TextStyle(
                            color: Colors.indigo,
                          ),
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
                            _iniciarSesion();
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
                                    'Siniestros',
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
