import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:my_cab_driver/auth/signUpScreen.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/routes.dart';
import 'package:my_cab_driver/appTheme.dart';
import 'package:my_cab_driver/database/auth/autenticacao.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Country _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode('IN');
  var appBarheight = 0.0;
  String countryCode = "+351";

  var txtemailLogin = TextEditingController();
  var txtpasswordLogin = TextEditingController();

  @override
  Widget build(BuildContext context) {
    appBarheight =
        AppBar().preferredSize.height + MediaQuery
            .of(context)
            .padding
            .top;
    return Scaffold(
      // backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery
                .of(context)
                .size
                .height,
            minWidth: MediaQuery
                .of(context)
                .size
                .width),


        child: Stack(
            children: <Widget>[
              Positioned( //
                top: 40,
                child: Image(
                  image: AssetImage(ConstanceData.login_app),
                  // fit : BoxFit.fill,

                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                ),
              ),

              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 14, left: 14),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            SizedBox(
                              height: appBarheight,
                            ),
                            Card(
                              color: Theme
                                  .of(context)
                                  .scaffoldBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: Stack(
                                      alignment: AlignmentDirectional
                                          .bottomCenter,
                                      children: <Widget>[
                                        Positioned(  //
                                          top: 0,
                                          child: Image(
                                            image: AssetImage(ConstanceData.login_app),
                                            // fit : BoxFit.fill,

                                            height: MediaQuery.of(context).size.height,
                                          ),
                                        ),

                                        Animator(
                                          tween: Tween<Offset>(
                                            begin: Offset(0, 0.4),
                                            end: Offset(0, 0),
                                          ),
                                          duration: Duration(seconds: 1),
                                          cycles: 1,
                                          builder: (anim) =>
                                              SlideTransition(
                                                position: anim,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: 70,
                                                      left: 135,
                                                      right: 18),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: <Widget>[
                                                          Center(
                                                            child: Text(
                                                              AppLocalizations
                                                                  .of('LOGIN'),
                                                              style: Theme
                                                                  .of(context)
                                                                  .textTheme
                                                                  .subtitle2
                                                                  .copyWith(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                color: Theme.of(context).primaryColor,
                                                              ),
                                                            ),
                                                          ),

                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                        ),

                                        Animator(
                                          tween: Tween<Offset>(
                                            begin: Offset(0, 0.4),
                                            end: Offset(0, 0),
                                          ),
                                          duration: Duration(seconds: 1),
                                          cycles: 1,
                                          builder: (anim) =>
                                              SlideTransition(
                                                position: anim,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: 20,
                                                      left: 135,
                                                      right: 18),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: <Widget>[


                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 16),
                                    child: Column(
                                      children: <Widget>[
                                        _emailLoginUI(),
                                        _passwordLoginUI(),
                                        InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            Center( child: showLoaderDialog(context));
                                            Autenticacao.login(txtemailLogin.text,txtpasswordLogin.text, context);


                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of('ENTRAR'),
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .button
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme
                                                      .of(context)
                                                      .scaffoldBackgroundColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(' '), //Pode colocar texto
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                    color:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .headline6
                                        .color,
                                  ),
                                ),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of('Registar-me agora!'),
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .headline6
                                          .color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

            ]
        ),

      ),
    );
  }

  Widget _emailLoginUI() {
    return Padding(
      padding: const EdgeInsets.only(top:5,left:5,bottom:16,right:5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(38)),
          border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            height: 50,
            child: Center(
              child: TextField(
                maxLines: 1,
                controller: txtemailLogin,
                keyboardType: TextInputType.emailAddress,
                //onChanged: (String txt) {},
                cursorColor: Theme.of(context).primaryColor,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: "nome@exemplo.com",
                  hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordLoginUI() {
    return Padding(
      padding: const EdgeInsets.only(top:5,left:5,bottom:16,right:5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(38)),
          border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            height: 50,
            child: Center(
              child: TextField(
                controller:txtpasswordLogin,
                autocorrect: false,
                obscureText: true,
                maxLines: 1,
                onChanged: (String txt) {},
                cursorColor: Theme.of(context).primaryColor,
                decoration: new InputDecoration(
                  // errorText: isValidateLogin ? 'Informe a palavra passe' : null,
                  border: InputBorder.none,
                  hintText: "Palavra passe",
                  hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  String getCountryString(String str) {
    var newString = '';
    var isFirstdot = false;
    for (var i = 0; i < str.length; i++) {
      if (isFirstdot == false) {
        if (str[i] != ',') {
          newString = newString + str[i];
        } else {
          isFirstdot = true;
        }
      }
    }
    return newString;
  }
}
