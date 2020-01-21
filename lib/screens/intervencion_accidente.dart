import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.docAccidente.documentID),
          ),
          body: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 30,
            ),
            height: constraints.maxHeight,
            child: Form(
              child: Column(
                children: <Widget>[
                  Text(
                    DateFormat('MM/d/y').format(DateTime.now()),
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(),
                  TextFormField(),
                  TextFormField(),
                  Container(
                    width: constraints.maxWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Seguimiento',
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.receipt,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
