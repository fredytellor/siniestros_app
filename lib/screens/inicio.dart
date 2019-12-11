import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  Inicio({Key key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo_3.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    'Ingresa tu Cedula',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                TextFormField(
                  maxLength: 12,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 26,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cedula de ciudadania',
                    hintStyle: TextStyle(
                      color: Colors.green,
                      fontSize: 26,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                FlatButton(
               //   padding: EdgeInsets.all(10),
                  splashColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2,color: Colors.pink),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Continuar',
                    style: TextStyle(fontSize: 29, color: Colors.pink),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
