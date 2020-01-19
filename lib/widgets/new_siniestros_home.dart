import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:siniestros_app/providers/methods.dart';

class NewSiniestrosHome extends StatefulWidget {
  final BoxConstraints constraints;

  NewSiniestrosHome(this.constraints);

  @override
  _NewSiniestrosHomeState createState() => _NewSiniestrosHomeState();
}

class _NewSiniestrosHomeState extends State<NewSiniestrosHome> {
  String selectedCondicionCarretera;
  File _image;
  String selectedFactorAmbiental;
  String selectedCausaPrimaria;
  Position devicePosition;
  TextEditingController descripcionController = TextEditingController();
  String textPosition;
  List<Placemark> placemark;
  @override
  Widget build(BuildContext context) {
    Methods methods = Provider.of<Methods>(context);

    Future<void> _getPosition() async {
      await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((value) {
        print(value);
        devicePosition = value;
      });
    }

    Future<void> _getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _image = image;
        });
        methods.showSnackbar(
            context: context, duracion: 2, mensaje: 'Foto lista!');
      } else {
        methods.showSnackbar(
            context: context,
            duracion: 2,
            mensaje: 'No has elegido una foto nueva');
      }
    }

    Future<void> _getAddress(double lati, double longi) async {
      placemark = await Geolocator().placemarkFromCoordinates(lati, longi);

      textPosition = placemark[0].locality.toString() +
          ',' +
          placemark[0].thoroughfare.toString() +
          '#' +
          placemark[0].subThoroughfare.toString() +
          '.';
    }

    Future<void> getPositionText() async {
      await _getPosition();
      if (devicePosition != null) {
        await _getAddress(devicePosition.latitude, devicePosition.longitude);
        setState(() {
          textPosition;
        });
      }
    }

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

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: widget.constraints.maxHeight * 0.9,
      padding: EdgeInsets.only(
        top: widget.constraints.maxHeight * 0.1,
        left: 20,
        right: 20,
        bottom: 20,
      ),
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
                Text(
                  DateFormat('MM/d/y').format(DateTime.now()),
                  style: TextStyle(color: Colors.black54),
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
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              //_showMMapDialog();
                              getPositionText();
                            },
                            child: Text(
                              (textPosition != null)
                                  ? textPosition
                                  : 'Dar la ubicacion',
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Text(
                            'ubicacion del dispositivo aproximada',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                          ),
                        ],
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
                        'Causa\nPrimaria:',
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
                GestureDetector(
                  onTap: () {
                    _getImage();
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(
                        (_image != null)
                            ? Icons.check_circle
                            : Icons.add_a_photo,
                        color: Colors.indigo,
                      ),
                      Text(
                        (_image != null) ? 'Elegir otra foto' : 'Sube una foto',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
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
                    hintText: '¿sabes que paso? danos detalles.',
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
