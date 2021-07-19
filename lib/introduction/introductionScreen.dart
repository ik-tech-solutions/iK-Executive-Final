import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/constance/routes.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  PageIndicatorLayout layout = PageIndicatorLayout.SLIDE;
  PageController pageController;

  var appBarheight = 0.0;

  initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    pageController = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    appBarheight = AppBar().preferredSize.height;

    var children = <Widget>[
      Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: FadeTransition(
              opacity: animation,
              child: Image.asset(
                ConstanceData.acceptjob,
                fit: BoxFit.cover,
                height: 200,
                width: 200,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          Text(
            AppLocalizations.of('Eficácia'),
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                  color: Theme.of(context).textTheme.headline6.color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 14, right: 14),
            child: Text(
              AppLocalizations.of('Um iK, e já está!'),
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.LOGIN);
            },
            child: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Text(
                  AppLocalizations.of('Pular'),
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: appBarheight,
          ),
        ],
      ),
      Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
          FadeTransition(
            opacity: animation,
            child: Image.asset(
              ConstanceData.enableLocation,
              fit: BoxFit.cover,
              height: 200,
              width: 200,
            ),
          ),
          Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          Text(
            AppLocalizations.of('RAPIDEZ'),
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                  color: Theme.of(context).textTheme.headline6.color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 14, right: 14),
            child: Text(
              AppLocalizations.of('Muito simples e rápido!'),
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.LOGIN);
            },
            child: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Text(
                  AppLocalizations.of('Pular'),
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: appBarheight,
          ),
        ],
      ),
      Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
          FadeTransition(
            opacity: animation,
            child: Image.asset(
              ConstanceData.wallet,
              fit: BoxFit.cover,
              height: 200,
              width: 200,
            ),
          ),
          Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          Text(
            AppLocalizations.of('POUPANÇA'),
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                  color: Theme.of(context).textTheme.headline6.color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 14, right: 14),
            child: Text(
              AppLocalizations.of('Economize tempo e dinheiro!'),
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          Padding(
            padding: EdgeInsets.only(right: 50, left: 50),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.LOGIN);
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of('Começar'),
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ConstanceData.secoundryFontColor,
                        ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: appBarheight,
          ),
        ],
      ),
    ];
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[



                      PageView(
                        controller: pageController,
                        children: children,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: PageIndicator(
                            layout: layout,
                            size: 12,
                            activeSize: 12,
                            controller: pageController,
                            space: 8,
                            count: 3,
                            color: Theme.of(context).dividerColor,
                            activeColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
