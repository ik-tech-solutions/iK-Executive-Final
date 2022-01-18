import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/appTheme.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/database/HelperMethods.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_cab_driver/models/carteira.dart';
import 'package:my_cab_driver/models/logistica.dart';
import 'package:my_cab_driver/widgets/cardWidget.dart';
import 'package:my_cab_driver/history/rotaHistoricoDetail.dart';


class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth authFB = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'Histórico',
          ),
        ),
      ),
      appBar: appBar(),
      body: Column(
        children: <Widget>[
          // celanderList(),
          Container(
            height: 1.5,
            color: Theme.of(context).dividerColor,
          ),
          jobsAndEarns(),
          SizedBox(
            height: 8,
          ),
          Expanded(
            child:

            StreamBuilder(
                stream: FirebaseDatabase.instance.reference().child('logistica').orderByChild('id_motorista').equalTo(authFB.currentUser.uid).onValue,
                builder: (context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasData) {
                    listaLogistica.clear();
                    DataSnapshot dataValues = snapshot.data.snapshot;
                    Map<dynamic, dynamic> values = dataValues.value;
                    if(dataValues.value != null){
                      values.forEach((key, values) {

                        if(values['status'].toString() == "concluido"){
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
                                    child:  Padding(
                                      padding: EdgeInsets.only(right: 8, left: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadiusDirectional.circular(16),
                                          color: Theme.of(context).cardColor,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(16), topStart: Radius.circular(16)),
                                                color: Theme.of(context).dividerColor,
                                              ),
                                              child:  Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: () {
                                                        // gotorating();

                                                        logisticaEspecifica = HelperMethods.getLogisticaEspecifica(listaLogistica[index]["key"]);

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
                                                            builder: (context) => RotaHistoricaDetailScreen(
                                                              custo     : listaLogistica[index]["custo"],
                                                              taxaDeCobranca  : listaLogistica[index]["taxa_cobranca"],
                                                              taxaDeEnvio : listaLogistica[index]["taxa_envio"],
                                                              remetente  : listaLogistica[index]["nome_usuario"],
                                                              tokenMotorista : listaLogistica[index]["nome_usuario"],
                                                              servicoAdicional  : listaLogistica[index]["servico_adicional"],
                                                              tipo : listaLogistica[index]["tipo"],
                                                              tipoDeCasa  : listaLogistica[index]["referencia"],
                                                              destinatario  : listaLogistica[index]["destinatario"],
                                                              referencia  : listaLogistica[index]["referencia"],
                                                              logisticaKey  : listaLogistica[index]["key"],
                                                              pagamento  : listaLogistica[index]["pagamento"],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: CardWidget(
                                                        fromAddress: AppLocalizations.of(listaLogistica[index]["endereco_origem"]),
                                                        toAddress: AppLocalizations.of(listaLogistica[index]["endereco_destino"]),
                                                        price: listaLogistica[index]["pagamento"],
                                                        status: AppLocalizations.of(listaLogistica[index]["data_envio"]),
                                                        statusColor: HexColor("#3638FE"),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 16,
                                                    ),
                                                  ],
                                                ),

                                            ),

                                            SizedBox(
                                              height: 8,
                                            ),
                                          ],
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
                      return Center( child:Container(
                        height: AppBar().preferredSize.height,
                        color: Theme.of(context).disabledColor,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14, left: 14),
                          child: Row(
                            children: <Widget>[


                              StreamBuilder(
                                  stream: FirebaseDatabase.instance
                                      .reference()
                                      .child('logistica')
                                      .orderByChild('status')
                                      .equalTo("aguardando")
                                      .onValue,
                                  builder: (context, AsyncSnapshot<Event> snapshot) {
                                    if (snapshot.hasData) {
                                      logisticasHistoryInt = 0;
                                      DataSnapshot dataValues = snapshot.data.snapshot;
                                      Map<dynamic, dynamic> values = dataValues.value;
                                      if(dataValues.value != null){
                                        values.forEach((key, values) {
                                          logisticasHistoryInt++;
                                        });
                                        return Text(
                                          "Existe "+logisticasHistoryInt.toString() + " encomendas disponíveis á tua espera.",
                                          style: Theme.of(context).textTheme.overline.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: ConstanceData.secoundryFontColor,
                                          ),
                                        );

                                      } else {
                                        return Center( child:Text(
                                          AppLocalizations.of("Não há encomendas disponívies no momento."),
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        )
                                        );
                                      }
                                    }
                                    return Center( child:Text(
                                      AppLocalizations.of("Sem histórico"),
                                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    )
                                    );
                                  }),





                            ],
                          ),
                        ),
                      ),
                      );
                    }
                  }
                  return Center( child: CircularProgressIndicator());
                }),


          )
        ],
      ),
    );
  }

  Widget jobsAndEarns() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.carAlt,
                      size: 20,
                      color: ConstanceData.secoundryFontColor,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        StreamBuilder(
                            stream: FirebaseDatabase.instance.reference().child('logistica').orderByChild('id_motorista').equalTo(authFB.currentUser.uid).onValue,
                            builder: (context, AsyncSnapshot<Event> snapshot) {
                              if (snapshot.hasData) {
                                logisticasConcluidasIntHistorico = 0;
                                DataSnapshot dataValues = snapshot.data.snapshot;
                                Map<dynamic, dynamic> values = dataValues.value;
                                if(dataValues.value != null){
                                  values.forEach((key, values) {

                                    if(values['status'].toString() == "concluido"){

                                      logisticasConcluidasIntHistorico++;



                                      print("Logisticas Histtttt -------------------------------------------------------------------"+ values.toString());
                                    }


                                  });
                                  return   Text(
                                    logisticasConcluidasIntHistorico.toString(),
                                    style: Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                                  );

                                } else {
                                  return Center( child:Text(
                                    AppLocalizations.of('0'),
                                    style: Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                                  )
                                  );
                                }
                              }
                              return Text("...");
                            }),


                        Text(
                          AppLocalizations.of('Total de serviços'),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: ConstanceData.secoundryFontColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  )),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        StreamBuilder(
                            stream: FirebaseDatabase.instance.reference().child('motorista').child(authFB.currentUser.uid).child("carteira").onValue,
                            builder: (context, AsyncSnapshot<Event> snapshot) {
                              if (snapshot.hasData) {

                                DataSnapshot dataValues = snapshot.data.snapshot;
                                Map<dynamic, dynamic> values = dataValues.value;
                                if(dataValues.value != null){

                                  userCarteira = new Carteira.fromSnapshot(dataValues);

                                  values.forEach((key, values) {
                                  });

                                  return Text(
                                    double.parse(userCarteira.ganho_total).toStringAsFixed(2) + "€",
                                    style: Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  );

                                } else {
                                  return Center( child:Text(
                                    AppLocalizations.of('...'),
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

                        Text(
                          AppLocalizations.of('Total de ganhos'),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
              AppLocalizations.of('Histórico'),
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

  Widget celanderList() {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Sun'),
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '1',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Theme.of(context).primaryColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Mon'),
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '2',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Tue'),
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '3',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Wed'),
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '4',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Thu'),
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '5',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Fri'),
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '6',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Sat'),
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '7',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Sun'),
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '8',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
        ],
      ),
    );
  }
}


class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}