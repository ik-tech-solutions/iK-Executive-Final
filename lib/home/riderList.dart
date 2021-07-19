import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/home/userDetail.dart';
import 'package:my_cab_driver/home/chatScreen.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_cab_driver/models/logistica.dart';

import '../ticketView.dart';

class RiderList extends StatefulWidget {
  @override
  _RiderListState createState() => _RiderListState();
}

class _RiderListState extends State<RiderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
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
                  Icons.close,
                  color: Theme.of(context).textTheme.headline6.color,
                ),
              ),
            ),
            Text(
              'Serviços disponíveis',
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.subtitle2.color,
                  ),
            ),
          ],
        ),
      ),
      body:
            StreamBuilder(
                stream: logisticasDisponiveisReFuture,
                builder: (context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasData) {
                    listaLogistica.clear();
                    DataSnapshot dataValues = snapshot.data.snapshot;
                    Map<dynamic, dynamic> values = dataValues.value;
                    if(dataValues.value != null){
                      values.forEach((key, values) {

                        listaLogistica.add(values);

                        logistica = new Logistica();

                        logistica.key              = values["key"];
                        logistica.endereco_origem   = values["endereco_origem"];
                        logistica.endereco_destino  = values["endereco_destino"];

                        logistica.destinatario      = values["destinatario"];
                        logistica.duracao           = values["duracao"];
                        logistica.distancia         = values["distancia"];
                        logistica.preco             = values["custo"];
                        logistica.data              = values["data_envio"];
                        logistica.remetente         = values["nome_usuario"];


                      });
                      return new ListView.builder(
                                  padding: const EdgeInsets.all(15),
                                  shrinkWrap: true,
                                  itemCount: listaLogistica.length,
                                  itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[

                                             Animator(
                        tween: Tween<Offset>(
                          begin: Offset(0, 0.4),
                          end: Offset(0, 0),
                        ),
                        duration: Duration(milliseconds: 700),
                        cycles: 1,
                             builder: (anim) => SlideTransition(
                          position: anim,
                          child:


                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                    logistica = new Logistica();

                                    logistica.key  = listaLogistica[index]["key"];
                                    logistica.latitudeColeta  = listaLogistica[index]["latitude_origem"];
                                    logistica.longitudeColeta = listaLogistica[index]["longitude_origem"];
                                    logistica.latitudeEntrega  = listaLogistica[index]["latitude_destino"];
                                    logistica.longitudeEntrega = listaLogistica[index]["longitude_destino"];
                                    logistica.referencia = listaLogistica[index]["referencia"];


                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) => TicketDesign(
                                        logisticaKey: listaLogistica[index]["key"],
                                    // custo     : listaLogistica[index]["custo"],
                                    // taxaDeCobranca  : listaLogistica[index]["taxa_cobranca"],
                                    // taxaDeEnvio : listaLogistica[index]["taxa_envio"],
                                    // motorista  : listaLogistica[index]["nome_motorista"],
                                    // tokenMotorista : listaLogistica[index]["token_motorista"],
                                    // servicoAdicional  : listaLogistica[index]["servico_adicional"],
                                    // tipo : listaLogistica[index]["tipo"],
                                    // tipoDeCasa  : listaLogistica[index]["tipo_casa"],
                                    // destinatario  : listaLogistica[index]["destinatario"],
                                    ),
                                    ),
                                    );
                                    },
                                    child:  Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  new BoxShadow(
                                    color: Theme.of(context).dividerColor,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.asset(
                                              ConstanceData.userImage,
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                AppLocalizations.of(listaLogistica[index]['nome_usuario']),
                                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).textTheme.subtitle2.color,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                AppLocalizations.of("Valor inicial " + listaLogistica[index]['valor_inicial']),
                                                style: Theme.of(context).textTheme.overline.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).primaryColor
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    height: 24,
                                                    width: 100,
                                                    child: Center(
                                                      child: Text(
                                                        AppLocalizations.of(listaLogistica[index]['duracao']),
                                                        style: Theme.of(context).textTheme.overline.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color: ConstanceData.secoundryFontColor,
                                                          fontSize: 8
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
                                                        AppLocalizations.of(listaLogistica[index]['distancia']),
                                                        style: Theme.of(context).textTheme.overline.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color: ConstanceData.secoundryFontColor,
                                                            fontSize: 8
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
                                                listaLogistica[index]['custo'] + " €/h",
                                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).textTheme.headline6.color,
                                                ),
                                              ),

                                              Text(
                                                listaLogistica[index]['data_envio'],
                                                style: Theme.of(context).textTheme.overline.copyWith(
                                                    color: Theme.of(context).disabledColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 0
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 0.5,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                AppLocalizations.of('LOCAL DE RECOLHA'),
                                                style: Theme.of(context).textTheme.caption.copyWith(
                                                  color: Theme.of(context).disabledColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(listaLogistica[index]['endereco_origem']),
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
                                    Divider(
                                      height: 0.5,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
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
                                              Text(
                                                AppLocalizations.of(listaLogistica[index]['endereco_destino']),
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
                                    Divider(
                                      height: 0.5,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                                      child: Container(
                                            height: 32,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.grey,
                                            ),
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of('ENTRAR'),
                                                style: Theme.of(context).textTheme.button.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: ConstanceData.secoundryFontColor,
                                                ),
                                              ),
                                            ),
                                          ),

                                    )
                                  ],
                                ),
                              ),
                            ),
                            ),
                          ),
                        ),
                      ),

                                                    ],
                                                    );

                                                  }
                                                         );

                    } else {
                      return Center( child:Container(
                        height: AppBar().preferredSize.height,
                        color: Theme.of(context).disabledColor,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14, left: 14),
                          child: Row(
                            children: <Widget>[


                              StreamBuilder(
                                  stream: logisticasDisponiveisReFuture,
                                  builder: (context, AsyncSnapshot<Event> snapshot) {
                                    if (snapshot.hasData) {
                                      logisticasDisponiveisInt = 0;
                                      DataSnapshot dataValues = snapshot.data.snapshot;
                                      Map<dynamic, dynamic> values = dataValues.value;
                                      if(dataValues.value != null){
                                        values.forEach((key, values) {
                                          logisticasDisponiveisInt++;
                                        });
                                        return Text(
                                          "Existe "+logisticasDisponiveisInt.toString() + " encomendas disponíveis á tua espera.",
                                          style: Theme.of(context).textTheme.overline.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: ConstanceData.secoundryFontColor,
                                          ),
                                        );

                                      } else {
                                        return Center( child:Text(
                                          AppLocalizations.of("Não há encomendas disponívies no momento."),
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        )
                                        );
                                      }
                                    }
                                    return Center( child: CircularProgressIndicator());
                                  }),





                            ],
                          ),
                        ),
                      ),
                      );
                    }
                  }
                  return Center( child: CircularProgressIndicator());
                })
            // Column(
            //   children: <Widget>[
            //     Padding(
            //       padding: EdgeInsets.only(right: 6, left: 6),
            //       child: InkWell(
            //         highlightColor: Colors.transparent,
            //         splashColor: Colors.transparent,
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => UserDetailScreen(
            //                 userId: 1,
            //               ),
            //             ),
            //           );
            //         },
            //         child: Container(
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadiusDirectional.circular(16),
            //             color: Theme.of(context).scaffoldBackgroundColor,
            //           ),
            //           child: Column(
            //             children: <Widget>[
            //               Container(
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(16), topStart: Radius.circular(16)),
            //                 ),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(14),
            //                   child: Row(
            //                     children: <Widget>[
            //                       ClipRRect(
            //                         borderRadius: BorderRadius.circular(10),
            //                         child: Image.asset(
            //                           ConstanceData.user8,
            //                           height: 50,
            //                           width: 50,
            //                         ),
            //                       ),
            //                       SizedBox(
            //                         width: 8,
            //                       ),
            //                       Column(
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: <Widget>[
            //                           Text(
            //                             AppLocalizations.of('Esther Berry'),
            //                             style: Theme.of(context).textTheme.subtitle2.copyWith(
            //                                   fontWeight: FontWeight.bold,
            //                                   color: Theme.of(context).textTheme.headline6.color,
            //                                 ),
            //                           ),
            //                           SizedBox(
            //                             height: 4,
            //                           ),
            //                           Row(
            //                             children: <Widget>[
            //                               Container(
            //                                 height: 24,
            //                                 width: 74,
            //                                 child: Center(
            //                                   child: Text(
            //                                     AppLocalizations.of('30 min'),
            //                                     style: Theme.of(context).textTheme.caption.copyWith(
            //                                           fontWeight: FontWeight.bold,
            //                                           color: ConstanceData.secoundryFontColor,
            //                                         ),
            //                                   ),
            //                                 ),
            //                                 decoration: BoxDecoration(
            //                                   borderRadius: BorderRadius.all(
            //                                     Radius.circular(15),
            //                                   ),
            //                                   color: Theme.of(context).primaryColor,
            //                                 ),
            //                               ),
            //                               SizedBox(
            //                                 width: 4,
            //                               ),
            //                               Container(
            //                                 height: 24,
            //                                 width: 74,
            //                                 child: Center(
            //                                   child: Text(
            //                                     AppLocalizations.of('2.5 km'),
            //                                     style: Theme.of(context).textTheme.caption.copyWith(
            //                                           fontWeight: FontWeight.bold,
            //                                           color: ConstanceData.secoundryFontColor,
            //                                         ),
            //                                   ),
            //                                 ),
            //                                 decoration: BoxDecoration(
            //                                   borderRadius: BorderRadius.all(
            //                                     Radius.circular(15),
            //                                   ),
            //                                   color: Theme.of(context).primaryColor,
            //                                 ),
            //                               )
            //                             ],
            //                           )
            //                         ],
            //                       ),
            //                       Expanded(
            //                         child: SizedBox(),
            //                       ),
            //                       Column(
            //                         crossAxisAlignment: CrossAxisAlignment.end,
            //                         children: <Widget>[
            //                           Text(
            //                             '25.00',
            //                             style: Theme.of(context).textTheme.headline6.copyWith(
            //                                   fontWeight: FontWeight.bold,
            //                                   color: Theme.of(context).textTheme.headline6.color,
            //                                 ),
            //                           ),
            //                           Text(
            //                             '12/12/2021',
            //                             style: Theme.of(context).textTheme.overline.copyWith(
            //                                   color: Theme.of(context).disabledColor,
            //                                   fontWeight: FontWeight.bold,
            //                                 ),
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               Container(
            //                 height: 1,
            //                 width: MediaQuery.of(context).size.width,
            //                 color: Theme.of(context).dividerColor,
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
            //                 child: Row(
            //                   children: <Widget>[
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: <Widget>[
            //                         Text(
            //                           AppLocalizations.of('COLECTA'),
            //                           style: Theme.of(context).textTheme.caption.copyWith(
            //                                 color: Theme.of(context).disabledColor,
            //                                 fontWeight: FontWeight.bold,
            //                               ),
            //                         ),
            //                         SizedBox(
            //                           height: 4,
            //                         ),
            //                         Text(
            //                           AppLocalizations.of('79 Swift Village'),
            //                           style: Theme.of(context).textTheme.overline.copyWith(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Theme.of(context).textTheme.headline6.color,
            //                               ),
            //                         ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(right: 14, left: 14),
            //                 child: Container(
            //                   height: 1,
            //                   width: MediaQuery.of(context).size.width,
            //                   color: Theme.of(context).dividerColor,
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
            //                 child: Row(
            //                   children: <Widget>[
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: <Widget>[
            //                         Text(
            //                           AppLocalizations.of('ENTREGA'),
            //                           style: Theme.of(context).textTheme.caption.copyWith(
            //                                 color: Theme.of(context).disabledColor,
            //                                 fontWeight: FontWeight.bold,
            //                               ),
            //                         ),
            //                         SizedBox(
            //                           height: 4,
            //                         ),
            //                         Text(
            //                           AppLocalizations.of('115 William St, Chicago, US'),
            //                           style: Theme.of(context).textTheme.overline.copyWith(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Theme.of(context).textTheme.headline6.color,
            //                               ),
            //                         ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Container(
            //                 height: 1,
            //                 width: MediaQuery.of(context).size.width,
            //                 color: Theme.of(context).dividerColor,
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(right: 14, left: 14, top: 16),
            //                 child: Container(
            //                   height: 40,
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(10),
            //                     color: Theme.of(context).primaryColor,
            //                   ),
            //                   child: Center(
            //                     child: Text(
            //                       AppLocalizations.of('ACEITAR'),
            //                       style: Theme.of(context).textTheme.button.copyWith(
            //                             fontWeight: FontWeight.bold,
            //                             color: ConstanceData.secoundryFontColor,
            //                           ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               SizedBox(
            //                 height: 16,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       height: 16,
            //     ),
            //     Padding(
            //       padding: EdgeInsets.only(right: 6, left: 6),
            //       child: InkWell(
            //         highlightColor: Colors.transparent,
            //         splashColor: Colors.transparent,
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => UserDetailScreen(
            //                 userId: 2,
            //               ),
            //             ),
            //           );
            //         },
            //         child: Container(
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadiusDirectional.circular(16),
            //             color: Theme.of(context).scaffoldBackgroundColor,
            //           ),
            //           child: Column(
            //             children: <Widget>[
            //               Container(
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(16), topStart: Radius.circular(16)),
            //                 ),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(14),
            //                   child: Row(
            //                     children: <Widget>[
            //                       ClipRRect(
            //                         borderRadius: BorderRadius.circular(10),
            //                         child: Image.asset(
            //                           ConstanceData.user1,
            //                           height: 50,
            //                           width: 50,
            //                         ),
            //                       ),
            //                       SizedBox(
            //                         width: 8,
            //                       ),
            //                       Column(
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: <Widget>[
            //                           Text(
            //                             AppLocalizations.of('Callie Greer'),
            //                             style: Theme.of(context).textTheme.headline6.copyWith(
            //                                   fontWeight: FontWeight.bold,
            //                                   color: Theme.of(context).textTheme.headline6.color,
            //                                 ),
            //                           ),
            //                           SizedBox(
            //                             height: 4,
            //                           ),
            //                           Row(
            //                             children: <Widget>[
            //                               Container(
            //                                 height: 24,
            //                                 width: 74,
            //                                 child: Center(
            //                                   child: Text(
            //                                     AppLocalizations.of('ApplePay'),
            //                                     style: Theme.of(context).textTheme.button.copyWith(
            //                                           fontWeight: FontWeight.bold,
            //                                           color: ConstanceData.secoundryFontColor,
            //                                         ),
            //                                   ),
            //                                 ),
            //                                 decoration: BoxDecoration(
            //                                   borderRadius: BorderRadius.all(
            //                                     Radius.circular(15),
            //                                   ),
            //                                   color: Theme.of(context).primaryColor,
            //                                 ),
            //                               ),
            //                               SizedBox(
            //                                 width: 4,
            //                               ),
            //                               Container(
            //                                 height: 24,
            //                                 width: 74,
            //                                 child: Center(
            //                                   child: Text(
            //                                     AppLocalizations.of('Discount'),
            //                                     style: Theme.of(context).textTheme.button.copyWith(
            //                                           fontWeight: FontWeight.bold,
            //                                           color: ConstanceData.secoundryFontColor,
            //                                         ),
            //                                   ),
            //                                 ),
            //                                 decoration: BoxDecoration(
            //                                   borderRadius: BorderRadius.all(
            //                                     Radius.circular(15),
            //                                   ),
            //                                   color: Theme.of(context).primaryColor,
            //                                 ),
            //                               )
            //                             ],
            //                           )
            //                         ],
            //                       ),
            //                       Expanded(
            //                         child: SizedBox(),
            //                       ),
            //                       Column(
            //                         crossAxisAlignment: CrossAxisAlignment.end,
            //                         children: <Widget>[
            //                           Text(
            //                             '\$20.00',
            //                             style: Theme.of(context).textTheme.headline6.copyWith(
            //                                   fontWeight: FontWeight.bold,
            //                                   color: Theme.of(context).textTheme.headline6.color,
            //                                 ),
            //                           ),
            //                           Text(
            //                             '1.5 km',
            //                             style: Theme.of(context).textTheme.caption.copyWith(
            //                                   color: Theme.of(context).disabledColor,
            //                                   fontWeight: FontWeight.bold,
            //                                 ),
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               Container(
            //                 height: 1,
            //                 width: MediaQuery.of(context).size.width,
            //                 color: Theme.of(context).dividerColor,
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
            //                 child: Row(
            //                   children: <Widget>[
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: <Widget>[
            //                         Text(
            //                           AppLocalizations.of('PICKUP'),
            //                           style: Theme.of(context).textTheme.caption.copyWith(
            //                                 color: Theme.of(context).disabledColor,
            //                                 fontWeight: FontWeight.bold,
            //                               ),
            //                         ),
            //                         SizedBox(
            //                           height: 4,
            //                         ),
            //                         Text(
            //                           AppLocalizations.of('62 Kobe Trafficway'),
            //                           style: Theme.of(context).textTheme.subtitle2.copyWith(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Theme.of(context).textTheme.headline6.color,
            //                               ),
            //                         ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(right: 14, left: 14),
            //                 child: Container(
            //                   height: 1,
            //                   width: MediaQuery.of(context).size.width,
            //                   color: Theme.of(context).dividerColor,
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
            //                 child: Row(
            //                   children: <Widget>[
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: <Widget>[
            //                         Text(
            //                           AppLocalizations.of('DROP OFF'),
            //                           style: Theme.of(context).textTheme.caption.copyWith(
            //                                 color: Theme.of(context).disabledColor,
            //                                 fontWeight: FontWeight.bold,
            //                               ),
            //                         ),
            //                         SizedBox(
            //                           height: 4,
            //                         ),
            //                         Text(
            //                           AppLocalizations.of('280, AB Sunny willa'),
            //                           style: Theme.of(context).textTheme.subtitle2.copyWith(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Theme.of(context).textTheme.headline6.color,
            //                               ),
            //                         ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Container(
            //                 height: 1,
            //                 width: MediaQuery.of(context).size.width,
            //                 color: Theme.of(context).dividerColor,
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(right: 14, left: 14, top: 16),
            //                 child: Container(
            //                   height: 40,
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(10),
            //                     color: Theme.of(context).primaryColor,
            //                   ),
            //                   child: Center(
            //                     child: Text(
            //                       AppLocalizations.of('ACCEPT'),
            //                       style: Theme.of(context).textTheme.button.copyWith(
            //                             fontWeight: FontWeight.bold,
            //                             color: ConstanceData.secoundryFontColor,
            //                           ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               SizedBox(
            //                 height: 16,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       height: 16,
            //     ),
            //     Padding(
            //       padding: EdgeInsets.only(right: 6, left: 6),
            //       child: InkWell(
            //         highlightColor: Colors.transparent,
            //         splashColor: Colors.transparent,
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => UserDetailScreen(
            //                 userId: 3,
            //               ),
            //             ),
            //           );
            //         },
            //         child: Container(
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadiusDirectional.circular(16),
            //             color: Theme.of(context).scaffoldBackgroundColor,
            //           ),
            //           child: Column(
            //             children: <Widget>[
            //               Container(
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(16), topStart: Radius.circular(16)),
            //                 ),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(14),
            //                   child: Row(
            //                     children: <Widget>[
            //                       ClipRRect(
            //                         borderRadius: BorderRadius.circular(10),
            //                         child: Image.asset(
            //                           ConstanceData.user2,
            //                           height: 50,
            //                           width: 50,
            //                         ),
            //                       ),
            //                       SizedBox(
            //                         width: 8,
            //                       ),
            //                       Column(
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: <Widget>[
            //                           Text(
            //                             AppLocalizations.of('Esther Berry'),
            //                             style: Theme.of(context).textTheme.headline6.copyWith(
            //                                   fontWeight: FontWeight.bold,
            //                                   color: Theme.of(context).textTheme.headline6.color,
            //                                 ),
            //                           ),
            //                           SizedBox(
            //                             height: 4,
            //                           ),
            //                           Row(
            //                             children: <Widget>[
            //                               Container(
            //                                 height: 24,
            //                                 width: 74,
            //                                 child: Center(
            //                                   child: Text(
            //                                     AppLocalizations.of('ApplePay'),
            //                                     style: Theme.of(context).textTheme.button.copyWith(
            //                                           fontWeight: FontWeight.bold,
            //                                           color: ConstanceData.secoundryFontColor,
            //                                         ),
            //                                   ),
            //                                 ),
            //                                 decoration: BoxDecoration(
            //                                   borderRadius: BorderRadius.all(
            //                                     Radius.circular(15),
            //                                   ),
            //                                   color: Theme.of(context).primaryColor,
            //                                 ),
            //                               ),
            //                               SizedBox(
            //                                 width: 4,
            //                               ),
            //                               Container(
            //                                 height: 24,
            //                                 width: 74,
            //                                 child: Center(
            //                                   child: Text(
            //                                     AppLocalizations.of('Discount'),
            //                                     style: Theme.of(context).textTheme.button.copyWith(
            //                                           fontWeight: FontWeight.bold,
            //                                           color: ConstanceData.secoundryFontColor,
            //                                         ),
            //                                   ),
            //                                 ),
            //                                 decoration: BoxDecoration(
            //                                   borderRadius: BorderRadius.all(
            //                                     Radius.circular(15),
            //                                   ),
            //                                   color: Theme.of(context).primaryColor,
            //                                 ),
            //                               )
            //                             ],
            //                           )
            //                         ],
            //                       ),
            //                       Expanded(
            //                         child: SizedBox(),
            //                       ),
            //                       Column(
            //                         crossAxisAlignment: CrossAxisAlignment.end,
            //                         children: <Widget>[
            //                           Text(
            //                             '\$10.00',
            //                             style: Theme.of(context).textTheme.headline6.copyWith(
            //                                   fontWeight: FontWeight.bold,
            //                                   color: Theme.of(context).textTheme.headline6.color,
            //                                 ),
            //                           ),
            //                           Text(
            //                             '0.5 km',
            //                             style: Theme.of(context).textTheme.caption.copyWith(
            //                                   color: Theme.of(context).disabledColor,
            //                                   fontWeight: FontWeight.bold,
            //                                 ),
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               Container(
            //                 height: 1,
            //                 width: MediaQuery.of(context).size.width,
            //                 color: Theme.of(context).dividerColor,
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
            //                 child: Row(
            //                   children: <Widget>[
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: <Widget>[
            //                         Text(
            //                           AppLocalizations.of('PICKUP'),
            //                           style: Theme.of(context).textTheme.caption.copyWith(
            //                                 color: Theme.of(context).disabledColor,
            //                                 fontWeight: FontWeight.bold,
            //                               ),
            //                         ),
            //                         SizedBox(
            //                           height: 4,
            //                         ),
            //                         Text(
            //                           AppLocalizations.of('25 Lcie Park Suite'),
            //                           style: Theme.of(context).textTheme.subtitle2.copyWith(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Theme.of(context).textTheme.headline6.color,
            //                               ),
            //                         ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(right: 14, left: 14),
            //                 child: Container(
            //                   height: 1,
            //                   width: MediaQuery.of(context).size.width,
            //                   color: Theme.of(context).dividerColor,
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
            //                 child: Row(
            //                   children: <Widget>[
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: <Widget>[
            //                         Text(
            //                           AppLocalizations.of('DROP OFF'),
            //                           style: Theme.of(context).textTheme.caption.copyWith(
            //                                 color: Theme.of(context).disabledColor,
            //                                 fontWeight: FontWeight.bold,
            //                               ),
            //                         ),
            //                         SizedBox(
            //                           height: 4,
            //                         ),
            //                         Text(
            //                           AppLocalizations.of('187/ William St, London, UK'),
            //                           style: Theme.of(context).textTheme.subtitle2.copyWith(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Theme.of(context).textTheme.headline6.color,
            //                               ),
            //                         ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Container(
            //                 height: 1,
            //                 width: MediaQuery.of(context).size.width,
            //                 color: Theme.of(context).dividerColor,
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(right: 14, left: 14, top: 16),
            //                 child: Container(
            //                   height: 40,
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(10),
            //                     color: Theme.of(context).primaryColor,
            //                   ),
            //                   child: Center(
            //                     child: Text(
            //                       'Accept',
            //                       style: Theme.of(context).textTheme.button.copyWith(
            //                             fontWeight: FontWeight.bold,
            //                             color: ConstanceData.secoundryFontColor,
            //                           ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               SizedBox(
            //                 height: 16,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),


    );
  }
}
