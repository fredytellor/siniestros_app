import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:siniestros/providers/methods.dart';

class NewSiniestrosHome extends StatefulWidget {
  final BoxConstraints constraints;

  NewSiniestrosHome(this.constraints);

  @override
  _NewSiniestrosHomeState createState() => _NewSiniestrosHomeState();
}

class _NewSiniestrosHomeState extends State<NewSiniestrosHome> {
  String selectedCondicionCarretera;
  File _image;
  File _croquis;
  String selectedFactorAmbiental;
  String selectedCausaPrimaria;
  String selectedClaseBien;
  String selectedTipoBien;
  String selectedRegistro;
  Position devicePosition;
  List<bool> actionsTaken = [
    false,
    false,
    false,
    false,
  ];

  List<List> textPeopleController = [];
  TextEditingController descripcionController = TextEditingController();
  TextEditingController textAddressController = TextEditingController();
  TextEditingController textValorController = TextEditingController();
  TextEditingController textOtherAction = TextEditingController();
  String textPosition;
  String dia;
  bool posLoaded = false;
  bool isLoadingPos = false;
  String ciudad;
  int numberPeople = 1;
  List<Placemark> placemark;

  @override
  Widget build(BuildContext context) {
    Methods methods = Provider.of<Methods>(context);
    dia = DateFormat('EEEEE').format(DateTime.now());
    Size mediaQuerySize = MediaQuery.of(context).size;

    Future<void> _getPosition() async {
      try {
        setState(() {
          isLoadingPos = true;
        });
        await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
            .then(
          (value) {
            print(value);
            devicePosition = value;
            setState(() {
              posLoaded = true;
            });
          },
        );
      } catch (error) {
        print(error);
        setState(() {
          posLoaded = false;
          isLoadingPos = false;
        });
      }
    }

    Future<void> _getImage() async {
      try {
        var image = await ImagePicker.pickImage(source: ImageSource.camera);
        if (image != null) {
          setState(() {
            _image = image;
          });
          methods.showFlushBar(
            context: context,
            title: 'Listo',
            message: '¡Foto lista!',
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
          );
          /*methods.showSnackbar(
          context: context,
          duracion: 2,
          mensaje: 'Foto lista!',
        );*/
        } else {
          methods.showFlushBar(
            context: context,
            title: 'Ops',
            message: 'No has elegido una foto',
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          );
        }
      } catch (error) {
        print(error);
        methods.showFlushBar(
          context: context,
          title: 'error',
          message: error.toString(),
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
        );
      }
    }

    Future<void> _getCroquis() async {
      try {
        var croquis = await ImagePicker.pickImage(source: ImageSource.gallery);
        if (croquis != null) {
          setState(() {
            _croquis = croquis;
          });
          methods.showFlushBar(
            context: context,
            duration: 3,
            title: 'Listo',
            message: 'Croquis cargado correctamente.',
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
          );
        } else {
          methods.showFlushBar(
            context: context,
            duration: 3,
            title: 'Ops',
            message: 'Parece que no has elegido un archivo.',
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          );
        }
      } catch (error) {
        methods.showFlushBar(
          context: context,
          duration: 3,
          title: 'Ops',
          message: error.toString(),
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
        );
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
          textAddressController.text = textPosition;
        });
      }
    }

    _cleanData() {
      setState(() {
        selectedCondicionCarretera = null;
        _image = null;
        _croquis = null;
        selectedFactorAmbiental = null;
        selectedCausaPrimaria = null;
        selectedClaseBien = null;
        selectedTipoBien = null;
        selectedRegistro = null;
        devicePosition = null;
        actionsTaken = [
          false,
          false,
          false,
          false,
        ];
        textPeopleController = [];
        descripcionController = TextEditingController();
        textAddressController = TextEditingController();
        textValorController = TextEditingController();
        textOtherAction = TextEditingController();
        textPosition = null;
        posLoaded = false;
        isLoadingPos = false;
        ciudad = null;
        numberPeople = 1;
        placemark = null;
      });
    }

    void _crearRegistro() async {
      try {
        methods.showSnackbar(
          duracion: 59,
          context: context,
          mensaje: 'Creando registro...',
        );

        List<Map> afectados = [];
        textPeopleController.forEach(
          (afectadoTextos) {
            afectados.add(
              {
                'genero': afectadoTextos[0],
                'estado': afectadoTextos[1],
                'nombre': afectadoTextos[2].text,
                'placa': afectadoTextos[3].text,
                'cedula_titular': afectadoTextos[4].text,
              },
            );
          },
        );

        Map newSiniestro = {
          'ciudad': ciudad,
          'ubicacion': textPosition,
          'tipo_registro': selectedRegistro,
          'condicion_carretera': selectedCondicionCarretera,
          'factor_ambiental': selectedFactorAmbiental,
          'causa_primaria': selectedCausaPrimaria,
          'tipo_bien_afectado': selectedTipoBien,
          'clase_bien_afectado': selectedClaseBien,
          'valor_bien_afectado': textValorController,
          'foto': '',
          'croquis': '',
          'descripcion': descripcionController,
          'acciones': {
            'reporte_aseguradora': actionsTaken[0],
            'atencion_victimas': actionsTaken[1],
            'multa': actionsTaken[2],
            'otra': actionsTaken[3],
          },
          'accion_otra_texto': textOtherAction,
          'afectados': afectados,
        };

        String siniestroID = await methods.crearSiniestro(newSiniestro);

        if (siniestroID != null) {
          String fotoURL;
          String croquisURL;
          if (_image != null) {
            fotoURL = await methods.cargarFoto(
              idSiniestro: siniestroID,
              imagen: _image,
            );
          }
          if (_croquis != null) {
            croquisURL = await methods.cargarCroquis(
              idSiniestro: siniestroID,
              croquis: _croquis,
            );
          }

          if (fotoURL != null || croquisURL != null) {
            bool result = await methods.updateSiniestro(
              croquisURL: croquisURL,
              fotoURL: fotoURL,
              siniestroId: siniestroID,
            );
            if (result) {
              Scaffold.of(context).hideCurrentSnackBar();
              methods.showFlushBar(
                context: context,
                title: 'Listo',
                message: 'Registro creado con foto o croquis',
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
              );
            } else {
              Scaffold.of(context).hideCurrentSnackBar();
              _cleanData();
              methods.showFlushBar(
                context: context,
                title: 'Listo',
                message: 'Registro creado no se pudo cargar foto o croquis',
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
              );
            }
          } else {
            Scaffold.of(context).hideCurrentSnackBar();
            _cleanData();
            methods.showFlushBar(
              context: context,
              title: 'Listo',
              message: 'Registro creado sin foto ni croquis',
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
            );
          }
        } else {
          Scaffold.of(context).hideCurrentSnackBar();
          methods.showSnackbar(
            duracion: 3,
            mensaje: 'Hubo un error al tratar de registrar el siniestro.',
            context: context,
          );
        }
      } catch (error) {
        methods.showFlushBar(
          context: context,
          title: 'error',
          message: error.toString(),
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
        );
      }
    }

    _validarRegistro() {
      try {
        bool afectadosCompleted = true;
        print(textPeopleController.length);
        textPeopleController.forEach(
          (afectado) {
            if (afectado.any((element) =>
                element is String ? element == '' : element.text == '')) {
              afectadosCompleted = false;
            }
          },
        );
        if (!afectadosCompleted) {
          methods.showFlushBar(
            context: context,
            title: 'Ops',
            message:
                'La informacion de todos los afectados es necesaria para registrar',
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          );
        } else if (ciudad == null) {
          methods.showFlushBar(
            context: context,
            title: 'Ops',
            message: 'La ubicación es necesaria para registrar',
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          );
        } else if (selectedRegistro == null) {
          methods.showFlushBar(
            context: context,
            title: 'Ops',
            message: 'El tipo de registro es necesaria para registrar',
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          );
        } else if (selectedCondicionCarretera == null) {
          methods.showFlushBar(
            context: context,
            title: 'Ops',
            message: 'La condición de carretera es necesaria para registrar',
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          );
        } else if (selectedFactorAmbiental == null) {
          methods.showFlushBar(
            context: context,
            title: 'Ops',
            message: 'El factor ambiental es necesario para registrar',
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          );
        } else if (selectedCausaPrimaria == null) {
          methods.showFlushBar(
            context: context,
            title: 'Ops',
            message: 'La causa primaria es necesaria para registrar',
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          );
        } else if (!actionsTaken.any((actions) => actions == true)) {
          methods.showFlushBar(
            context: context,
            title: 'Ops',
            message: 'Alguna acción es necesaria para registrar',
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          );
        } else if (descripcionController.text.isEmpty ||
            descripcionController.text.length < 4) {
          methods.showFlushBar(
            context: context,
            title: 'Ops',
            message: 'Una descripción es necesaria para registrar',
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          );
        } else {
          _crearRegistro();
        }
      } catch (error) {
        print(error);
        methods.showFlushBar(
          context: context,
          title: 'error',
          message: error,
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: widget.constraints.maxHeight * 0.9,
      padding: EdgeInsets.only(
        top: widget.constraints.maxHeight * 0.1,
        left: 20,
        right: 20,
        bottom: 65 + MediaQuery.of(context).viewInsets.bottom,
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
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Ubicación:',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 6,
                          fit: FlexFit.tight,
                          child: posLoaded
                              ? TextFormField(
                                  enabled: posLoaded,
                                  textAlign: TextAlign.center,
                                  controller: textAddressController,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'Dirección aproximada',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                    ),
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                )
                              : Container(
                                  //color: Colors.amber.withOpacity(0.1),
                                  height: 30,
                                  width: 15,
                                  child: Center(
                                    child: isLoadingPos
                                        ? CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.indigo,
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              getPositionText();
                                            },
                                            child: Text(
                                              'Dar ubicación',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                        ),
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: GestureDetector(
                            onTap: () {
                              //_showMMapDialog();
                              getPositionText();
                            },
                            child: Icon(
                              Icons.pin_drop,
                              color: Colors.indigo,
                            ),
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
                      'Tipo de\nregistro:',
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
                            if (newValue == 'Accidente') {
                              setState(() {
                                selectedRegistro = newValue;
                                numberPeople = 2;
                              });
                            } else {
                              setState(() {
                                selectedRegistro = newValue;
                                numberPeople = 1;
                              });
                            }
                          },
                          isExpanded: true,
                          value: selectedRegistro,
                          hint: Text('Elige el registro'),
                          items: [
                            DropdownMenuItem(
                              value: 'Incidente',
                              child: Text(
                                'Incidente',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold),
                              ),
                              key: Key('Incidente'),
                            ),
                            DropdownMenuItem(
                              value: 'Infraccion',
                              child: Text(
                                'Infracción',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold),
                              ),
                              key: Key('Infraccion'),
                            ),
                            DropdownMenuItem(
                              value: 'Accidente',
                              child: Text(
                                'Accidente',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold),
                              ),
                              key: Key('Accidente'),
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
                          hint: Text(
                            'Elige el factor',
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'Nublado',
                              child: Text(
                                'Nublado',
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                ),
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
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
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
                          items: methods.causas.map((causa) {
                            return new DropdownMenuItem<String>(
                              child: new Text(
                                causa,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                    fontSize: mediaQuerySize.width * 0.05),
                              ),
                              value: causa,
                            );
                          }).toList(),
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
                      'Tipo de bien afectado:',
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
                              selectedTipoBien = newValue;
                            });
                          },
                          isExpanded: true,
                          value: selectedTipoBien,
                          hint: Text('Elige tipo de bien'),
                          items: methods.bienes.map((bien) {
                            return new DropdownMenuItem<String>(
                              child: new Text(
                                bien,
                                style: TextStyle(
                                  fontSize: mediaQuerySize.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                              value: bien,
                            );
                          }).toList(),
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
                      'Clase de bien afectado:',
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
                              selectedClaseBien = newValue;
                            });
                          },
                          isExpanded: true,
                          value: selectedClaseBien,
                          hint: Text('Clase del bien'),
                          items: [
                            DropdownMenuItem(
                              child: new Text(
                                'Publico',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                              value: 'Publico',
                            ),
                            DropdownMenuItem(
                              child: Text(
                                'Privado',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                              value: 'Privado',
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
                      'Valor del bien afectado:',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      controller: textValorController,
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLength: 9,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Monto aproximado \u0024',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      inputFormatters: [
                        //FilteringTextInputFormatter.digitsOnly
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: mediaQuerySize.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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
                          (_image != null)
                              ? 'Tomar otra foto'
                              : 'Toma una foto',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _getCroquis();
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          (_croquis != null)
                              ? Icons.cloud_upload
                              : Icons.file_upload,
                          color: Colors.indigo,
                        ),
                        Text(
                          (_croquis != null)
                              ? 'Cargar otro croquis'
                              : 'Subir croquis',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
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
              Container(
                //  color: Colors.amber.withOpacity(0.1),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Text(
                        'Número de afectados:',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 7,
                      fit: FlexFit.tight,
                      child: Container(
                        height: mediaQuerySize.height * 0.15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  numberPeople++;
                                });
                              },
                              child: Icon(
                                Icons.arrow_drop_up,
                                color: Colors.indigo,
                              ),
                            ),
                            Text(
                              numberPeople.toString(),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (selectedRegistro == 'Accidente') {
                                  if (numberPeople > 2) {
                                    setState(() {
                                      numberPeople--;
                                    });
                                  } else {
                                    methods.showFlushBar(
                                      context: context,
                                      title: 'Ops',
                                      message:
                                          'En un accidente hay minimo 2 afectados.',
                                      icon: Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                } else if (numberPeople > 1) {
                                  setState(() {
                                    numberPeople--;
                                  });
                                } else {
                                  methods.showFlushBar(
                                    context: context,
                                    title: 'Ops',
                                    message:
                                        'No puede haber menos de 1 afectado.',
                                    icon: Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: numberPeople,
                itemBuilder: (context, index) {
                  if (textPeopleController.length == 0) {
                    textPeopleController.add(
                      [
                        '', //genero
                        '', //estado
                        new TextEditingController(), //nombre
                        new TextEditingController(), //placa
                        new TextEditingController(), //cedula titular
                      ],
                    );
                  }
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: mediaQuerySize.width * 0.025,
                        vertical: mediaQuerySize.height * 0.025),
                    padding: EdgeInsets.all(
                      mediaQuerySize.width * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Afectado #' + (index + 1).toString(),
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Género:',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: FormField(
                                builder: (child) {
                                  return DropdownButton<String>(
                                    onChanged: (newValue) {
                                      setState(() {
                                        textPeopleController[index][0] =
                                            newValue;
                                      });
                                    },
                                    underline: SizedBox(),
                                    isExpanded: true,
                                    value: textPeopleController[index][0] != ''
                                        ? textPeopleController[index][0]
                                        : null,
                                    hint: Text(
                                      'Género del afectado',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        child: new Text(
                                          'Masculino',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        value: 'Masculino',
                                      ),
                                      DropdownMenuItem(
                                        child: Text(
                                          'Femenino',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        value: 'Femenino',
                                      ),
                                      DropdownMenuItem(
                                        child: Text(
                                          'Otro',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        value: 'Otro',
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
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Estado:',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: FormField(
                                builder: (child) {
                                  return DropdownButton<String>(
                                    onChanged: (newValue) {
                                      setState(
                                        () {
                                          textPeopleController[index][1] =
                                              newValue;
                                        },
                                      );
                                    },
                                    isExpanded: true,
                                    value: textPeopleController[index][1] != ''
                                        ? textPeopleController[index][1]
                                        : null,
                                    hint: Text(
                                      'Estado del afectado',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    underline: SizedBox(),
                                    items: [
                                      DropdownMenuItem(
                                        child: new Text(
                                          'Herido',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        value: 'Herido',
                                      ),
                                      DropdownMenuItem(
                                        child: Text(
                                          'Muerto',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        value: 'Muerto',
                                      ),
                                      DropdownMenuItem(
                                        child: Text(
                                          'Lesionado',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        value: 'Lesionado',
                                      ),
                                      DropdownMenuItem(
                                        child: Text(
                                          'Ileso',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        value: 'Ileso',
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
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Nombre:',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: TextField(
                                controller: textPeopleController[index][2],
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLength: 9,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Nombre afectado',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Placa:',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: TextField(
                                controller: textPeopleController[index][3],
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLength: 7,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Placa del vehiculo',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Cedula titular:',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: TextField(
                                controller: textPeopleController[index][4],
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLength: 12,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'C.C titular vehiculo',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
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
                    return 'Ingresa una descripción válida';
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
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                      offset: Offset(0, 0),
                      spreadRadius: 1,
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Text(
                      'Acciones tomadas',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: actionsTaken[0],
                          checkColor: Colors.white,
                          activeColor: Colors.indigo,
                          onChanged: (newValue) {
                            setState(() {
                              actionsTaken[0] = newValue;
                            });
                          },
                        ),
                        Text(
                          'Reporte aseguradora',
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: actionsTaken[1],
                          checkColor: Colors.white,
                          activeColor: Colors.indigo,
                          onChanged: (newValue) {
                            setState(() {
                              actionsTaken[1] = newValue;
                            });
                          },
                        ),
                        Text(
                          'Atención victimas',
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: actionsTaken[2],
                          checkColor: Colors.white,
                          activeColor: Colors.indigo,
                          onChanged: (newValue) {
                            setState(() {
                              actionsTaken[2] = newValue;
                            });
                          },
                        ),
                        Text(
                          'Multa',
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: actionsTaken[3],
                          checkColor: Colors.white,
                          activeColor: Colors.indigo,
                          onChanged: (newValue) {
                            setState(() {
                              actionsTaken[3] = newValue;
                            });
                          },
                        ),
                        Text(
                          'Otra',
                        )
                      ],
                    ),
                    (actionsTaken[3])
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              controller: textOtherAction,
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: '¿Cuál?',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                                counterText: '',
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
              SizedBox(
                height: widget.constraints.maxHeight / 20,
              ),
              FlatButton(
                onPressed: () {
                  _validarRegistro();
                },
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Registrar',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
