import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/models/carteira.dart';
import 'package:my_cab_driver/wallet/paymentMethod.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';

class MyWallet extends StatefulWidget {
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseAuth authFB = FirebaseAuth.instance;

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
            selectItemName: 'Wallet',
          ),
        ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  border: Border.all(
                                    color: ConstanceData.secoundryFontColor,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Text(
                                        AppLocalizations.of('Ganho'),
                                        style: Theme.of(context).textTheme.button.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: ConstanceData.secoundryFontColor,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ConstanceData.secoundryFontColor,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  color: ConstanceData.secoundryFontColor,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Text(
                                        AppLocalizations.of('Total'),
                                        style: Theme.of(context).textTheme.button.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
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
                                    style: Theme.of(context).textTheme.headline3.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
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
                            })
                        ,
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          AppLocalizations.of(''),//Total
                          style: Theme.of(context).textTheme.overline.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 7,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: 32,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14, left: 14, top: 16, bottom: 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of('Histórico'),
                          style: Theme.of(context).textTheme.overline.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).disabledColor,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 2,
                child: StreamBuilder(
                    stream: logisticasPendentesReFuture,
                    builder: (context, AsyncSnapshot<Event> snapshot) {
                      if (snapshot.hasData) {
                        listaLogistica.clear();
                        DataSnapshot dataValues = snapshot.data.snapshot;
                        Map<dynamic, dynamic> values = dataValues.value;
                        if(dataValues.value != null){
                          values.forEach((key, values) {

                            if(values['status'].toString() == "concluido"){
                              listaLogistica.add(values);

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
                                                        },
                                                        child:     Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              CircleAvatar(
                                                                radius: 24,
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(40),
                                                                  child: Image.asset(
                                                                    ConstanceData.userImage,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 16,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Text(
                                                                    AppLocalizations.of(listaLogistica[index]["nome_usuario"]),
                                                                    style: Theme.of(context).textTheme.overline.copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Theme.of(context).disabledColor,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    listaLogistica[index]["referencia"],
                                                                    style: Theme.of(context).textTheme.overline.copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Theme.of(context).disabledColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Expanded(child: SizedBox()),
                                                              Text(
                                                                listaLogistica[index]["pagamento"],
                                                                style: Theme.of(context).textTheme.overline.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Theme.of(context).textTheme.headline6.color,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
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
                                      stream: logisticasDisponiveisReFuture,
                                      builder: (context, AsyncSnapshot<Event> snapshot) {
                                        if (snapshot.hasData) {
                                          logisticasDisponiveisInt = 0;
                                          DataSnapshot dataValues = snapshot.data.snapshot;
                                          Map<dynamic, dynamic> values = dataValues.value;
                                          if(dataValues.value != null){
                                            values.forEach((key, values) {
                                              logisticasDisponiveisInt++;
                                            });
                                            return Text(
                                              "Existe "+logisticasDisponiveisInt.toString() + " encomendas disponíveis á tua espera.",
                                              style: Theme.of(context).textTheme.overline.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: ConstanceData.secoundryFontColor,
                                              ),
                                            );

                                          } else {
                                            return Center( child:Text(
                                              AppLocalizations.of("Não há encomendas disponívies no momento."),
                                              style: Theme.of(context).textTheme.caption.copyWith(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                            );
                                          }
                                        }
                                        return Center( child: CircularProgressIndicator());
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
              ),

            ],
          ),
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40, left: 40),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => PaymentMethod(),
                    //   ),
                    // );
                  },
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 24,
                            child: Text(
                              "Taxa", style: TextStyle( color: ConstanceData.secoundryFontColor)
                             ,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Text(
                            AppLocalizations.of(double.parse(userCarteira.taxa_total).toStringAsFixed(2)  + "€"),
                            style: Theme.of(context).textTheme.subtitle2.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          // Icon(
                          //   Icons.arrow_forward_ios,
                          //   color: Theme.of(context).disabledColor,
                          //   size: 18,
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
                flex: 6,
              )
            ],
          )
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
              AppLocalizations.of('Minha Carteira'),
              style: Theme.of(context).textTheme.headline6.copyWith(
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
