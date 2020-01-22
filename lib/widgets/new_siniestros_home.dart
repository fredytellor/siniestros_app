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
  String dia;
  String ciudad;
  List<Placemark> placemark;
  @override
  Widget build(BuildContext context) {
    Methods methods = Provider.of<Methods>(context);
    dia = DateFormat('EEEEE').format(DateTime.now());

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

      ciudad = placemark[0].locality.toString();
      textPosition = ciudad +
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

    bool _validarRegistro() {
      if (ciudad == null) {
        methods.showSnackbar(
            context: context,
            duracion: 3,
            mensaje: 'Es necesaria la ubicación para registrar el siniestro');
        return false;
      } else if (_image == null) {
        methods.showSnackbar(
            context: context,
            duracion: 3,
            mensaje: 'Es necesaria una foto del siniestro');
        return false;
      } else {
        return true;
      }
    }

    void _crearRegistro() async {
      methods.showSnackbar(
          duracion: 59, context: context, mensaje: 'Creando registro...');
      methods.siniestro.setSiniestro(
        fecha: DateFormat('MM/d/y').format(DateTime.now()),
        ciudad: ciudad,
        dia: dia,
        foto: '',
        causaPrimaria:
            (selectedCausaPrimaria != null) ? selectedCausaPrimaria : '',
        condicionCarretera: (selectedCondicionCarretera != null)
            ? selectedCondicionCarretera
            : '',
        factorAmbiental:
            (selectedFactorAmbiental != null) ? selectedFactorAmbiental : '',
        descripcion: (descripcionController.text != null)
            ? descripcionController.text
            : '',
        ubicacion: textPosition,
        registradorUid: methods.uid,
      );

      String siniestroID = await methods.crearSiniestro(methods.siniestro);

      if (siniestroID != null) {
        String url =
            await methods.cargarFoto(idSiniestro: siniestroID, imagen: _image);

        if (url != null) {
          methods.siniestro.foto = url;

          var result = await methods.updateSiniestro(
              siniestroId: siniestroID, newSiniestro: methods.siniestro);

          if (result) {
            Scaffold.of(context).hideCurrentSnackBar();
            methods.showSnackbar(
                duracion: 3,
                mensaje: 'Siniestro ' + siniestroID + ' registrado.',
                context: context);
                
          } else {
            Scaffold.of(context).hideCurrentSnackBar();
            methods.showSnackbar(
                duracion: 3,
                mensaje:
                    'No logramos vincular la foto del siniestro al registro',
                context: context);
          }
        }
      } else {
        Scaffold.of(context).hideCurrentSnackBar();
        methods.showSnackbar(
            duracion: 3,
            mensaje: 'Hubo un error al tratar de registrar el siniestro.',
            context: context);
      }
      setState(() {
        selectedFactorAmbiental = null;
        selectedCausaPrimaria = null;
        selectedCondicionCarretera = null;
        ciudad = null;
        dia = null;
        descripcionController.text = '';
        textPosition = null;
        _image = null;
      });
    }

/*
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
*/
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
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Registra nuevo siniestro',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  DateFormat('MM/d/y').format(DateTime.now()) + '\n' + dia,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.indigo),
                ),
                Container(
                  height: 2,
                  width: widget.constraints.maxWidth,
                  color: Colors.indigo[200],
                ),
                Center(
                  child: Text(
                    'Recuerda que la ubicación y la foto son obligatorios',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
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
                        'Ubicación',
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
                                  : 'Dar la ubicación',
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Text(
                            'ubicación del dispositivo aproximada',
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
                        'Condición carretera:',
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
                            hint: Text('Elige la condición'),
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
                                selectedFactorAmbiental = newValue;
                              });
                            },
                            isExpanded: true,
                            value: selectedFactorAmbiental,
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
                                selectedCausaPrimaria = newValue;
                              });
                            },
                            isExpanded: true,
                            value: selectedCausaPrimaria,
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
                        (_image != null) ? 'Tomar otra foto' : 'Toma una foto',
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
                  controller: descripcionController,
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
                    labelText: 'Descripción',
                    hintText: '¿Sabes qué pasó? Danos detalles.',
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
                  onPressed: () {
                    if (_validarRegistro()) {
                      _crearRegistro();
                    }
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
