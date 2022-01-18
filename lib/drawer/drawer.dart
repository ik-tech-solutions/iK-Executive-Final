import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/home/homeScreen.dart';
import 'package:my_cab_driver/home/rotasPendentesList.dart';
import 'package:my_cab_driver/constance/routes.dart';
import 'package:my_cab_driver/database/auth/autenticacao.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/models/usuario.dart';
import 'package:my_cab_driver/wallet/agenda.dart';
import 'package:share/share.dart';

class AppDrawer extends StatefulWidget {
  final String selectItemName;

  const AppDrawer({Key key, this.selectItemName}) : super(key: key);
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  final FirebaseAuth authFB = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: new ClipRRect(
                            borderRadius: new BorderRadius.circular(50),
                            child: Image.asset(
                              ConstanceData.userImage,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            StreamBuilder(
                                stream: FirebaseDatabase.instance.reference().child('motorista/${authFB.currentUser.uid}/perfil').onValue,
                                builder: (context, AsyncSnapshot<Event> snapshot) {
                                  if (snapshot.hasData) {

                                    DataSnapshot dataValues = snapshot.data.snapshot;
                                    Map<dynamic, dynamic> values = dataValues.value;

                                    if(dataValues.value != null){

                                      Usuario currentUser = Usuario.fromSnapshot(dataValues);


                                      return  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                      Text(
                                      AppLocalizations.of(currentUser.nomecompleto),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: ConstanceData.secoundryFontColor,
                                  ),
                                      ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                  Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[

                                    Text(
                                      currentUser.token + "  ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: ConstanceData.secoundryFontColor,
                                      ),

                                    ),
                                    InkWell(
                                      onTap: () {
                                        Share.share(currentUser.token);
                                      },
                                      child:  Icon(
                                        Icons.share,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),

                                  ]),

                                        ],
                                      );




                                    } else {
                                      return Center( child:Text(
                                        AppLocalizations.of('Sem nome'),
                                        style: Theme.of(context).textTheme.overline.copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      )
                                      );
                                    }
                                  }
                                  return Text("...");
                                }),

                            SizedBox(
                              height: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          // rotasPedentes(),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: columDetail(),
          )
        ],
      ),
    );
  }

  Widget rotasPedentes() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RotasPendentesList(),
                fullscreenDialog: true,
              ),
            );
          },
          child: Container(
            height: 2,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
            ),
            child: Center(
              child: Text(
                AppLocalizations.of('Serviços pendentes'),
                style: Theme.of(context).textTheme.button.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ConstanceData.secoundryFontColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget columDetail() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 26,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Home') {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                        fullscreenDialog: true,
                      ),
                    );

                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, Routes.HOME, (Route<dynamic> route) => false);
                  }
                },
                child: Row(
                  children: <Widget>[
                    widget.selectItemName == 'Início'
                        ? selectedData()
                        : SizedBox(),
                    Icon(
                      Icons.home,
                      size: 28,
                      color: widget.selectItemName == 'Início'
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).dividerColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      AppLocalizations.of('Início'),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.headline6.color,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Carteira') {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.WALLET,
                        (Route<dynamic> route) => false);

                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //   content: Text("Em tratamento"),
                    // ));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'Carteira'
                          ? selectedData()
                          : SizedBox(),
                      Icon(
                        FontAwesomeIcons.wallet,
                        size: 20,
                        color: widget.selectItemName == 'Carteira'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Carteira'),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Agenda') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Agenda(),
                        fullscreenDialog: true,
                      ),
                    );

                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //   content: Text("Em tratamento"),
                    // ));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'Agenda'
                          ? selectedData()
                          : SizedBox(),
                      Icon(
                        FontAwesomeIcons.database,
                        size: 20,
                        color: widget.selectItemName == 'Agenda'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Agenda'),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                          Theme.of(context).textTheme.headline6.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Rotas pendentes') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RotasPendentesList(),
                        fullscreenDialog: true,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'Rotas pendentes'
                          ? selectedData()
                          : SizedBox(),
                      Icon(
                        FontAwesomeIcons.carAlt,
                        size: 20,
                        color: widget.selectItemName == 'Rotas pendentes'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Meus Serviços'),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Histórico') {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.HISTORY,
                        (Route<dynamic> route) => false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'Histórico'
                          ? selectedData()
                          : SizedBox(),
                      Icon(
                        FontAwesomeIcons.history,
                        size: 20,
                        color: widget.selectItemName == 'Histórico'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Histórico'),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              // InkWell(
              //   highlightColor: Colors.transparent,
              //   splashColor: Colors.transparent,
              //   onTap: () {
              //     Navigator.pop(context);
              //     if (widget.selectItemName != 'Notificações') {
              //       Navigator.pushNamedAndRemoveUntil(context,
              //           Routes.NOTIFICATION, (Route<dynamic> route) => false);
              //     }
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 4),
              //     child: Row(
              //       children: <Widget>[
              //         widget.selectItemName == 'Notificações'
              //             ? selectedData()
              //             : SizedBox(),
              //         Icon(
              //           FontAwesomeIcons.solidBell,
              //           size: 20,
              //           color: widget.selectItemName == 'Notificações'
              //               ? Theme.of(context).primaryColor
              //               : Theme.of(context).dividerColor,
              //         ),
              //         SizedBox(
              //           width: 10,
              //         ),
              //         Text(
              //           AppLocalizations.of('Notificações'),
              //           style: Theme.of(context).textTheme.bodyText2.copyWith(
              //                 fontWeight: FontWeight.bold,
              //                 color:
              //                     Theme.of(context).textTheme.headline6.color,
              //               ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 32,
              // ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  if (widget.selectItemName != 'Definições') {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.SETTING,
                        (Route<dynamic> route) => false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      widget.selectItemName == 'Definições'
                          ? selectedData()
                          : SizedBox(),
                      Icon(
                        FontAwesomeIcons.cog,
                        size: 20,
                        color: widget.selectItemName == 'Definições'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Definições'),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {

                  Autenticacao.logOut(context);

                  // Navigator.pushNamedAndRemoveUntil(context,
                  //     Routes.INTRODUCTION, (Route<dynamic> route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.signOutAlt,
                        size: 20,
                        color: Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of('Sair'),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).padding.bottom + 16,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 28,
          width: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

}
