import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siniestros/providers/methods.dart';
import 'package:photo_view/photo_view.dart';
import 'package:siniestros/screens/image_viewer.dart';

class SiniestroDetails extends StatefulWidget {
  final DocumentSnapshot siniestroId;

  SiniestroDetails(this.siniestroId);
  @override
  _SiniestroDetailsState createState() => _SiniestroDetailsState();
}

class _SiniestroDetailsState extends State<SiniestroDetails> {
  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.of(context).size;
    Methods methods = Provider.of<Methods>(context);

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
                              ? SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    print('subir croquis');
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
                                    print('subir Foto');
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
