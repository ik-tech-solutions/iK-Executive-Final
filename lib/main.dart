import 'dart:io';
import 'package:my_cab_driver/database/auth/autenticacao.dart';
import 'package:my_cab_driver/my_route_observer.dart';
import 'package:my_cab_driver/provider/appdata.dart';
import 'package:my_cab_driver/vehicalManagement/addVehicalScreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/auth/loginScreen.dart';
import 'package:my_cab_driver/setting/settingScreen.dart';
import 'package:my_cab_driver/splashScreen.dart';
import 'appTheme.dart';
import 'auth/signUpScreen.dart';
import 'history/historyScreen.dart';
import 'home/homeScreen.dart';
import 'introduction/LocationScreen.dart';
import 'introduction/introductionScreen.dart';
import 'inviteFriend/inviteFriendScreen.dart';
import 'notification/notificationScree.dart';
import 'package:my_cab_driver/wallet/myWallet.dart';
import 'constance/constance.dart' as constance;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'constance/routes.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
      appId: '1:436224948921:ios:48cf5598accecaa012f968',
      apiKey: 'AIzaSyDFehHeNx1VksCxQ4UTDQUPiL7f_hJ2_RE',
      projectId: 'iklogo',
      messagingSenderId: '960343965422',
      databaseURL: 'https://iklogo-default-rtdb.firebaseio.com',
    )
        : FirebaseOptions(
      appId: '1:436224948921:ios:48cf5598accecaa012f968',
      apiKey: 'AIzaSyDFehHeNx1VksCxQ4UTDQUPiL7f_hJ2_RE',
      messagingSenderId: '960343965422',
      projectId: 'iklogo',
      databaseURL: 'https://iklogo-default-rtdb.firebaseio.com',
    ),
  );
  auth = FirebaseAuth.instance;
  user = auth.currentUser;

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(new MyApp()));
}

class MyApp extends StatefulWidget {
  static setCustomeTheme(BuildContext context, int index) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setCustomeTheme(index);
  }

  static setCustomeLanguage(BuildContext context, String languageCode) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLanguage(languageCode);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = new UniqueKey();


  setCustomeTheme(int index) {
    if (index == 6) {
      setState(() {
        AppTheme.isLightTheme = true;
      });
    } else if (index == 7) {
      setState(() {
        AppTheme.isLightTheme = false;
      });
    } else {
      setState(() {
        constance.colorsIndex = index;
        constance.primaryColorString = ConstanceData().colors[constance.colorsIndex];
        constance.secondaryColorString = constance.primaryColorString;
      });
    }
  }

  String locale = "pt";

  setLanguage(String languageCode) {
    setState(() {
      locale = languageCode;
      constance.locale = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    constance.locale = locale;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
      statusBarBrightness: AppTheme.isLightTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: AppTheme.isLightTheme ? Colors.white : Colors.black,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
    ));
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('fr'), // French
        const Locale('ar'), // Arabic
        const Locale('pt'), // Arabic
      ],
      title: 'iK Executive',
      navigatorObservers: <NavigatorObserver>[
        MyRouteObserver(),
      ],
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      routes: routes,
      navigatorKey: NavigationService.instance.navigationKey,
      builder: (BuildContext context, Widget child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (BuildContext context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                ),
                child: child,
              );
            },
          ),
        );
      },
    );
  }

  var routes = <String, WidgetBuilder>{
    Routes.SPLASH: (BuildContext context) => SplashScreen(),
    Routes.INTRODUCTION: (BuildContext context) => new IntroductionScreen(),
    Routes.ENABLELOCATION: (BuildContext context) => new EnableLocation(),
    Routes.AUTH: (BuildContext context) => new SignUpScreen(),
    Routes.HOME: (BuildContext context) => new HomeScreen(),
    Routes.HISTORY: (BuildContext context) => new HistoryScreen(),
    Routes.NOTIFICATION: (BuildContext context) => new NotificationScreen(),
    Routes.INVITE: (BuildContext context) => new InviteFriendScreen(),
    Routes.SETTING: (BuildContext context) => new SettingScreen(),
    Routes.WALLET: (BuildContext context) => new MyWallet(),
    Routes.LOGIN: (BuildContext context) => new LoginScreen(),
    Routes.VEHICAL: (BuildContext context) => new AddNewVehical(),
  };
}
