import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/constance.dart';
import '../main.dart';
import 'package:my_cab_driver/constance/constance.dart' as constance;
import 'package:my_cab_driver/constance/global.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool selectFirstColor = false;
  bool selectSecondColor = false;
  bool selectThirdColor = false;
  bool selectFourthColor = false;
  bool selectFifthColor = false;
  bool selectSixthColor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width <= 320 ? 36 : 46,
                        child: ClipRRect(
                          borderRadius: MediaQuery.of(context).size.width <= 320 ? BorderRadius.circular(40) : BorderRadius.circular(60),
                          child: Image.asset(
                            ConstanceData.userImage,
                          ),
                        ),
                      ),
                      Text(
                        currentUserInfo.nomecompleto,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.headline6.color,
                            ),
                      ),
                      Text(
                        "SEU IKTOKEN: "+currentUserInfo.token,
                        style: Theme.of(context).textTheme.caption.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              openShowPopup();
            },
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('Tema'),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.headline6.color,
                          ),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).disabledColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          // InkWell(
          //   highlightColor: Colors.transparent,
          //   splashColor: Colors.transparent,
          //   onTap: () {
          //     openShowPopupLanguage();
          //   },
          //   child: Container(
          //     color: Theme.of(context).scaffoldBackgroundColor,
          //     child: Padding(
          //       padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
          //       child: Row(
          //         children: <Widget>[
          //           Text(
          //             AppLocalizations.of('Idioma'),
          //             style: Theme.of(context).textTheme.caption.copyWith(
          //                   fontWeight: FontWeight.bold,
          //                   color: Theme.of(context).textTheme.headline6.color,
          //                 ),
          //           ),
          //           Expanded(child: SizedBox()),
          //           Icon(
          //             Icons.arrow_forward_ios,
          //             size: 16,
          //             color: Theme.of(context).disabledColor,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Text(
                  AppLocalizations.of('Dados pessoais'),
                  style: Theme.of(context).textTheme.overline.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).disabledColor,
                      ),
                ),
              ],
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              openShowPopupLanguage();
            },
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('Nome'),
                      style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      currentUserInfo.nomecompleto,
                      style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).disabledColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              openShowPopupLanguage();
            },
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('Telefone'),
                      style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      currentUserInfo.telefone,
                      style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).disabledColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              openShowPopupLanguage();
            },
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('E-mail'),
                      style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      currentUserInfo.email,
                      style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).disabledColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          // InkWell(
          //   highlightColor: Colors.transparent,
          //   splashColor: Colors.transparent,
          //   onTap: () {
          //     openShowPopupLanguage();
          //   },
          //   child: Container(
          //     color: Theme.of(context).scaffoldBackgroundColor,
          //     child: Padding(
          //       padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
          //       child: Row(
          //         children: <Widget>[
          //           Text(
          //             AppLocalizations.of('Senha'),
          //             style: Theme.of(context).textTheme.caption.copyWith(
          //               fontWeight: FontWeight.bold,
          //               color: Theme.of(context).textTheme.headline6.color,
          //             ),
          //           ),
          //           Expanded(child: SizedBox()),
          //           Text(
          //             AppLocalizations.of('******'),
          //             style: Theme.of(context).textTheme.caption.copyWith(
          //               fontWeight: FontWeight.bold,
          //               color: Theme.of(context).disabledColor,
          //             ),
          //           ),
          //           SizedBox(
          //             width: 4,
          //           ),
          //           Icon(
          //             Icons.arrow_forward_ios,
          //             size: 16,
          //             color: Theme.of(context).disabledColor,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 3,
            child: ListView(
              children: <Widget>[
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: <Widget>[

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  openShowPopupLanguage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                AppLocalizations.of('Seleccione o idioma'),
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline6.color,
                      fontSize: 18,
                    ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('en');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'English',
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('fr');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of('French'),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('ar');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of('Arabic'),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('ja');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of('Japanese'),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  selectLanguage(String languageCode) {
    constance.locale = languageCode;
    MyApp.setCustomeLanguage(context, languageCode);
  }

  openShowPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                AppLocalizations.of('Seleccione o tema'),
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline6.color,
                      fontSize: 18,
                    ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        changeColor(light);
                      },
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: Theme.of(context).textTheme.headline6.color,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 32,
                          child: Text(
                            AppLocalizations.of('Light'),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        changeColor(dark);
                      },
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: Theme.of(context).textTheme.headline6.color,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 32,
                          child: Text(
                            AppLocalizations.of('Dark'),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        selectfirstColor();
                      },
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(0xFFEB1165),
                        child: !selectFirstColor
                            ? CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.white,
                              )
                            : SizedBox(),
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        selectsecondColor();
                      },
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(0xFF32a852),
                        child: selectSecondColor
                            ? CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.white,
                              )
                            : SizedBox(),
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        selectthirdColor();
                      },
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(0xFFe6230e),
                        child: selectThirdColor
                            ? CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.white,
                              )
                            : SizedBox(),
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        selectfourthColor();
                      },
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(0xFF760ee6),
                        child: selectFourthColor
                            ? CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.white,
                              )
                            : SizedBox(),
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        selectfifthColor();
                      },
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(0xFFdb0ee6),
                        child: selectFifthColor
                            ? CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.white,
                              )
                            : SizedBox(),
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        selectsixthColor();
                      },
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(0xFFdb164e),
                        child: selectSixthColor
                            ? CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.white,
                              )
                            : SizedBox(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  selectfirstColor() {
    if (selectFirstColor) {
      setState(() {
        selectFirstColor = false;
        selectSecondColor = false;
        selectThirdColor = false;
        selectFourthColor = false;
        selectFifthColor = false;
        selectSixthColor = false;
      });
      MyApp.setCustomeTheme(context, 0);
    }
  }

  selectsecondColor() {
    if (!selectSecondColor) {
      setState(() {
        selectFirstColor = true;
        selectSecondColor = true;
        selectThirdColor = false;
        selectFourthColor = false;
        selectFifthColor = false;
        selectSixthColor = false;
      });
      MyApp.setCustomeTheme(context, 1);
    }
  }

  selectthirdColor() {
    if (!selectThirdColor) {
      setState(() {
        selectFirstColor = true;
        selectSecondColor = false;
        selectThirdColor = true;
        selectFourthColor = false;
        selectFifthColor = false;
        selectSixthColor = false;
      });
    }
    MyApp.setCustomeTheme(context, 2);
  }

  selectfourthColor() {
    if (!selectFourthColor) {
      setState(() {
        selectFirstColor = true;
        selectSecondColor = false;
        selectThirdColor = false;
        selectFourthColor = true;
        selectFifthColor = false;
        selectSixthColor = false;
      });
    }
    MyApp.setCustomeTheme(context, 3);
  }

  selectfifthColor() {
    if (!selectFifthColor) {
      setState(() {
        selectFirstColor = true;
        selectSecondColor = false;
        selectThirdColor = false;
        selectFourthColor = false;
        selectFifthColor = true;
        selectSixthColor = false;
      });
    }
    MyApp.setCustomeTheme(context, 4);
  }

  selectsixthColor() {
    if (!selectSixthColor) {
      setState(() {
        selectFirstColor = true;
        selectSecondColor = false;
        selectThirdColor = false;
        selectFourthColor = false;
        selectFifthColor = false;
        selectSixthColor = true;
      });
    }
    MyApp.setCustomeTheme(context, 5);
  }

  int light = 1;
  int dark = 2;

  changeColor(int color) {
    if (color == light) {
      MyApp.setCustomeTheme(context, 6);
    } else {
      MyApp.setCustomeTheme(context, 7);
    }
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              child: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          Text(
            AppLocalizations.of('Perfil'),
            style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          SizedBox(),
        ],
      ),
    );
  }
}
