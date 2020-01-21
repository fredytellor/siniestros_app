import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:siniestros_app/providers/methods.dart';

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

  @override
  Widget build(BuildContext context) {
    Methods methods = Provider.of<Methods>(context);
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
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Intervencion del siniestro',
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
                      controller: costoController,
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      decoration: InputDecoration(
                        labelText: 'Costo',
                        hintText: '¿Cuanto costara esto?',
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
                      decoration: InputDecoration(
                        labelText: 'Descripcion',
                        hintText: '',
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
                                        return AlertDialog(
                                          title: Text('Calma...'),
                                          content: Text(
                                              'Aun no puedes dar seguimiento a esta intervencion.'),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('cerrar'),
                                              onPressed: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              },
                                            ),
                                          ],
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
                      print('registrando intervencion');
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
