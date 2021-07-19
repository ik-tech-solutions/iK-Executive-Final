import 'package:flutter/material.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/routes.dart';


class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  var appBarheight = 0.0;
  var otpController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    appBarheight = AppBar().preferredSize.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 14, left: 14),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: appBarheight,
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: appBarheight,
                ),
                Text(
                  AppLocalizations.of('Verificação'),
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  AppLocalizations.of('Informe o OTP enviado aqui'),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: getOtpTextUI(otptxt: otpController.text),
                      ),
                      Opacity(
                        opacity: 0.0,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextField(
                                          controller: otpController,
                                          maxLength: 4,
                                          onChanged: (String txt) {
                                            setState(() {});
                                          },
                                          onTap: () {},
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                          decoration: new InputDecoration(
                                              errorText: null,
                                              border: InputBorder.none,
                                              labelStyle: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              counterText: ""),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32, left: 32),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context, Routes.HOME, (Route<dynamic> route) => false);
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of('VERIFICAR'),
                          style: Theme.of(context).textTheme.button.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                      ),
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

  Widget getOtpTextUI({String otptxt = ""}) {
    List<Widget> otplist = List<Widget>();
    Widget getUI({String otxt = ""}) {
      return Expanded(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 12,
            ),
            Text(
              otxt,
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 2.5,
                width: 50,
                color: Theme.of(context).dividerColor,
              ),
            )
          ],
        ),
      );
    }

    for (var i = 0; i < 6; i++) {
      otplist.add(getUI(otxt: otptxt.length > i ? otptxt[i] : ""));
    }
    return Row(
      children: otplist,
    );
  }
}
