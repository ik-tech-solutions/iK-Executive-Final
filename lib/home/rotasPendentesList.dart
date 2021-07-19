import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/models/logistica.dart';
import 'package:my_cab_driver/home/aceptedRouteDetail.dart';

class RotasPendentesList extends StatefulWidget {
  @override
  _RotasPendentesListState createState() => _RotasPendentesListState();
}

class _RotasPendentesListState extends State<RotasPendentesList> {
  final FirebaseAuth authFB = FirebaseAuth.instance;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar(),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'Serviços aceites',
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseDatabase.instance.reference().child('logistica').orderByChild('id_motorista').equalTo(authFB.currentUser.uid).onValue,
          builder: (context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasData) {
              listaLogistica.clear();
              DataSnapshot dataValues = snapshot.data.snapshot;
              Map<dynamic, dynamic> values = dataValues.value;
              if(dataValues.value != null){
                values.forEach((key, values) {

                  if(values['status'].toString() == "pendente" ||
                      values['status'].toString() == "em execução" ||
                      values['status'].toString() == "entregando"  ){
                    listaLogistica.add(values);

                    logistica = new Logistica();

                    logistica.key              = values["key"];
                    logistica.endereco_origem   = values["endereco_origem"];
                    logistica.endereco_destino  = values["endereco_destino"];

                    logistica.destinatario      = values["destinatario"];
                    logistica.duracao           = values["duracao"];
                    logistica.distancia         = values["distancia"];
                    logistica.preco             = values["custo"];
                    logistica.data              = values["data_envio"];
                    logistica.remetente         = values["nome_usuario"];

                  }





                });
                return new ListView.builder(
                    padding: const EdgeInsets.all(15),
                    shrinkWrap: true,
                    itemCount: listaLogistica.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Animator(
                            tween: Tween<Offset>(
                              begin: Offset(0, 0.4),
                              end: Offset(0, 0),
                            ),
                            duration: Duration(milliseconds: 700),
                            cycles: 1,
                            builder: (anim) => SlideTransition(
                              position: anim,
                              child:


                              Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    logistica = new Logistica();

                                    logistica.key  = listaLogistica[index]["key"];
                                    logistica.latitudeColeta  = listaLogistica[index]["latitude_origem"];
                                    logistica.longitudeColeta = listaLogistica[index]["longitude_origem"];
                                    logistica.latitudeEntrega  = listaLogistica[index]["latitude_destino"];
                                    logistica.longitudeEntrega = listaLogistica[index]["longitude_destino"];
                                    logistica.referencia = listaLogistica[index]["referencia"];


                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RotaAceitaScreean(
                                          logisticaKey: listaLogistica[index]["key"],
                                        ),
                                      ),
                                    );
                                  },
                                  child:  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Theme.of(context).dividerColor,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.only(left: 70, top: 14, bottom: 14),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[

                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      AppLocalizations.of(listaLogistica[index]['nome_usuario']),
                                                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).textTheme.subtitle2.color,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(listaLogistica[index]['valor_inicial']),
                                                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).textTheme.subtitle2.color,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                          height: 24,
                                                          width: 200,
                                                          child: Center(
                                                            child: Text(
                                                              AppLocalizations.of(listaLogistica[index]['data_envio']),
                                                              style: Theme.of(context).textTheme.overline.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: ConstanceData.secoundryFontColor,
                                                                  fontSize: 12
                                                              ),
                                                            ),
                                                          ),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(15),
                                                            ),
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),


                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 0.5,
                                            color: Theme.of(context).disabledColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      AppLocalizations.of('LOCAL DE RECOLHA'),
                                                      style: Theme.of(context).textTheme.caption.copyWith(
                                                        color: Theme.of(context).disabledColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(listaLogistica[index]['endereco_origem']),
                                                      style: Theme.of(context).textTheme.overline.copyWith(
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).textTheme.headline6.color,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 0.5,
                                            color: Theme.of(context).disabledColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      AppLocalizations.of('LOCAL DE ENTREGA'),
                                                      style: Theme.of(context).textTheme.caption.copyWith(
                                                        color: Theme.of(context).disabledColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(listaLogistica[index]['endereco_destino']),
                                                      style: Theme.of(context).textTheme.overline.copyWith(
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).textTheme.headline6.color,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 0.5,
                                            color: Theme.of(context).disabledColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                                            child: Container(
                                              height: 32,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.grey,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  AppLocalizations.of('ENTRAR'),
                                                  style: Theme.of(context).textTheme.button.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: ConstanceData.secoundryFontColor,
                                                  ),
                                                ),
                                              ),
                                            ),

                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      );

                    }
                );

              } else {
                return Center( child:Text(
                  AppLocalizations.of("Não há serviços pendentes no momento."),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                )
                );
              }
            }
            return Center( child: CircularProgressIndicator());
          }),



    );
  }

  Widget appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          SizedBox(
            height: AppBar().preferredSize.height,
            width: AppBar().preferredSize.height + 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Icon(
                    Icons.dehaze,
                    color: ConstanceData.secoundryFontColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of('Serviços aceites'),
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                fontWeight: FontWeight.bold,
                color: ConstanceData.secoundryFontColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: AppBar().preferredSize.height,
            width: AppBar().preferredSize.height + 40,
          ),
        ],
      ),
    );
  }
}
