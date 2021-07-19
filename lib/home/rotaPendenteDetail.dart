import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/appTheme.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/pickup/pickupScreen.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/home/chatScreen.dart';

class RotaPendenteDetailScreen extends StatefulWidget {
  final int userId;

  const RotaPendenteDetailScreen({Key key, this.userId}) : super(key: key);
  @override
  _RotaPendenteDetailScreenState createState() => _RotaPendenteDetailScreenState();
}

class _RotaPendenteDetailScreenState extends State<RotaPendenteDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appbar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                userDetailbar(),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).dividerColor,
                ),
                pickupAddress(),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                dropOffAddress(),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                dadosDoRemetente(),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).dividerColor,
                ),
                noted(),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        MySeparator(
                          color: Theme.of(context).primaryColor,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                tripFare(),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        MySeparator(
                          color: Theme.of(context).primaryColor,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                pickup(),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }

  Widget pickup() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14, top: 16, bottom: 16),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PickupScreen(),
              ),
            );
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
            ),
            child: Center(
              child: Text(
                AppLocalizations.of('IR ATÉ A COLECTA'),
                style: Theme.of(context).textTheme.button.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ConstanceData.secoundryFontColor,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tripFare() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of('ARTIGOS'),
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of('ApplePay'),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                ),
                Text(
                  '\$15.00',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of('Discount'),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                ),
                Text(
                  '\$10.00',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of('Paid amount'),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                ),
                Text(
                  '\$25.00',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget noted() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of('INSTRUÇÃO'),
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 4,
            ),
            Wrap(
              children: <Widget>[
                Text(
                  AppLocalizations.of(
                      'Lorem ipsum dolor sit amet, consectetur adipisc elit. Nullam ac vestibulum erat. Cras vulputate auctor lectus at consequat.'),
                  style: Theme.of(context).textTheme.overline.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dropOffAddress() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of('LOCAL DE ENTREGA'),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  AppLocalizations.of('115 William St, Chicago, US'),
                  style: Theme.of(context).textTheme.overline.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dadosDoRemetente() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of('DADOS DO DESTINATÁRIO'),
                  style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  AppLocalizations.of('Eduardo Junior, +2588412345678'),
                  style: Theme.of(context).textTheme.overline.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget pickupAddress() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of('LOCAL DE COLECTA'),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  AppLocalizations.of('79 Swift Village'),
                  style: Theme.of(context).textTheme.overline.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget userDetailbar() {
    return Container(
      color: Theme.of(context).dividerColor,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                ConstanceData.userImage,
                height: 50,
                width: 50,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of('Esther Berry'),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.caption.color,
                      ),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 24,
                      width: 74,
                      child: Center(
                        child: Text(
                          AppLocalizations.of('45 min'),
                          style: Theme.of(context).textTheme.overline.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                      height: 24,
                      width: 74,
                      child: Center(
                        child: Text(
                          AppLocalizations.of('2.4 km'),
                          style: Theme.of(context).textTheme.overline.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                )
              ],
            ),
            Expanded(
              child: SizedBox(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '25.00',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.subtitle2.color,
                      ),
                ),
                Text(
                  '12/12/2021',
                  style: Theme.of(context).textTheme.overline.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget appbar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
          ),
          Text(
            'ID da Logistica',
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.headline6.color,
                ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(),
                ),
              );
            },
            child: SizedBox(
              child: Icon(
                FontAwesomeIcons.envelope,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 4.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
