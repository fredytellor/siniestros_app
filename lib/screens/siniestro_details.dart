import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:siniestros/providers/methods.dart';
import 'package:siniestros/screens/image_viewer.dart';

class SiniestroDetails extends StatefulWidget {
  final DocumentSnapshot siniestroId;

  SiniestroDetails(this.siniestroId);
  @override
  _SiniestroDetailsState createState() => _SiniestroDetailsState();
}

class _SiniestroDetailsState extends State<SiniestroDetails> {
  File _image;
  File _croquis;

  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.of(context).size;
    Methods methods = Provider.of<Methods>(context);

    Future<void> _getImage() async {
      try {
        _image = await ImagePicker.pickImage(source: ImageSource.gallery);
        if (_image != null) {
          String fotoURL = await methods.cargarFoto(
            imagen: _image,
            idSiniestro: widget.siniestroId.documentID,
          );
          if (fotoURL != null) {
            bool result = await methods.updateSiniestro(
              siniestroId: widget.siniestroId.documentID,
              fotoURL: widget.siniestroId.data['foto'],
              croquisURL: fotoURL,
            );
            if (result) {
              setState(() {
                widget.siniestroId.data['foto'] = fotoURL;
              });
              methods.showFlushBar(
                context: context,
                duration: 4,
                title: 'Listo',
                message: 'Vuelve a cargar los detalles para ver la foto',
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
                message: 'Parece que no se logro actualziar el siniestro.',
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
              );
            }
          } else {
            methods.showFlushBar(
              context: context,
              duration: 3,
              title: 'Ops',
              message: 'Parece que no se logro cargar la foto.',
              icon: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
            );
          }
        } else {
          methods.showFlushBar(
            context: context,
            duration: 3,
            title: 'Ops',
            message: 'Parece que no has elegido una foto.',
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
        _croquis = await ImagePicker.pickImage(source: ImageSource.gallery);
        if (_croquis != null) {
          String croquisURL = await methods.cargarCroquis(
            croquis: _croquis,
            idSiniestro: widget.siniestroId.documentID,
          );
          if (croquisURL != null) {
            bool result = await methods.updateSiniestro(
              siniestroId: widget.siniestroId.documentID,
              fotoURL: widget.siniestroId.data['foto'],
              croquisURL: croquisURL,
            );
            if (result) {
              setState(() {
                widget.siniestroId.data['croquis'] = croquisURL;
              });
              methods.showFlushBar(
                context: context,
                duration: 4,
                title: 'Listo',
                message: 'Vuelve a cargar los detalles para ver el croquis',
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
                message: 'Parece que no se logro actualziar el siniestro.',
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
              );
            }
          } else {
            methods.showFlushBar(
              context: context,
              duration: 3,
              title: 'Ops',
              message: 'Parece que no se logro cargar el croquis.',
              icon: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
            );
          }
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

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text(
          widget.siniestroId.documentID,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Container(
        height: mediaQuerySize.height,
        width: mediaQuerySize.width,
        child: Stack(
          children: [
            Container(
              height: mediaQuerySize.height * 0.9,
              width: mediaQuerySize.width,
              child: ListView(
                padding: EdgeInsets.only(bottom: mediaQuerySize.height * 0.15),
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: mediaQuerySize.width,
                    child: Center(
                      child: Text(
                        widget.siniestroId.data['fecha'] +
                            ' ' +
                            widget.siniestroId.data['ciudad'],
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: mediaQuerySize.width * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Text(
                            'Tipo registro: ',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          fit: FlexFit.tight,
                          child: Center(
                            child: Text(
                              widget.siniestroId.data['tipo_registro'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Text(
                            'Ubicación: ',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          fit: FlexFit.tight,
                          child: Center(
                            child: Tooltip(
                              message: widget.siniestroId.data['ubicacion'],
                              child: Text(
                                widget.siniestroId.data['ubicacion'],
                                maxLines: 3,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Text(
                            'Condición carretera: ',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          fit: FlexFit.tight,
                          child: Center(
                            child: Text(
                              widget.siniestroId.data['condicion_carretera'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Text(
                            'Factor ambiental: ',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          fit: FlexFit.tight,
                          child: Center(
                            child: Text(
                              widget.siniestroId.data['factor_ambiental'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Text(
                            'Causa primaria: ',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          fit: FlexFit.tight,
                          child: Center(
                            child: Text(
                              widget.siniestroId.data['causa_primaria'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Text(
                            'Tipo bien: ',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          fit: FlexFit.tight,
                          child: Center(
                            child: Text(
                              widget.siniestroId.data['tipo_bien_afectado'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Text(
                            'clase bien: ',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          fit: FlexFit.tight,
                          child: Center(
                            child: Text(
                              widget.siniestroId.data['clase_bien_afectado'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Text(
                            'Valor bien: ',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          fit: FlexFit.tight,
                          child: Center(
                            child: Text(
                              widget.siniestroId.data['valor_bien_afectado'] !=
                                      ''
                                  ? widget
                                      .siniestroId.data['valor_bien_afectado']
                                  : 'No informado',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Text(
                            'Croquis: ',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          fit: FlexFit.tight,
                          child: widget.siniestroId.data['croquis'] != '' &&
                                  widget.siniestroId.data['croquis'] != null
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ImageViewer(
                                            widget.siniestroId.data['croquis'],
                                            'Croquis',
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Ver Croquis ',
                                        style: TextStyle(
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      Icon(
                                        Icons.photo_size_select_actual,
                                        color: Colors.indigo,
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    _getCroquis();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Subir croquis ',
                                        style: TextStyle(
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      Icon(
                                        Icons.cloud_upload,
                                        color: Colors.indigo,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Text(
                            'Foto: ',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          fit: FlexFit.tight,
                          child: widget.siniestroId.data['foto'] != '' &&
                                  widget.siniestroId.data['foto'] != null
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ImageViewer(
                                            widget.siniestroId.data['foto'],
                                            'Foto',
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Ver Foto ',
                                        style: TextStyle(
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      Icon(
                                        Icons.photo_size_select_actual,
                                        color: Colors.indigo,
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    _getImage();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Subir Foto ',
                                        style: TextStyle(
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      Icon(
                                        Icons.unarchive,
                                        color: Colors.indigo,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Text(
                            'Descripción: ',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          fit: FlexFit.tight,
                          child: Center(
                            child: Text(
                              widget.siniestroId.data['descripcion'] != ''
                                  ? widget.siniestroId.data['descripcion']
                                  : 'No informado',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: mediaQuerySize.width,
                          child: Text(
                            'Acciones:',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Text(
                                  'Atención victimas: ',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 7,
                                fit: FlexFit.tight,
                                child: Center(
                                  child: Icon(
                                    widget.siniestroId.data['acciones']
                                            ['atencion_victimas']
                                        ? Icons.check_box
                                        : Icons.crop_square,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Text(
                                  'Multa: ',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 7,
                                fit: FlexFit.tight,
                                child: Center(
                                  child: Icon(
                                    widget.siniestroId.data['acciones']['multa']
                                        ? Icons.check_box
                                        : Icons.crop_square,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Text(
                                  'Reporte aseguradora: ',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 7,
                                fit: FlexFit.tight,
                                child: Center(
                                  child: Icon(
                                    widget.siniestroId.data['acciones']
                                            ['reporte_aseguradora']
                                        ? Icons.check_box
                                        : Icons.crop_square,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Text(
                                  'Otra: ',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 7,
                                fit: FlexFit.tight,
                                child: Center(
                                  child: Icon(
                                    widget.siniestroId.data['acciones']['otra']
                                        ? Icons.check_box
                                        : Icons.crop_square,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.siniestroId.data['acciones']['otra']
                            ? Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        'Otra texto: ',
                                        style: TextStyle(
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 7,
                                      fit: FlexFit.tight,
                                      child: Center(
                                        child: Text(widget.siniestroId.data[
                                                    'accion_otra_texto'] !=
                                                ''
                                            ? widget.siniestroId
                                                .data['accion_otra_texto']
                                            : 'No informado'),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.siniestroId.data['afectados'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            children: [
                              Container(
                                width: mediaQuerySize.width,
                                child: Text(
                                  'Afectado #' + (index + 1).toString() + ':',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                width: mediaQuerySize.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      offset: Offset(0, 0),
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 7.5),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              'Nombre:',
                                              style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 7,
                                            fit: FlexFit.tight,
                                            child: Center(
                                              child: Text(
                                                widget.siniestroId
                                                        .data['afectados']
                                                    [index]['nombre'],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 7.5),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              'Género:',
                                              style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 7,
                                            fit: FlexFit.tight,
                                            child: Center(
                                              child: Text(
                                                widget.siniestroId
                                                        .data['afectados']
                                                    [index]['genero'],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 7.5),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              'Estado:',
                                              style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 7,
                                            fit: FlexFit.tight,
                                            child: Center(
                                              child: Text(
                                                widget.siniestroId
                                                        .data['afectados']
                                                    [index]['estado'],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 7.5),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              'Placa:',
                                              style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 7,
                                            fit: FlexFit.tight,
                                            child: Center(
                                              child: Text(
                                                widget.siniestroId
                                                        .data['afectados']
                                                    [index]['placa'],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 7.5),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              'Cedula titular:',
                                              style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 7,
                                            fit: FlexFit.tight,
                                            child: Center(
                                              child: Text(
                                                widget.siniestroId
                                                        .data['afectados']
                                                    [index]['cedula_titular'],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: -mediaQuerySize.width * 0.025,
              child: Container(
                padding: EdgeInsets.only(left: 10),
                height: mediaQuerySize.height * 0.1,
                width: mediaQuerySize.width * 0.95,
                margin: EdgeInsets.symmetric(
                  horizontal: mediaQuerySize.width * 0.05,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: Text(
                        'Desliza hacia abajo\npara ver más detalles',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: mediaQuerySize.width * 0.0325,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 7,
                      fit: FlexFit.tight,
                      child: Center(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.indigo,
                          onPressed: () {
                            print('exportar pdf');
                          },
                          child: Text(
                            'Exportar PDF',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
