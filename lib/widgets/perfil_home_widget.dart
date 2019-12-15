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
    return  Center(
          child: Text(
            'Mi perfil',
            style: TextStyle(
              color: Color.fromRGBO(199, 172, 0, 1),
            ),
      ),
    );
  }
}
