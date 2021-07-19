import 'dart:convert';
import 'dart:io';

import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/notification/notification.dart';
import 'package:my_cab_driver/pickup/dropoffScreen.dart';
import 'package:my_cab_driver/pickup/pickupScreen.dart';
import 'package:my_cab_driver/vehicalManagement/addVehicalScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Language/LanguageData.dart';
import 'constance/constance.dart' as constance;
import 'package:my_cab_driver/constance/routes.dart';
import 'package:my_cab_driver/database/HelperMethods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_cab_driver/auth/loginScreen.dart';
import 'package:my_cab_driver/constance/global.dart' as globals;
import 'package:my_cab_driver/constance/global.dart';
import 'package:get_version/get_version.dart';
import 'models/usuario.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  BuildContext myContext;

  final FirebaseAuth authFB = FirebaseAuth.instance;

  bool saoVersoesDiferentes = false;

  Future<void> _initPackageInfo() async {
    await HelperMethods.getVersaoDoApp();

    String projectVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }

    setState(() {

      print("Versao do APP : ========================================== " +  "  |  Nwe: " + projectVersion);

      projectVersion == versaoDoApp ? print("Versao do APP Comparando : ========================================== " + projectVersion + "|" + versaoDoApp ) : print("Versao do APP Comparando : ========================================== " + projectVersion + "|" +  versaoDoApp);

    });
    //Se as versões forem diferentes actualizar AlertDialog
    if(projectVersion != versaoDoApp){
      saoVersoesDiferentes = true;
      showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Nova versão disponível!'),
          content: new Text('Atualize o App para ' + versaoDoApp, style: TextStyle(color: Colors.orange),),
          actions: <Widget>[
            TextButton(
              onPressed: () => exit(0),
              child: new Text('Mais tarde'),
            ),
            TextButton(
              onPressed: () => _launchURL(),
              child: new Text('Atualizar', style: TextStyle(color: Colors.green),),
            ),
          ],
        ),
      );
      return;
    }

  }

  _launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=com.ik.ikdriver';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  initState() {
    super.initState();


    _initPackageInfo();



    HelperMethods.getCurrentUserInfo();
    HelperMethods.getVeiculoDados();
    HelperMethods.getCarList();
    HelperMethods.getTaxasDaEmpresa();
    HelperMethods.getServicosAdicionais();
    HelperMethods.getTiposDeCasas();
    HelperMethods.getTermosContactos();
    HelperMethods.getFeriadosList();

    myContext = context;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("=======================---------------- " + saoVersoesDiferentes.toString());
        if(!saoVersoesDiferentes) {
          print("=======================---------------- " + saoVersoesDiferentes.toString());
          _loadNextScreen();
        }
      }
    });
    animationController.forward();



  }

  checkUserStatus() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      prefs.setBool('first_time', false);
      if (user != null) {
        DatabaseReference veiculoRegistradoRef = FirebaseDatabase.instance
            .reference()
            .child('motorista')
            .child('${authFB.currentUser.uid}')
            .child("veiculo");
        veiculoRegistradoRef.once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            checkPerfilStatus();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Finalize o seu registro cadastrando os dados do seu veículo comercial"),
              duration: const Duration(seconds: 10),
            ));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNewVehical(),
              ),
            );
          }
        });
      } else {
        Navigator.pushReplacementNamed(context, Routes.INTRODUCTION);
      }
    } else {
      prefs.setBool('first_time', false);
      Navigator.pushReplacementNamed(context, Routes.INTRODUCTION);
    }
  }

  checkPerfilStatus() async {


    DatabaseReference userPerfilRef = FirebaseDatabase.instance
        .reference()
        .child('motorista/${authFB.currentUser.uid}/perfil');

    userPerfilRef.once().then((DataSnapshot snapshot) async {
      if (snapshot.value != null) {
        currentUserInfo = Usuario.fromSnapshot(snapshot);
        print('my status ${currentUserInfo.status}');
        nomeUsuario = currentUserInfo.nomecompleto;
        print('Status of: $nomeUsuario');

        if (currentUserInfo.status == "aguardando") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "A sua conta ainda está em análise. Brevemente entraremos em contacto consigo por meio do seu e-mail."),
            duration: const Duration(seconds: 19),
          ));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewVehical(),
            ),
          );
        } else {




          await FirebaseDatabase.instance.reference().child('logistica').orderByChild('id_motorista').equalTo(currentUserInfo.id).once().then((DataSnapshot snapshot){

            DataSnapshot dataValues = snapshot;
            Map<dynamic, dynamic> values = dataValues.value;

            if(snapshot.value!=null){
              values.forEach((key, values) {

                if(values['status'] == "em execução"){
                  home_check_LogisticKey = values['key'].toString();
                  home_check = 1;

                }
                if(values['status'] == "entregando"){
                  home_check_LogisticKey = values['key'].toString();
                  home_check = 2;

                }



              });
            }
          });

          print("HOME CHECK ========================== " + home_check.toString() + "  |  " + home_check_LogisticKey.toString());

          //Verificar o Estado da variavel
          if(home_check == 0){
            // Liberado
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.HOME, (Route<dynamic> route) => false);
          } else if(home_check == 1){

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PickupScreen(logisticaKey: home_check_LogisticKey,),
              ),
            );

          } else if(home_check == 2){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DropOffScreen(logisticaKey: home_check_LogisticKey,),
              ),
            );

          }



        }
      }
    });
  }

  _loadNextScreen() async {
    if (!mounted) return;
    if (constance.allTextData == null) {
      constance.allTextData = AllTextData.fromJson(json.decode(
          await DefaultAssetBundle.of(myContext)
              .loadString("jsonFile/languagetext.json")));
    }
    await Future.delayed(const Duration(milliseconds: 1200));
    checkUserStatus();
    // Navigator.pushReplacementNamed(context, Routes.INTRODUCTION);
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globals.locale = Localizations.localeOf(context);

    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width),
        child: Stack(children: <Widget>[
          Positioned.fill(
            //
            child: Image(
              image: AssetImage(ConstanceData.app_splash),
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SizedBox(),
                  flex: 1,
                ),
                FadeTransition(
                  opacity: animation,
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Image.asset(
                      ConstanceData.appicon,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.1,
                ),
                Container(
                  height: 1,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FadeTransition(
                  opacity: animation,
                  child: Text(
                    'iK Executive',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Theme.of(context).backgroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                  flex: 2,
                ),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).backgroundColor),
                  strokeWidth: 2,
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
