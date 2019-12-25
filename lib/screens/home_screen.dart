import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:siniestros_app/screens/inicio.dart';
import 'package:siniestros_app/widgets/my_siniestros_home.dart';
import 'package:siniestros_app/widgets/new_siniestros_home.dart';
import 'package:siniestros_app/widgets/perfil_home_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName='/home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var viewSelected = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final List homeViews = [
        PerfilHomeSiniestros(constraints),
        NewSiniestrosHome(constraints),
        MySiniestrosHome(),
      ];

      return Scaffold(
        body: Container(
          height: constraints.maxHeight,
          child: Column(
            children: <Widget>[
              DecoratedBox(
                position: DecorationPosition.background,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/fondo_app.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  height: constraints.maxHeight * 0.3,
                  child: Center(
                    child: GestureDetector(
                      onTap: (){
                         Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(builder: (context) {
                                  return Inicio();
                                }));
                      },
                                          child: Text(
                        'Siniestros',
                        style: TextStyle(
                            color: Colors.lime,
                            fontSize: constraints.maxWidth/9,
                            fontWeight: FontWeight.bold,
                            decorationStyle: TextDecorationStyle.solid),
                      ),
                    ),
                  ),
                ),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: homeViews[viewSelected],
                  ),
                  BottomNavigationBar(
                    currentIndex: viewSelected,
                    onTap: (value) {
                      setState(() {
                        viewSelected = value;
                      });
                    },
                    backgroundColor: Colors.lime,
                    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                    items: [
                      BottomNavigationBarItem(
                        title: Text('Perfil'),
                        icon: Icon(Icons.person),
                      ),
                      BottomNavigationBarItem(
                        title: Text('Nuevo'),
                        icon: Icon(Icons.add),
                      ),
                      BottomNavigationBarItem(
                        title: Text('Mis'),
                        icon: Icon(Icons.receipt),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
