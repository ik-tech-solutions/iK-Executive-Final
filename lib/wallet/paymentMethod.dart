import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';

class PaymentMethod extends StatefulWidget {
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8, top: 10),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 24,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          FontAwesomeIcons.creditCard,
                          size: 20,
                          color: ConstanceData.secoundryFontColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      AppLocalizations.of('Informe os dados com muita atenção'),
                      style: Theme.of(context).textTheme.overline.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.subtitle2.color,
                          ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).disabledColor,
                      size: 18,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Dados'),
                    style: Theme.of(context).textTheme.overline.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: 4, right: 6),
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Theme.of(context).dividerColor,
                                radius: 24,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Icon(
                                    FontAwesomeIcons.ccVisa,
                                    color: Theme.of(context).textTheme.headline6.color,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '**** **** ****3785',
                                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).textTheme.headline6.color,
                                        ),
                                  ),
                                  Text(
                                    AppLocalizations.of('VISA'),
                                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: 0.5,
                          color: Theme.of(context).disabledColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget appBar() {
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
            AppLocalizations.of('Meio de pagamento'),
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }
}
