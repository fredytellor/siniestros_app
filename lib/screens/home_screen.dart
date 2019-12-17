import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:siniestros_app/widgets/my_siniestros_home.dart';
import 'package:siniestros_app/widgets/new_siniestros_home.dart';
import 'package:siniestros_app/widgets/perfil_home_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  PageController pageViewController = PageController(
    initialPage: 1,
  );

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//PageController pageViewController = PageController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Container(
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            child: Column(
              //  alignment: Alignment.center,
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
                      child: Text('data'),
                    ),
                  ),
                ),
                Container(
                  height: constraints.maxHeight * 0.7,
                  child: BottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                    backgroundColor:// Color.fromRGBO(63, 15, 145, 1),
                    Color.fromRGBO(66, 5, 155, 1),
                    onClosing: () {},
                    enableDrag: false,
                    builder: (context) {
                      return PageView(
                        onPageChanged: (v) {},
                        controller: widget.pageViewController,
                        children: <Widget>[
                          PerfilHomeSiniestros(constraints),
                          NewSiniestrosHome(constraints),
                          MySiniestrosHome(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

/* BottomSheet(
                          onClosing: () {},
                          enableDrag: false,
                          builder: (context) {
                            return PageView(
                              onPageChanged: (v) {},
                              controller: widget.pageViewController,
                              children: <Widget>[
                                Container(
                                  child: PerfilHomeSiniestros(constraints),
                                ),
                                Container(
                                  child: NewSiniestrosHome(constraints),
                                ),
                                Container(
                                  child: MySiniestrosHome(),
                                ),
                              ],
                            );
                          },
                       ),*/
