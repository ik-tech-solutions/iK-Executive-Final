import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/constance/routes.dart';
import 'package:my_cab_driver/documentManagement/docManagementScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../appTheme.dart';
import 'myProfile.dart';
import 'package:my_cab_driver/widgets/button.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/vehicalManagement/addVehicalScreen.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  double contactoHeight = 0.0;
  double termosHeight = 0.0;
  String titulo = "";

  showContactoDialog(String tituloEncomenda){
    setState(() {
      contactoHeight=600.0;
      titulo = tituloEncomenda ;

    });
  }
  closeContactoDialog(){
    setState(() {
      contactoHeight=0.0;
    });
  }

  showTermosDialog(String tituloEncomenda){
    setState(() {
      termosHeight = 600.0;
      titulo = tituloEncomenda ;

    });
  }
  closeTermosDialog(){
    setState(() {
      termosHeight = 0.0;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar(),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400
            ? MediaQuery.of(context).size.width * 0.75
            : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'Definições',
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                myProfileDetail(),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 16,
                ),
                userSettings(),
                SizedBox(
                  height: 16,
                ),
                userDocs(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget userDocs() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          // InkWell(
          //   highlightColor: Colors.transparent,
          //   splashColor: Colors.transparent,
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, Routes.NOTIFICATION);
          //   },
          //   child: Padding(
          //     padding:
          //         const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
          //     child: Row(
          //       children: <Widget>[
          //         Container(
          //           height: 26,
          //           width: 26,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(6),
          //             color: HexColor("#5AC8FB"),
          //           ),
          //           child: Padding(
          //             padding: const EdgeInsets.all(4),
          //             child: Icon(
          //               FontAwesomeIcons.solidBell,
          //               size: 16,
          //               color: Colors.white,
          //             ),
          //           ),
          //         ),
          //         SizedBox(
          //           width: 16,
          //         ),
          //         Text(
          //           AppLocalizations.of('Notificações'),
          //           style: Theme.of(context).textTheme.caption.copyWith(
          //                 fontWeight: FontWeight.bold,
          //                 color: Theme.of(context).textTheme.headline6.color,
          //               ),
          //         ),
          //         Expanded(child: SizedBox()),
          //         Icon(
          //           Icons.arrow_forward_ios,
          //           size: 18,
          //           color: Theme.of(context).disabledColor,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              _launchURL();
              // showTermosDialog(AppLocalizations.of('Termos & Políticas de privacidade'));
            },
            child:Padding(
            padding:
                const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
            child: Row(
              children: <Widget>[
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: HexColor("#8F8E93"),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      FontAwesomeIcons.crown,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                    AppLocalizations.of('Termos & Políticas de privacidade'),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                ),
                Expanded(child: SizedBox()),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Theme.of(context).disabledColor,
                ),
              ],
            ),
          ),
    ),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              _launchURL();
              // showContactoDialog(AppLocalizations.of('Sobre nós'));
            },
            child: Padding(
            padding:
                const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
            child: Row(
              children: <Widget>[
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: HexColor("#FF2C56"),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.help,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                    AppLocalizations.of('Sobre nós'),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                ),
                Expanded(child: SizedBox()),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Theme.of(context).disabledColor,
                ),
              ],
            ),
          ),
    ),
        ],
      ),
    );
  }

  Widget userSettings() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewVehical(),
                ),
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor("#FF9503"),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        FontAwesomeIcons.car,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    AppLocalizations.of('Gestão do veículo'),
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
          // InkWell(
          //   highlightColor: Colors.transparent,
          //   splashColor: Colors.transparent,
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => DocmanagementScreen(),
          //       ),
          //     );
          //   },
          //   child: Padding(
          //     padding:
          //         const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
          //     child: Row(
          //       children: <Widget>[
          //         Container(
          //           height: 26,
          //           width: 26,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(6),
          //             color: HexColor("#4BDA65"),
          //           ),
          //           child: Padding(
          //             padding: const EdgeInsets.all(4),
          //             child: Icon(
          //               FontAwesomeIcons.idCard,
          //               color: Colors.white,
          //               size: 16,
          //             ),
          //           ),
          //         ),
          //         SizedBox(
          //           width: 16,
          //         ),
          //         Text(
          //           AppLocalizations.of('Gestão da documentação'),
          //           style: Theme.of(context).textTheme.caption.copyWith(
          //                 fontWeight: FontWeight.bold,
          //                 color: Theme.of(context).textTheme.headline6.color,
          //               ),
          //         ),
          //         Expanded(child: SizedBox()),
          //         Icon(
          //           Icons.arrow_forward_ios,
          //           size: 18,
          //           color: Theme.of(context).disabledColor,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          // Padding(
          //   padding:
          //       const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
          //   child: Row(
          //     children: <Widget>[
          //       Container(
          //         height: 26,
          //         width: 26,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(6),
          //           color: HexColor("#FFCC01"),
          //         ),
          //         child: Padding(
          //           padding: const EdgeInsets.all(4),
          //           child: Icon(
          //             Icons.star,
          //             color: Colors.white,
          //             size: 18,
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         width: 16,
          //       ),
          //       Text(
          //           AppLocalizations.of('Classificações'),
          //         style: Theme.of(context).textTheme.caption.copyWith(
          //               fontWeight: FontWeight.bold,
          //               color: Theme.of(context).textTheme.headline6.color,
          //             ),
          //       ),
          //       Expanded(child: SizedBox()),
          //       Icon(
          //         Icons.arrow_forward_ios,
          //         size: 18,
          //         color: Theme.of(context).disabledColor,
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 60),
          //   child: Container(
          //     height: 1,
          //     color: Theme.of(context).dividerColor,
          //   ),
          // ),
          // InkWell(
          //   highlightColor: Colors.transparent,
          //   splashColor: Colors.transparent,
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => MyProfile(),
          //       ),
          //     );
          //   },
          //   child: Padding(
          //     padding:
          //         const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
          //     child: Row(
          //       children: <Widget>[
          //         Container(
          //           height: 26,
          //           width: 26,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(6),
          //             color: HexColor("#0078FF"),
          //           ),
          //           child: Padding(
          //             padding: const EdgeInsets.all(4),
          //             child: Icon(
          //               FontAwesomeIcons.globeAsia,
          //               color: Colors.white,
          //               size: 16,
          //             ),
          //           ),
          //         ),
          //         SizedBox(
          //           width: 16,
          //         ),
          //         Text(
          //           AppLocalizations.of('Idioma'),
          //           style: Theme.of(context).textTheme.caption.copyWith(
          //                 fontWeight: FontWeight.bold,
          //                 color: Theme.of(context).textTheme.headline6.color,
          //               ),
          //         ),
          //         Expanded(child: SizedBox()),
          //         Icon(
          //           Icons.arrow_forward_ios,
          //           size: 18,
          //           color: Theme.of(context).disabledColor,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }

  _launchURL() async {
    const url = 'https://iktechsolutions.com';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget myProfileDetail() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyProfile(),
          ),
        );
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding:
              const EdgeInsets.only(right: 10, left: 14, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
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
                    AppLocalizations.of(currentUserInfo.nomecompleto),
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                  ),
                  Text(
                    AppLocalizations.of(currentUserInfo.token),
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Theme.of(context).disabledColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget contactoDialog(){

    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft:Radius.circular(15), topRight:Radius.circular(15)),
            boxShadow: [BoxShadow(
                color: Colors.black26,
                blurRadius: 15.0,
                spreadRadius: 0.5,
                offset: Offset(
                    0.7,
                    0.7
                )
            )]
        ),
        height: contactoHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: GestureDetector(
                          onTap: (){
                            closeContactoDialog();
                          },
                          child: Icon(Icons.close)),
                    )

                  ],
                ),
                Container(
                  width: double.infinity,
                  //color:,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(titulo,style: Theme.of(context).textTheme.subtitle2),

                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(dadosDeContactoPadraoGlobal, textAlign: TextAlign.left, style: TextStyle(color: Colors.black26, fontSize: 9)),
                        ),
                        SizedBox(height: 60,),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),

                          ),
                          child: SizedBox(width: 280, height: 60,
                              child:Button(
                                titulo: AppLocalizations.of('Fechar'),
                                onTap: (){
                                  closeContactoDialog();
                                },
                              ) ),
                        ),
                      ],
                    ),
                  ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget termosDialog(){

    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:   Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft:Radius.circular(15), topRight:Radius.circular(15)),
            boxShadow: [BoxShadow(
                color: Colors.black26,
                blurRadius: 15.0,
                spreadRadius: 0.5,
                offset: Offset(
                    0.7,
                    0.7
                )
            )]
        ),
        height: termosHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: GestureDetector(
                          onTap: (){
                            closeTermosDialog();
                          },
                          child: Icon(Icons.close)),
                    )

                  ],
                ),
                Container(
                  width: double.infinity,
                  //color:,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(titulo,style: Theme.of(context).textTheme.subtitle2),

                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(dadosDeTermosPadraoGlobal, textAlign: TextAlign.center, style: TextStyle(color: Colors.black26, fontSize: 12)),
                        ),
                        SizedBox(height: 60,),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),

                          ),
                          child: SizedBox(width: 280, height: 60,
                              child: Button(
                                titulo: AppLocalizations.of('Fechar'),
                                onTap: (){
                                  closeTermosDialog();
                                },
                              ) ),
                        ),
                      ],),
                  ),

                ),
              ],
            ),
          ),
        ),
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
              AppLocalizations.of('Definições'),
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
