import 'dart:io';
import 'package:flutter/services.dart';
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
  File _croquis;
  String selectedFactorAmbiental;
  String selectedCausaPrimaria;
  String selectedClaseBien;
  String selectedTipoBien;
  String selectedRegistro;
  Position devicePosition;
  TextEditingController descripcionController = TextEditingController();
  TextEditingController textAddressController = TextEditingController();
  String textPosition;
  String dia;
  String ciudad;
  int numberPeople = 1;
  List<Placemark> placemark;
  @override
  Widget build(BuildContext context) {
    Methods methods = Provider.of<Methods>(context);
    dia = DateFormat('EEEEE').format(DateTime.now());
    Size mediaQuerySize = MediaQuery.of(context).size;

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

    return Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom * 10),
      decoration: BoxDecoration(color: Colors.white),
      height: widget.constraints.maxHeight * 0.9,
      padding: EdgeInsets.only(
          top: widget.constraints.maxHeight * 0.1,
          left: 20,
          right: 20,
          bottom: 20 //+ MediaQuery.of(context).viewInsets.bottom * 10,
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
                    flex: 6,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Flexible(
                              flex: 6,
                              fit: FlexFit.tight,
                              child: TextFormField(
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

                        /* Text(
                            (textPosition != null)
                                ? textPosition
                                : 'Dar la ubicación',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),*/

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
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: mediaQuerySize.width * 0.025),
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
                                    selectedClaseBien = newValue;
                                  });
                                },
                                isExpanded: true,
                                value: selectedClaseBien,
                                hint: Text('Género del afectado'),
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
                                  setState(() {
                                    selectedClaseBien = newValue;
                                  });
                                },
                                isExpanded: true,
                                value: selectedClaseBien,
                                hint: Text('Estado del afectado'),
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
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLength: 9,
                            keyboardType: TextInputType.number,
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
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLength: 9,
                            keyboardType: TextInputType.number,
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
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLength: 9,
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
                    Text('Acciones tomadas'),
                    Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (newValue) {},
                        ),
                        Text(
                          'Reporte aseguradora',
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (newValue) {},
                        ),
                        Text(
                          'Atención victimas',
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (newValue) {},
                        ),
                        Text(
                          'Multa',
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (newValue) {},
                        ),
                        Text(
                          'Otra',
                        )
                      ],
                    ),
                    (true)
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLength: 9,
                              keyboardType: TextInputType.number,
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
            ],
          ),
        ),
      ),
    );
  }
}
