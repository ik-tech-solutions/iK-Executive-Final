import 'package:flutter/material.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/constance/routes.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';

class EnableLocation extends StatefulWidget {
  @override
  _EnableLocationState createState() => _EnableLocationState();
}

class _EnableLocationState extends State<EnableLocation> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SizedBox(),
              flex: 4,
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
              flex: 3,
            ),
            Text(
              AppLocalizations.of('Enable Your Location'),
              style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Theme.of(context).textTheme.headline6.color,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(left: 14, right: 14),
              child: Text(
                AppLocalizations.of('Lorem ipsum dolor sit amet, consectetur adipisc elit. Nullam ac vestibulum erat.'),
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Theme.of(context).textTheme.headline6.color,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
            Padding(
              padding: EdgeInsets.only(right: 50, left: 50),
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.AUTH);
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of('USE MY LOCATION'),
                      style: Theme.of(context).textTheme.button.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ConstanceData.secoundryFontColor,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(),
              flex: 1,
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.AUTH);
              },
              child: SizedBox(
                height: 40,
                child: Center(
                  child: Text(
                    AppLocalizations.of('Skip for now'),
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Theme.of(context).disabledColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
