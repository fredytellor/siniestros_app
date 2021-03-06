import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siniestros/providers/methods.dart';
import 'package:siniestros/screens/intervencion_accidente.dart';
import 'package:siniestros/screens/siniestro_details.dart';

class MySiniestrosHome extends StatefulWidget {
  final BoxConstraints constraints;

  MySiniestrosHome(this.constraints);

  @override
  _MySiniestrosHomeState createState() => _MySiniestrosHomeState();
}

class _MySiniestrosHomeState extends State<MySiniestrosHome> {
  @override
  Widget build(BuildContext context) {
    Methods methods = Provider.of<Methods>(context);
    Future<QuerySnapshot> querySnapshot;
    bool isAuthorized;
    print(methods.user.profile_info['rol']);
    if (methods.user.profile_info['rol'] == '2') {
      querySnapshot =
          Firestore.instance.collection('siniestros').getDocuments();
      isAuthorized = true;
    } else {
      querySnapshot = Firestore.instance
          .collection('siniestros')
          .where('registrador', isEqualTo: methods.uid)
          .getDocuments();
      isAuthorized = false;
    }

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: widget.constraints.maxHeight * 0.9,
      padding: EdgeInsets.only(
        top: widget.constraints.maxHeight * 0.1,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: FutureBuilder(
        future: querySnapshot,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<DocumentSnapshot> documents = snapshot.data.documents;
            if (documents.length > 0) {
              return Container(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 70),
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, index) {
                    return GestureDetector(
                      onTap: () {
                        /*if (isAuthorized) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return IntervencionAccidente(
                                  documents[index],
                                );
                              },
                            ),
                          );
                        }*/

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return SiniestroDetails(
                                documents[index],
                              );
                            },
                          ),
                        );
                      },
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          title: Text(
                            documents[index]['fecha'] +
                                ' - ' +
                                documents[index]
                                    .documentID
                                    .toString()
                                    .substring(0, 4),
                          ),
                          leading: Text((index + 1).toString()),
                          subtitle: Text(documents[index]['ciudad']),
                          trailing:
                              /*Icon(
                            Icons.directions_car,
                            color: Colors.indigo,
                          ),*/
                              Container(
                            height: 40,
                            width: 40,
                            child: FadeInImage(
                              image: NetworkImage(
                                documents[index]['foto'],
                              ),
                              placeholder:
                                  AssetImage('assets/images/accidente.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Container(
                width: widget.constraints.maxWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.indigo,
                    ),
                    Text(
                      'Parece que aun no has registrado ni\nparticipado en ningun accidente',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              );
            }
          } else {
            return Container(
              width: widget.constraints.maxWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text(
                    'Cargando...',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
