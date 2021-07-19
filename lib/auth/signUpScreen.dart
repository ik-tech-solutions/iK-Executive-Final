import 'dart:io';

import 'package:animator/animator.dart';
import 'package:country_code_picker/country_code_picker.dart';
// import 'package:country_pickers/country.dart';
// import 'package:country_pickers/country_picker_dialog.dart';
// import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/auth/phoneAuthScreen.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/database/auth/autenticacao.dart';
import 'package:url_launcher/url_launcher.dart';
import 'loginScreen.dart';
import 'package:my_cab_driver/extension/string_extension.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();

}

class _SignUpScreenState extends State<SignUpScreen> {
  var appBarheight = 0.0;
  String countryCode = "+351";

  bool isValidate = false;
  String phoneNumber = '';
  var txtnome = TextEditingController();
  var txtemail = TextEditingController();
  var txtphone = TextEditingController();
  var txtpassword = TextEditingController();


  // Country _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode('IN');

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tem certeza?'),
            content: Text('Você saíra sem ter feito o cadastro!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Não'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Sim'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

              @override
              Widget build(BuildContext context) {
                appBarheight =
                    AppBar().preferredSize.height + MediaQuery.of(context).padding.top;


               return Scaffold(


                  backgroundColor: Theme.of(context).backgroundColor,
                  body: WillPopScope(
                    onWillPop: _onBackPressed,
                    child: Container(
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
                                   color: Theme.of(context).scaffoldBackgroundColor,
                                   shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(15.0),
                                   ),
                                   child: Column(
                                   children: <Widget>[
                                   Container(
                                   height: 150,
                decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                ),
                ),
                child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                Positioned(  //
                top: 0,
                child: Image(
                image: AssetImage(ConstanceData.login_app),
                // fit : BoxFit.fill,

                height: MediaQuery.of(context).size.height,
                ),
                ),
                Padding(
                padding: const EdgeInsets.only(
                top: 70, left: 130, right: 18),
                child: Column(
                children: <Widget>[
                Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: <Widget>[
                Text(
                AppLocalizations.of('Registo'),
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor
                ),
                ),
                ],
                ),
                // Row(
                //   crossAxisAlignment:
                //       CrossAxisAlignment.start,
                //   children: <Widget>[
                //     Text(
                //       AppLocalizations.of(
                //           'email and phone'),
                //       style: Theme.of(context)
                //           .textTheme
                //           .headline5
                //           .copyWith(
                //             color: ConstanceData
                //                 .secoundryFontColor,
                //           ),
                //     ),
                //   ],
                // ),

                ],
                ),
                ),
                ],
                ),
                ),
                SizedBox(
                height: 14,
                ),
                Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Column(
                children: <Widget>[
                  _nameUI(),
                  _emailUI(),
                  _countryView(),
                  _passwordUI(),

                InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {

                  validateTextField(txtnome.text, txtemail.text, txtpassword.text, txtphone.text);

                  Center( child: showLoaderDialog(context));
                  Autenticacao.registrarUsuario(txtnome.text,txtemail.text,txtphone.text,txtpassword.text, context);

                },
                child: Container(
                height: 40,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
                ),
                child: Center(
                child: Text(
                AppLocalizations.of('Registar-se'),
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
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
                AppLocalizations.of('Já tem uma conta?'),
                style: Theme.of(context).textTheme.button.copyWith(
                color:
                Theme.of(context).textTheme.headline6.color,
                ),
                ),
                InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => LoginScreen(),
                ),
                );
                },
                child: Text(
                AppLocalizations.of(' Login'),
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .headline6
                    .color,
                fontWeight: FontWeight.bold,
                ),
                ),
                ),

                ],
                ),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: <Widget>[
                                        SizedBox(height: 4,),

                                         InkWell(
                                           highlightColor: Colors.transparent,
                                           splashColor: Colors.transparent,
                                           onTap: () {
                                             _launchURL();
                                           },
                                           child: Text(
                                             AppLocalizations.of(' Termos de Uso e Políticas de privacidade'),
                                             style: Theme.of(context).textTheme.overline.copyWith(
                                               color: Theme.of(context)
                                                   .textTheme
                                                   .headline6
                                                   .color,
                                               fontWeight: FontWeight.bold,
                                               fontSize: 8,
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

  Widget _emailUI() {
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
                controller: txtemail,
                keyboardType: TextInputType.emailAddress,
                //onChanged: (String txt) {},
                cursorColor: Theme.of(context).primaryColor,
                decoration: new InputDecoration(
                  // labelText: 'E-mail',
                  // errorText: isValidate ? 'Informe o e-mail' : null,
                  border: InputBorder.none,
                  hintText: "nome@example.com",
                  hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _passwordUI() {
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
                controller:txtpassword,
                autocorrect: false,
                obscureText: true,
                maxLines: 1,
                onChanged: (String txt) {},
                cursorColor: Theme.of(context).primaryColor,
                decoration: new InputDecoration(
                  // labelText: 'Palavra passe',
                  // errorText: isValidate ? 'Informe a senha' : null,
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
  Widget _nameUI() {

    return Padding(
      padding: const EdgeInsets.all(16),
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
                controller: txtnome,
                maxLines: 1,
                //onChanged: (String txt) {},
                cursorColor: Theme.of(context).primaryColor,
                decoration: new InputDecoration(
                  // labelText: 'Nome completo',
                  // errorText: isValidate ? 'Informe o seu nome completo' : null,
                  border: InputBorder.none,
                  hintText: "Nome completo",
                  hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _countryView() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(38)),
          border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 80,
              height: 40,
              child: CountryCodePicker(
                onChanged: (e) {
                  print(e.toLongString());
                  print(e.name);
                  print(e.code);
                  print(e.dialCode);
                  setState(() {
                    countryCode = e.dialCode;
                  });
                },
                initialSelection: 'PT',
                showFlagMain: true,
                showFlag: true,
                favorite: ['+351','PT'],
              ),
            ),
            Container(
              color: Theme.of(context).dividerColor,
              height: 32,
              width: 1,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 16),
                child: Container(
                  height: 38,
                  child: TextField(
                    controller:txtphone,
                    maxLines: 1,
                    onChanged: (String txt) {
                      phoneNumber = txt.removeZeroInNumber;
                    },
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: new InputDecoration(
                      // labelText: '  Telefone',
                      // errorText: isValidate ? 'Informe o telefone' : null,
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(" Phone Number"),
                      hintStyle:
                      TextStyle(color: Theme.of(context).disabledColor),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  bool validateTextField(String nomeInput, String emailInput, String senhaInput, String phoneInput ) {
    if (nomeInput.isEmpty || emailInput.isEmpty || senhaInput.isEmpty || phoneInput.isEmpty) {
      setState(() {
        isValidate = true;
      });
      return false;
    } else {
      setState(() {
        isValidate = false;
      });
      return true;}
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

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Formato de e-mail inválido!';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'A senha deve conter 6 caracteres no minímo!';
    } else {
      return null;
    }
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
