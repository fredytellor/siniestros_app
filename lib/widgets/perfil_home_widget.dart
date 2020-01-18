import 'package:flutter/material.dart';

class PerfilHomeSiniestros extends StatefulWidget {
  final BoxConstraints constraints;

  PerfilHomeSiniestros(this.constraints);

  @override
  _PerfilHomeSiniestrosState createState() => _PerfilHomeSiniestrosState();
}

class _PerfilHomeSiniestrosState extends State<PerfilHomeSiniestros> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: widget.constraints.maxHeight * 0.9,
      padding: EdgeInsets.only(
        top: widget.constraints.maxHeight * 0.1,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Center(
        child: Text('perfil'),
      ),
    );
  }
}
