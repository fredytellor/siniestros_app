import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class IntervencionAccidente extends StatefulWidget {
  final DocumentSnapshot docAccidente;
final bool isAuthorized;

  IntervencionAccidente(this.docAccidente,this.isAuthorized);

  @override
  _IntervencionAccidenteState createState() => _IntervencionAccidenteState();
}

class _IntervencionAccidenteState extends State<IntervencionAccidente> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.docAccidente.documentID),
          ),
        );
      },
    );
  }
}
