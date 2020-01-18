import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:siniestros_app/providers/methods.dart';
import 'package:siniestros_app/screens/inicio.dart';
import 'package:siniestros_app/widgets/my_siniestros_home.dart';
import 'package:siniestros_app/widgets/new_siniestros_home.dart';
import 'package:siniestros_app/widgets/perfil_home_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var viewSelected = 1;

  @override
  Widget build(BuildContext context) {
    Methods methods = Provider.of<Methods>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final List homeViews = [
          PerfilHomeSiniestros(constraints),
          NewSiniestrosHome(constraints),
          MySiniestrosHome(),
        ];
        return SingleChildScrollView(
          child: Container(
            height: constraints.maxHeight,
            child: Scaffold(
              // resizeToAvoidBottomInset: false,
              body: Container(
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: constraints.maxHeight,
                          child: homeViews[viewSelected],
                          
                        ),
                        Positioned(
                          top: 0,
                          child: Container(
                            color: Colors.indigo,
                            width: constraints.maxWidth,
                            height: constraints.maxHeight * 0.1,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: constraints.maxWidth / 8),
                                    child: Text(
                                      'Siniestros',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: constraints.maxWidth * 0.1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.launch,
                                      color: Colors.white,
                                    ),
                                    tooltip: 'cerrar sesion',
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              Inicio.routeName);
                                      methods.closeDBSesion();
                                    },
                                    color: Colors.indigo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: constraints.maxWidth,
                            height: 65,
                            color: Colors.red,
                            child: BottomNavigationBar(
                              currentIndex: viewSelected,
                              onTap: (value) {
                                setState(() {
                                  viewSelected = value;
                                });
                              },
                              backgroundColor: Colors.indigo,
                              selectedLabelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              items: [
                                BottomNavigationBarItem(
                                  title: Text(
                                    'Perfil',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  icon: Icon(
                                    Icons.person,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                BottomNavigationBarItem(
                                  title: Text(
                                    'Nuevo',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  icon: Icon(
                                    Icons.add_box,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                BottomNavigationBarItem(
                                  title: Text(
                                    'Mios',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  icon: Icon(
                                    Icons.receipt,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ),
        );
      },
    );

/*
 

*/
  }
}
