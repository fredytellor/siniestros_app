import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siniestros_app/providers/methods.dart';
import 'package:siniestros_app/screens/registro_vehiculo.dart';

class PerfilHomeSiniestros extends StatefulWidget {
  final BoxConstraints constraints;

  PerfilHomeSiniestros(this.constraints);

  @override
  _PerfilHomeSiniestrosState createState() => _PerfilHomeSiniestrosState();
}

class _PerfilHomeSiniestrosState extends State<PerfilHomeSiniestros> {
  @override
  Widget build(BuildContext context) {
    Methods methods = Provider.of<Methods>(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: widget.constraints.maxHeight * 0.9,
      padding: EdgeInsets.only(
        top: widget.constraints.maxHeight * 0.1,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 5,
            child: Container(
              height: widget.constraints.maxHeight * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      left: 10,
                      right: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.person_pin,
                          color: Colors.indigo,
                          size: 80,
                        ),
                        Text(
                          (methods.user.profile_info['nombres'] != null &&
                                  methods.user.profile_info['nombres'] != '')
                              ? methods.user.profile_info['nombres']
                              : 'Nombre',
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 10),
                    child: Text(
                     (methods.user.profile_info['ocupacion'] != null &&
                                  methods.user.profile_info['ocupacion'] != '')
                              ? methods.user.profile_info['ocupacion']
                              : 'Ocupación',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            elevation: 5,
            child: Container(
              height: widget.constraints.maxHeight * 0.3,
              width: widget.constraints.maxWidth,
              child: Center(
                child: Text(
                  'Mis Vehiculos',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: widget.constraints.maxWidth * 0.5,
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  'Agregar Vehículo',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(RegistroVehiculo.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
