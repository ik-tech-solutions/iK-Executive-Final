import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'home/userDetail.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/database/data/methods.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/models/logistica.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_cab_driver/home/rotasPendentesList.dart';


class TicketDesign extends StatefulWidget {

  final String logisticaKey;

  const TicketDesign({Key key, this.logisticaKey}) : super(key: key);
  @override
  _TicketDesignState createState() => _TicketDesignState();
}

class _TicketDesignState extends State<TicketDesign> {
  double verArtigosHeight = 0.0;
  String titulo = "";
  List<String> listadeArtigosLocais = [];

  showArtigos(String tituloEncomenda){
    setState(() {
      verArtigosHeight = 300.0;
      titulo = tituloEncomenda ;

    });
  }
  closeArtigos(){
    setState(() {
      verArtigosHeight = 0.0;
    });
  }


  @override
  Widget build(BuildContext context) {





    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
      ),
      body:  Container(
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
          top: 10,
          child: Image(
            image: AssetImage(ConstanceData.login_app),
            // fit : BoxFit.fill,

            height: MediaQuery
                .of(context)
                .size
                .height,
          ),
        ),

        StreamBuilder(
          stream: FirebaseDatabase.instance.reference().child('logistica').orderByChild('key').equalTo("${widget.logisticaKey}").limitToFirst(1).onValue,              builder: (context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.hasData) {

          DataSnapshot dataValues = snapshot.data.snapshot;
          Map<dynamic, dynamic> values = dataValues.value;
          if(dataValues.value != null){
            values.forEach((key, values) {

              logistica = new Logistica();

              logistica.endereco_origem   = values["endereco_origem"];
              logistica.endereco_destino  = values["endereco_destino"];
              logistica.valor_inicial        = values["valor_inicial"];
              logistica.destinatario      = values["destinatario"];
              logistica.duracao           = values["duracao"];
              logistica.distancia         = values["distancia"];
              logistica.preco             = values["custo"];
              logistica.data              = values["data_envio"];
              logistica.remetente         = values["nome_usuario"];
              logistica.observacao         = values["observacao"];
              logistica.carro         = values["tipo_veiculo"];
              logistica.servico_adicional         = values["servico_adicional"];
              logistica.tipo         = values["tipo"] + "   " + values["tipo_casa"];


            });
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 14, left: 14),
                      child: FlutterTicketWidget(
                        isCornerRounded: true,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            mostrarArtigos(),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  SizedBox(
                                    width: 2,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height: 24,
                                            width: 150,
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of(logistica.remetente),
                                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                fontSize: 10),

                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 1,
                                          ),
                                          Container(
                                            height: 24,
                                            width: 150,
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of(logistica.data),
                                                style: Theme.of(context).textTheme.overline.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[

                                          Container(
                                            height: 24,
                                            width: MediaQuery.of(context).size.width * 0.5,
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of("Valor inicial " + logistica.valor_inicial),
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


                                        ],
                                      ),

                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[

                                          Container(
                                            height: 24,
                                            width: 130,
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of(logistica.duracao),
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
                                                AppLocalizations.of(logistica.distancia),
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
                                            width: 85,
                                            child: Center(
                                              child: Text(
                                                logistica.preco + " €/h",
                                                style: Theme.of(context).textTheme.overline.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: ConstanceData.secoundryFontColor,),
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
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                            Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[

                                        Text(
                                          AppLocalizations.of('LOCAL DE RECOLHA'),
                                          style: Theme.of(context).textTheme.overline.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          AppLocalizations.of(logistica.endereco_origem),
                                          style: Theme.of(context).textTheme.caption.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                            Container(
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
                                          style: Theme.of(context).textTheme.overline.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          AppLocalizations.of(logistica.endereco_destino),
                                          style: Theme.of(context).textTheme.caption.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of('TIPO DE ENCOMENDA'),
                                          style: Theme.of(context).textTheme.overline.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          AppLocalizations.of(logistica.tipo),
                                          style: Theme.of(context).textTheme.caption.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: Theme.of(context).dividerColor,
                            ),
                            Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 24, left: 30, bottom: 8, top: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of('Observações'),
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
                                          AppLocalizations.of(logistica.observacao),
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
                            ),
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
                            Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    servicoAdicional(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 14, left: 14, top: 8),
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  showArtigos("Artigos da Logistica");
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).textTheme.headline6.color,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('Ver os artigos'),
                                      style: Theme.of(context).textTheme.button.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 14, left: 14, top: 8, bottom: 14),
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              Icons.warning_amber_rounded,
                                              size: 80,
                                              color: Colors.green,
                                            ),
                                            Text(
                                              AppLocalizations.of('Confirmar o serviço'),
                                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                color: Theme.of(context).textTheme.subtitle1.color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
                                              child: Text(
                                                AppLocalizations.of('Ao clicar em ACEITAR, concorda com os nosso termos de uso e políticas de privacidade, responsabilizando-se por gerir a encomenda com segurança e garantia de entrega de qualidade.'),
                                                style: Theme.of(context).textTheme.caption.copyWith(
                                                  color: Theme.of(context).disabledColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Divider(
                                              height: 0,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 16, left: 16),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of('Cancelar'),
                                                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                        color: Theme.of(context).disabledColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Theme.of(context).dividerColor,
                                                    width: 0.5,
                                                    height: 48,
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      // Navigator.pop(context);
                                                      Metodos.acceptRouteRequest(context, '${widget.logisticaKey}');

                                                      final dbRef =
                                                          await FirebaseDatabase.instance.reference().child('motorista/${authFB.currentUser.uid}/calendario');
                                                      dbRef.push().set({
                                                        "StartTime": logistica.data,
                                                        "EndTime": logistica.data,
                                                        "Subject": "Entrega da encomenda de ${logistica.remetente}",
                                                        "ResourceId": '0001'
                                                      });

                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text("Parabéns, acaba de adicionar uma encomenda na tua agenda!"),
                                                      ));

                                                      Navigator.pop(context);
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => RotasPendentesList(),
                                                        ),
                                                      );

                                                      // Navigator.pushReplacementNamed

                                                    },
                                                    child: Container(
                                                      child: Text(
                                                        AppLocalizations.of('Aceitar'),
                                                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                          color: Theme.of(context).primaryColor,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        contentPadding: EdgeInsets.only(top: 16),
                                      );
                                    },
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
                                      AppLocalizations.of('ACEITAR A ENCOMENDA'),
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
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 16,
                    )
                  ],
                ),
              ),
            );

          } else {
            return Center( child:Text(
              AppLocalizations.of('Sem detalhes'),
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

          ]
        ),

      ),







    );
  }

  Widget mostrarArtigos(){
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft:Radius.circular(15), topRight:Radius.circular(15)),
            boxShadow: [BoxShadow(
                color: Colors.black26,
                blurRadius: 15.0,
                spreadRadius: 0.5,
                offset: Offset(
                    0.7,
                    0.7
                )
            )]
        ),
        height: verArtigosHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: GestureDetector(
                          onTap: (){
                            closeArtigos();
                          },
                          child: Icon(Icons.close)),
                    )

                  ],
                ),
                Container(
                  width: double.infinity,
                  //color:,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Text(titulo,style: Theme.of(context).textTheme.subtitle2),
                        Text(AppLocalizations.of('Artigos da encomendas'),
                            style: Theme.of(context).textTheme.subtitle2),
                        SizedBox(height: 10),
                        // tableData(),
                        Container(
                          height: 500,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:Colors.black26,
                          ),
                          child: StreamBuilder(
                              stream: FirebaseDatabase.instance.reference().child('logistica').child('${widget.logisticaKey}').child("artigos").onValue,
                              builder: (context, AsyncSnapshot<Event> snapshot) {

                                if (snapshot.hasData) {
                                  listadeArtigosLocais.clear();
                                  DataSnapshot dataValues = snapshot.data.snapshot;
                                  List<dynamic> values = dataValues.value;
                                  if(dataValues.value != null){
                                    values.forEach((values) {
                                      listadeArtigosLocais.add(values);
                                    });
                                    return new ListView.builder(
                                        padding: const EdgeInsets.all(15),
                                        shrinkWrap: true,
                                        itemCount: listadeArtigosLocais.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[

                                              Padding(
                                                padding: EdgeInsets.only(right: 1, left: 1),
                                                child: InkWell(
                                                  highlightColor: Colors.transparent,
                                                  splashColor: Colors.transparent,
                                                  onTap: () {

                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadiusDirectional.circular(16),
                                                      color: Theme.of(context).scaffoldBackgroundColor,
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(16), topStart: Radius.circular(16)),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(1),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: <Widget>[
                                                                Text(
                                                                  AppLocalizations.of("   "+listadeArtigosLocais[index]),
                                                                  style: Theme.of(context).textTheme.caption.copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Theme.of(context).textTheme.headline6.color,
                                                                      fontSize: 12
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

                                            ],
                                          );

                                        }
                                    );
                                  } else {
                                    return Center( child:Text(
                                      AppLocalizations.of('Sem artigos'),
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
                          //    OKAY OKAY OKAY
                        ),

                        SizedBox(height: 20,),
                        Divider(height: 3,)

                      ],
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
  Widget servicoAdicional() {
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
                  AppLocalizations.of('SERVIÇO ADICIONAL'),
                  style: Theme.of(context).textTheme.overline.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.all(10),
                    child: Container(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 250.0,
                          maxWidth: 250.0,
                          minHeight: 30.0,
                          maxHeight: 100.0,
                        ),
                        child: AutoSizeText(
                          logistica.servico_adicional == null ? "Nenhum serviço adicional" : logistica.servico_adicional.toString(),
                          style: TextStyle(fontSize: 6.0, color: Colors.black),
                        ),
                      ),
                    ),

                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ticketDetailsWidget(String firstTitle, String firstDesc, String secondTitle, String secondDesc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  firstDesc,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                secondTitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  secondDesc,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class FlutterTicketWidget extends StatefulWidget {
  final Widget child;
  final Color color;
  final bool isCornerRounded;

  FlutterTicketWidget({@required this.child, this.color = Colors.white, this.isCornerRounded = false});

  @override
  _FlutterTicketWidgetState createState() => _FlutterTicketWidgetState();
}

class _FlutterTicketWidgetState extends State<FlutterTicketWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(),
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        child: widget.child,
        decoration: BoxDecoration(color: widget.color, borderRadius: widget.isCornerRounded ? BorderRadius.circular(10) : BorderRadius.circular(0.0)),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(Rect.fromCircle(center: Offset(0.0, size.height / 2), radius: 20.0));
    path.addOval(Rect.fromCircle(center: Offset(size.width, size.height / 2), radius: 20.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
