import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import '../appTheme.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'Notificações',
          ),
        ),
      ),
      appBar: appBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: HexColor("#4252FF"),
                          radius: 14,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('System'),
                              style: Theme.of(context).textTheme.caption.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.headline6.color,
                                  ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              AppLocalizations.of('Booking #1234 has been succsess.'),
                              style: Theme.of(context).textTheme.overline.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.headline6.color,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 16,
          )
        ],
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of('Notifications'),
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline6.color,
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
