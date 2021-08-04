import 'package:animator/animator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/appTheme.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/database/data/methods.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/home/chatScreen.dart';
import 'package:my_cab_driver/models/logistica.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_cab_driver/home/rotasPendentesList.dart';
import 'package:my_cab_driver/pickup/dropoffScreen.dart';
import 'package:my_cab_driver/pickup/pickupScreen.dart';

class RotaAceitaScreean extends StatefulWidget {
  final String logisticaKey;

  const RotaAceitaScreean({Key key, this.logisticaKey}) : super(key: key);
  @override
  _RotaAceitaScreeanState createState() => _RotaAceitaScreeanState();
}

class _RotaAceitaScreeanState extends State<RotaAceitaScreean> {

  double verAtigosHeight = 0.0;
  String titulo = "";
  List<String> listadeArtigosLocais = [];
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  showArtigos(String tituloEncomenda){
    setState(() {
      verAtigosHeight = 300.0;
      titulo = tituloEncomenda ;

    });
  }
  closeArtigos(){
    setState(() {
      verAtigosHeight = 0.0;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar(),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'Chat',
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          mostrarArtigos(),

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
                  logistica.referencia         = values["referencia"];
                  logistica.estado         = values["status"];
                  logistica.servico_adicional         = values["servico_adicional"];
                  logistica.tipo         = values["tipo"] + "   " + values["tipo_casa"];


                });
                return Expanded(
                  child: ListView(
                    children: <Widget>[
                      userDetailbar(),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).dividerColor,
                      ),
                      referenciaDaLogistica(),
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
                      estadoDaLogistica(),
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
                      tipoDeEncomenda(),
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
                      tipoDeVeiulo(),
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
                      servicoAdicional(),
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
                      // tripFare(),
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
                      contact(),

                      logistica.estado != "concluido" ?
                      pickup() : Text(""),

                    ],
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



        ],
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
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
                    color: ConstanceData.secoundryFontColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of('Chat'),
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                fontWeight: FontWeight.bold,
                color: ConstanceData.secoundryFontColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            height: AppBar().preferredSize.height,
            width: AppBar().preferredSize.height + 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          logisticaKey : widget.logisticaKey,
                          referenciaDaLogistic : logistica.referencia,
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.question_answer,
                    color: ConstanceData.secoundryFontColor,
                  ),
                ),
              ),
            ),
          ),

        ],
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
        height: verAtigosHeight,
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
                                      AppLocalizations.of('Sem dados'),
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


  Widget pickup() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
          padding: const EdgeInsets.only(right: 14, left: 14, top: 16, bottom: 16),

          child: StreamBuilder(
              stream: FirebaseDatabase.instance.reference().child('logistica').child(widget.logisticaKey).onValue,
              builder: (context, AsyncSnapshot<Event> snapshot) {
                if (snapshot.hasData) {

                  DataSnapshot dataValues = snapshot.data.snapshot;
                  Map<dynamic, dynamic> values = dataValues.value;

                  String estadoDaLogistica;
                  String execucao;
                  String entregando;

                  if(dataValues.value != null){

                    estadoDaLogistica = dataValues.value['status'].toString();

                    if(estadoDaLogistica == "pendente"){
                      return   InkWell(
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
                                      color: Colors.orange,
                                    ),
                                    Text(
                                      AppLocalizations.of('Confirmação'),
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
                                        AppLocalizations.of('Ao clicar em ARRANCAR, confirma que está a sair da atual localização rumo ao local de recolha da encomenda.'),
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
                                              AppLocalizations.of('Cancel'),
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
                                            onTap: () {
                                              Navigator.pop(context);
                                              Metodos.goToPickUpRouteRequest(context, '${widget.logisticaKey}');


                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PickupScreen(
                                                    logisticaKey: "${widget.logisticaKey}",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              child: Text(
                                                AppLocalizations.of('Arrancar'),
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
                              AppLocalizations.of('IR ATÉ AO LOCAL DE RECOLHA'),
                              style: Theme.of(context).textTheme.button.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    if(estadoDaLogistica == "em execução"){
                      return   InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PickupScreen(
                                logisticaKey: "${widget.logisticaKey}",
                              ),
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
                              AppLocalizations.of('CONTINUAR A VIAGEM'),
                              style: Theme.of(context).textTheme.button.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    if(estadoDaLogistica == "entregando"){
                      return   InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DropOffScreen(
                                logisticaKey: "${widget.logisticaKey}",
                              ),
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
                              AppLocalizations.of('CONTINUAR O TRABALHO'),
                              style: Theme.of(context).textTheme.button.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }



                  } else {
                    return  InkWell(
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
                                    color: Colors.orange,
                                  ),
                                  Text(
                                    AppLocalizations.of('Confirmação'),
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
                                      AppLocalizations.of('Ao clicar em ARRANCAR, confirma que está a sair da atual localização rumo ao local de recolha da encomenda.'),
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
                                            AppLocalizations.of('Cancel'),
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
                                          onTap: () {
                                            Navigator.pop(context);
                                            Metodos.goToPickUpRouteRequest(context, '${widget.logisticaKey}');


                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PickupScreen(
                                                  logisticaKey: "${widget.logisticaKey}",
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            child: Text(
                                              AppLocalizations.of('Arrancar'),
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
                            AppLocalizations.of('IR ATÉ AO LOCAL DE RECOLHA'),
                            style: Theme.of(context).textTheme.button.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ConstanceData.secoundryFontColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }
                return Center( child: CircularProgressIndicator());
              })
      ),
    );
  }

  Widget contact() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: 40,
              width: 140,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey
              ),
              child:
              Center(
                child:  Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      showArtigos("Artigos da Logistica");
                    },
                    child: Center(
                      child: Text(
                        AppLocalizations.of('Ver os artigos'),
                        style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),

            ),

            logistica.estado != "concluido" ?
            Container(
              height: 40,
              width: 140,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.red[900]
              ),
              child:
              Center(
                child:  Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
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
                                  color: Colors.red,
                                ),
                                Text(
                                  AppLocalizations.of('Confirmar a acção'),
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
                                    AppLocalizations.of('Ao clicar em DESISTIR, a atual encomenda deixará de gerida por si'),
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
                                        onTap: () {
                                          // Navigator.pop(context);
                                          Metodos.rejeitarRouteRequest(context, '${widget.logisticaKey}');

                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text("A encomenda foi liberada com sucesso!"),
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
                                            AppLocalizations.of('Desistir'),
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
                    child: Center(
                      child: Text(
                        AppLocalizations.of('Desistir'),
                        style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),

            ) : Text(""),
          ],
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
              AppLocalizations.of('OBSERVAÇÕES'),
              style: Theme.of(context).textTheme.overline.copyWith(
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
    );
  }

  Widget estadoDaLogistica() {
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
                  AppLocalizations.of('ESTADO'),
                  style: Theme.of(context).textTheme.overline.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Text(
                  AppLocalizations.of(logistica.estado == "pendente" ? "PENDENTE" : logistica.estado == "em execução" ? "INDO A RECOLHA" : logistica.estado == "entregando" ? "INDO A ENTREGA" : logistica.estado == "concluido" ? "CONCLUÍDO" : logistica.estado ),
                  style: Theme.of(context).textTheme.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: logistica.estado == "pendente" ? Colors.red[500] : logistica.estado == "em execução" ? Colors.blue[500] : logistica.estado == "entregando" ? Colors.green : logistica.estado == "concluido" ? Colors.green : Theme.of(context).textTheme.headline6.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget tipoDeVeiulo() {
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
                  AppLocalizations.of('TIPO DE VEÍCULO REQUERIDO'),
                  style: Theme.of(context).textTheme.overline.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  AppLocalizations.of(logistica.carro),
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
    );
  }

  Widget referenciaDaLogistica() {
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
                  AppLocalizations.of('REFERÊNCIA DA ENCOMENDA'),
                  style: Theme.of(context).textTheme.overline.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  AppLocalizations.of(logistica.referencia),
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
    );
  }

  Widget tipoDeEncomenda() {
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
                          minWidth: 300.0,
                          maxWidth: 300.0,
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

  Widget userDetailbar() {
    return Container(
      color: Theme.of(context).dividerColor,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: <Widget>[
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10),
            //   child: Image.asset(
            //     ConstanceData.userImage,
            //     height: 50,
            //     width: 50,
            //   ),
            // ),
            // SizedBox(
            //   width: 8,
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(logistica.remetente),
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
                      width: 110,
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
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 24,
                      width: 180,
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
                  logistica.preco + " €/hora",
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.subtitle2.color,
                  ),
                ),
                Text(
                  logistica.data,
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
            '',
            style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headline6.color,
            ),
          ),
          SizedBox(
            width: 170,
          ),
          Text(
            'Chat',
            style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headline6.color,
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    logisticaKey : widget.logisticaKey,
                    referenciaDaLogistic : logistica.referencia,
                  ),
                ),
              );
            },
            child: SizedBox(
              child: Icon(
                Icons.question_answer,
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
