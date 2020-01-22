import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:siniestros_app/providers/methods.dart';
import 'package:siniestros_app/widgets/dialogs.dart';

class IntervencionAccidente extends StatefulWidget {
  final DocumentSnapshot docAccidente;

  IntervencionAccidente(this.docAccidente);

  @override
  _IntervencionAccidenteState createState() => _IntervencionAccidenteState();
}

class _IntervencionAccidenteState extends State<IntervencionAccidente> {
  TextEditingController controlController = new TextEditingController();
  TextEditingController costoController = new TextEditingController();
  TextEditingController descripcionController = new TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Methods methods = Provider.of<Methods>(context);

    void _guardarIntervencion(BuildContext context) async {
      Map<String, dynamic> newIntervencion = {
        'fecha': DateFormat('MM/d/y').format(DateTime.now()),
        'control': controlController.text,
        'descripcion': descripcionController.text,
        'costo': costoController.text,
        'digitador': methods.uid,
        'fecha_seguimiento':
            DateFormat('MM/d/y').format(DateTime.now().add(Duration(days: 60))),
      };

      var result = await methods.crearIntervencion(
        newIntervencion,
        widget.docAccidente.documentID,
      );
      String mensaje;
      if (result) {
        mensaje = 'La intervención del siniestro se ha guardado en la BD';
      } else {
        mensaje = 'Lamentablemente no pudimos registrar esta intervención.';
      }

      showDialog(
          context: context,
          builder: (context) {
            return Dialogs(
              textTitle: (result) ? 'Listo' : 'ops',
              buttonFunction: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              textButton: 'cerrar',
              textContent: mensaje,
            );
          });

      setState(() {
        costoController.text = '';
        descripcionController.text = '';
        controlController.text = '';
      });
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.docAccidente.documentID),
          ),
          body: Container(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
              top: 30,
            ),
            height: constraints.maxHeight,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Intervención del siniestro',
                      style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    Text(
                      DateFormat('MM/d/y').format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.indigo[300],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value == '' ||
                            value.trim().length < 5) {
                          return 'Ingresa un control válido';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        controlController.text = value.trim();
                      },
                      controller: controlController,
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      decoration: InputDecoration(
                        labelText: 'Control',
                        hintText: '¿Como se va a controlar esto?',
                        hintStyle: TextStyle(color: Colors.black54),
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
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: costoController,
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      validator: (value) {
                        if (value == null ||
                            value == '' ||
                            value.trim().length < 6) {
                          return 'Ingresa un costo válido';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        costoController.text = value.trim();
                      },
                      decoration: InputDecoration(
                        labelText: 'Costo',
                        hintText: '¿Cuánto costará esto?',
                        hintStyle: TextStyle(color: Colors.black54),
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
                      height: 10,
                    ),
                    TextFormField(
                      controller: descripcionController,
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      validator: (value) {
                        if (value == null ||
                            value == '' ||
                            value.trim().length < 6) {
                          return 'Ingresa una descripción válida';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        descripcionController.text = value.trim();
                      },
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        hintText: 'Danos detalles sobre la intervención.',
                        hintStyle: TextStyle(color: Colors.black54),
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
                      height: 20,
                    ),
                    Container(
                      width: constraints.maxWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'Seguimiento desde:',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialogs(
                                          textTitle: 'Calma...',
                                          textContent:
                                              'Aún no puedes dar seguimiento a esta intervención.',
                                          buttonFunction: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                          textButton: 'cerrar',
                                        );
                                      });
                                },
                                icon: Icon(
                                  Icons.receipt,
                                  color: Colors.indigo,
                                ),
                              ),
                              Text(
                                DateFormat('MM/d/y').format(
                                  DateTime.now().add(
                                    Duration(
                                      days: 60,
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Intervenir siniestro',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _guardarIntervencion(context);
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
