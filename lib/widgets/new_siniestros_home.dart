import 'package:flutter/material.dart';

class NewSiniestrosHome extends StatefulWidget {
  final BoxConstraints constraints;

  NewSiniestrosHome(this.constraints);

  @override
  _NewSiniestrosHomeState createState() => _NewSiniestrosHomeState();
}

class _NewSiniestrosHomeState extends State<NewSiniestrosHome> {
  @override
  Widget build(BuildContext context) {
    void _showMMapDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Ubicacion'),
              content: Container(
                height: 300,
                child: Center(
                  child: Text('GoogleMap'),
                ),
              ),
              actions: <Widget>[
                Container(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Text('Guardar'),
                      ),
                    ],
                  ),
                )
              ],
            );
          });
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        height: widget.constraints.maxHeight * 0.8,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Text(
                    'Registra nuevos siniestros',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Ubicacion',
                        style: TextStyle(
                            color: Colors.indigo, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                        onTap: () {
                          _showMMapDialog();
                        },
                        child: Text(
                          'Elige la ubicacion',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (value) {},
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().length < 3) {
                      return 'Ingresa un apellido valido';
                    } else {
                      return null;
                    }
                  },
                  cursorColor: Theme.of(context).primaryColor,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  decoration: InputDecoration(
                    labelText: 'Descripcion',
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
                  height: widget.constraints.maxHeight / 20,
                ),
                FlatButton(
                          onPressed: () {
                           
                          },
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Registrar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
              ]),
        ),
      ),
    );
  }
}
