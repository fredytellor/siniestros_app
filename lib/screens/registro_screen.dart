import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siniestros_app/providers/methods.dart';
import 'package:siniestros_app/screens/registro_correo.dart';

class RegistroScreen extends StatefulWidget {
  static const routeName = '/registro-screen';
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController cedulaController = TextEditingController();
  TextEditingController edadController = TextEditingController();
  String selectedOcupacion;
  @override
  Widget build(BuildContext context) {
    Methods methods = Provider.of<Methods>(context);


    void _crearUsuario(){

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
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 15),
            child: /*SingleChildScrollView(
              child: */
                Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Ingresa la \n Informacion necesaria',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: constraints.maxWidth / 18),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Te estas registrando con el correo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black, fontSize: constraints.maxWidth / 35),
                ),
                Text(
                  methods.user.profile_info['email'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: constraints.maxWidth / 35,
                  ),
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
                            nombresController.text = value;
                          },
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.trim().length < 3) {
                              return 'Ingresa un nombre valido';
                            } else {
                              return null;
                            }
                          },
                          controller: nombresController,
                          cursorColor: Theme.of(context).primaryColor,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          decoration: InputDecoration(
                            labelText: 'Nombres',
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
                        TextFormField(
                          onSaved: (value) {
                            apellidosController.text = value;
                          },
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.trim().length < 3) {
                              return 'Ingresa un apellido valido';
                            } else {
                              return null;
                            }
                          },
                          controller: apellidosController,
                          cursorColor: Theme.of(context).primaryColor,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          decoration: InputDecoration(
                            labelText: 'Apellidos',
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
                        TextFormField(
                          maxLength: 12,
                          onSaved: (value) {
                            cedulaController.text = value;
                          },
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Ingresa una cedula valida';
                            } else {
                              return null;
                            }
                          },
                          controller: cedulaController,
                          cursorColor: Theme.of(context).primaryColor,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          decoration: InputDecoration(
                            counterText: '',
                            labelText: 'Cedula',
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
                        TextFormField(
                          maxLength: 2,
                          onSaved: (value) {
                            edadController.text = value;
                          },
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            var intValue = int.parse(value);
                            if (value == null || (intValue < 18)) {
                              return 'Debes ser mayor de edad';
                            } else {
                              return null;
                            }
                          },
                          controller: edadController,
                          cursorColor: Theme.of(context).primaryColor,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          decoration: InputDecoration(
                            counterText: '',
                            labelText: 'Edad',
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
                        FormField(
                          builder: (child) {
                            return DropdownButton<String>(
                              onChanged: (newValue) {
                                setState(() {
                                  selectedOcupacion = newValue;
                                });
                              },
                              isExpanded: false,
                              value: selectedOcupacion,
                              hint: Text('Ocupacion'),
                              items: [
                                DropdownMenuItem(
                                  child: Text(
                                    'Empleado',
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  key: Key('Empleado'),
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    'Independiente',
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  key: Key('Independiente'),
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    'Estudiante',
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  key: Key('Estudiante'),
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    'Otro',
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  key: Key('Otro'),
                                ),
                              ],
                              iconEnabledColor: Colors.indigo,
                            );
                          },
                        ),
                        SizedBox(
                          height: constraints.maxHeight / 80,
                        ),
                        FlatButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                               _crearUsuario();
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
        ),
        //),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
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
                                  Navigator.of(context).pushReplacementNamed(
                                      RegistroCorreo.routeName);
                                },
                                color: Colors.indigo,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: constraints.maxWidth / 9),
                                child: Text(
                                  'Completa el\n formulario',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: constraints.maxWidth * 0.08,
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
    });
  }
}
