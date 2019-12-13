import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Inicio extends StatefulWidget {
  Inicio({Key key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: DecoratedBox(
            position: DecorationPosition.background,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo_app.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: constraints.maxWidth / 20),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: EdgeInsets.only(top: 15),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Ingresa tu \n   cedula',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: constraints.maxWidth / 15),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth / 10,
                            //     vertical: constraints.maxWidth / 10,
                          ),
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  cursorColor: Theme.of(context).primaryColor,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  decoration: InputDecoration(
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
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight / 20,
                        ),
                        FlatButton(
                          
                          onPressed: () {},
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text('Comenzar',style: TextStyle(color: Colors.white),),
                        ),
                        SizedBox(
                          height: constraints.maxHeight / 16,
                        ),
                      ],
                    ),
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
