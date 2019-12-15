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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: DecoratedBox(
            position: DecorationPosition.background,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo_app.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Container(
              child: PageView(
                onPageChanged: (v) {},
                controller: widget.pageViewController,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: constraints.maxHeight * 0.55,
                    child: PerfilHomeSiniestros(constraints),
                  ),
                  NewSiniestrosHome(constraints),
                  MySiniestrosHome(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
