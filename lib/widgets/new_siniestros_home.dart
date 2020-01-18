import 'package:flutter/material.dart';

class NewSiniestrosHome extends StatefulWidget {
  final BoxConstraints constraints;

  NewSiniestrosHome(this.constraints);

  @override
  _NewSiniestrosHomeState createState() => _NewSiniestrosHomeState();
}

class _NewSiniestrosHomeState extends State<NewSiniestrosHome> {
  String selectedCondicionCarretera;
  String selectedFactorAmbiental;
  String selectedCausaPrimaria;
  TextEditingController descripcionController = TextEditingController();

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

    return  Container(
        decoration: BoxDecoration(color: Colors.white),
        height: widget.constraints.maxHeight * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          child: SingleChildScrollView(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Condicion carretera:',
                          style: TextStyle(
                              color: Colors.indigo, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: FormField(
                          builder: (child) {
                            return DropdownButton<String>(
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCondicionCarretera = newValue;
                                });
                              },
                              isExpanded: true,
                              value: selectedCondicionCarretera,
                              hint: Text('Elige la condicion'),
                              items: [
                                DropdownMenuItem(
                                  value: 'Con Huecos',
                                  child: Text(
                                    'Con Huecos',
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  key: Key('Con Huecos'),
                                ),
                                DropdownMenuItem(
                                  value: 'No señalizada',
                                  child: Text(
                                    'No señalizada',
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  key: Key('No señalizada'),
                                ),
                              ],
                              iconEnabledColor: Colors.indigo,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Factor Ambiental:',
                          style: TextStyle(
                              color: Colors.indigo, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: FormField(
                          builder: (child) {
                            return DropdownButton<String>(
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCondicionCarretera = newValue;
                                });
                              },
                              isExpanded: true,
                              value: selectedCondicionCarretera,
                              hint: Text('Elige el factor'),
                              items: [
                                DropdownMenuItem(
                                  value: 'Nublado',
                                  child: Text(
                                    'Nublado',
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  key: Key('Nublado'),
                                ),
                                DropdownMenuItem(
                                  value: 'Lluvioso',
                                  child: Text(
                                    'Lluvioso',
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  key: Key('Lluvioso'),
                                ),
                                DropdownMenuItem(
                                  value: 'Soleado',
                                  child: Text(
                                    'Soleado',
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  key: Key('Soleado'),
                                ),
                              ],
                              iconEnabledColor: Colors.indigo,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Causa Primaria:',
                          style: TextStyle(
                              color: Colors.indigo, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: FormField(
                          builder: (child) {
                            return DropdownButton<String>(
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCondicionCarretera = newValue;
                                });
                              },
                              isExpanded: true,
                              value: selectedCondicionCarretera,
                              hint: Text('Elige una causa'),
                              items: [
                                DropdownMenuItem(
                                  value: 'No hizo el pare',
                                  child: Text(
                                    'No hizo el pare',
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  key: Key('No hizo el pare'),
                                ),
                                DropdownMenuItem(
                                  value: 'Paso el semaforo rojo',
                                  child: Text(
                                    'Paso el semaforo rojo',
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  key: Key('Paso el semaforo rojo'),
                                ),
                              ],
                              iconEnabledColor: Colors.indigo,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  IconButton(
                    icon: Icon(Icons.add_a_photo),
                    tooltip: 'Sube una foto',
                    onPressed: (){},
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
                    onPressed: () {},
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
