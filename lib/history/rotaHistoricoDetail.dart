import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab_driver/constance/global.dart' as globals;
import 'package:my_cab_driver/constance/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:my_cab_driver/database/HelperMethods.dart';
import 'package:my_cab_driver/home/chatScreen.dart';
import 'package:my_cab_driver/models/logisticaExtra.dart';





class RotaHistoricaDetailScreen extends StatefulWidget {

  final String custo, taxaDeCobranca, taxaDeEnvio, remetente, tokenMotorista, tipo, tipoDeCasa, destinatario, referencia, logisticaKey, pagamento;
  final   List<dynamic>  servicoAdicional;
  const RotaHistoricaDetailScreen({Key key, this.custo, this.taxaDeCobranca, this.taxaDeEnvio, this.remetente, this.tokenMotorista, this.servicoAdicional, this.tipo, this.tipoDeCasa, this.destinatario, this.referencia, this.logisticaKey, this.pagamento}) : super(key: key);

  @override
  _RotaHistoricaDetailScreenState createState() => _RotaHistoricaDetailScreenState();

}



class _RotaHistoricaDetailScreenState extends State<RotaHistoricaDetailScreen> {



  final double CAMERA_ZOOM = 15;
  final double CAMERA_TILT = 0;
  final double CAMERA_BEARING = 30;
  final LatLng SOURCE_LOCATION = LatLng(double.parse(logistica.latitudeColeta), double.parse(logistica.longitudeColeta));
  final LatLng DEST_LOCATION   = LatLng(double.parse(logistica.latitudeEntrega), double.parse(logistica.longitudeEntrega));
  //
  Completer<GoogleMapController> _controller = Completer();

  // this set will hold my markers
  Set<Marker> _markers = {};

  // this will hold the generated polylines
  Set<Polyline> _polylines = {};

  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];

  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish

  String googleAPIKey = mapKeyANDROID;

  // for my custom icons
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  //

  var pickLatLng = LatLng(double.parse(logistica.latitudeColeta), double.parse(logistica.longitudeColeta));
  var destinationLatLng = LatLng(double.parse(logistica.latitudeEntrega), double.parse(logistica.longitudeEntrega));
  PolylinePoints polylinePoints = PolylinePoints();



  @override
  void initState() {
    super.initState();
    HelperMethods.getLogisticaEspecifica(widget.logisticaKey);
    setSourceAndDestinationIcons();
    generateExampleDocument();

    // print("Logistica No Historya:  =============================================: " +     logisticaEspecifica.endereco_destino.toString());
  }



  @override
  void dispose(){
    super.dispose();

    logistica.key              = "";
    logistica.latitudeColeta   = "";
    logistica.longitudeColeta  = "";
    logistica.latitudeEntrega  = "";
    logistica.longitudeEntrega = "";
    logistica.referencia       = "";
  }


  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), ConstanceData.startPin,
   );
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        ConstanceData.endPin);
  }


  double verArtigosHeight = 0.0;
  String titulo = "";
  List<String> listadeArtigosLocais = [];

  showArtigos(String tituloEncomenda){
    setState(() {
      verArtigosHeight = 700.0;
      titulo = tituloEncomenda ;

    });
  }
  closeArtigos(){
    setState(() {
      verArtigosHeight = 0.0;
    });
  }

  var maptype = MapType.normal;
  bool mapaMudado = false;

  static String calculateTimeDifferenceBetween(
      {@required DateTime startDate, @required DateTime endDate}) {
    int seconds = endDate.difference(startDate).inSeconds;
    if (seconds < 60)
      return '$seconds seg';
    else if (seconds >= 60 && seconds < 3600)
      return '${startDate.difference(endDate).inMinutes.abs()} min';
    else if (seconds >= 3600 && seconds < 86400)
      return '${startDate.difference(endDate).inHours} horas';
    else
      return '${startDate.difference(endDate).inDays} dias';
  }


  String generatedPdfFilePath;

  Future<void> generateExampleDocument() async {

    Future.delayed(const Duration(seconds: 1), () async {

      var htmlContent = """
    <!DOCTYPE html>
    <html>
      <head>
        <style>
        table, th, td {
          border: 1px solid black;
          border-collapse: collapse;
        }
        th, td, p {
          padding: 5px;
          text-align: left;
        }
        </style>
      </head>
      <body>
        <h2>GUIA DE TRANSPORTE   </h2>
        
        <table style="width:100%">
        
          <tr>
            <th>ENTIDADES</th>
            <th>DETALHES</th>
          </tr>
          <tr>
            <th>TRANSPORTADOR</th>
            <td>
             
                <p>  <b>Sociedade: </b> TARIK & CAROLLINE, LDA </p>
                <p>  <b>Contribuinte (NIPC): </b> 516506021 </p>
                <p>  <b>Capital Social: </b> 50.000 Euros </p>
                <p>  <b>Endereço (Sede): </b> Rua Arlindo Viera de Sá, Nr 319, 1 esq <br> Distrito: Porto Concelho: Gondomar Freguesia: Fânzeres e São Pedro da Cova <br> 4510 499 Fânzeres, Gondomar </p>
            
            </td>
          </tr>
          <tr>
            <td>EXPEDIDOR</td>
            <td></td>
          </tr>
          <tr>
            <td>DESTINATÁRIO</td>
            <td></td>
          </tr>
          <tr>
            <td>LOCAL DE CARGA</td>
           <td></td>
          </tr>
          <tr>
            <td>LOCAL DE DESCARGA</td>
           <td></td>
          </tr>
          <tr>
            <td>MATRÍCULA</td>
           <td></td>
          </tr>
          <tr>
            <td>MARCA</td>
           <td></td>
          </tr>
          <tr>
            <td>MODELO</td>
           <td></td>
          </tr>

          <tr>
            <td>INSTRUÇÕES DO EXPEDIDOR</td>
           <td></td>
          </tr>
          
          <tr>
            <td>MERCADORIA TRANSPORTADA</td>
            <td></td>
          </tr>

          
          
        </table>
        
        <!--<p>Image loaded from web</p>-->
        <!--<img src="https://i.imgur.com/wxaJsXF.png" alt="web-img">-->
      </body>
    </html>
    """;

      if(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).nome_motorista != null){
        htmlContent = """
    <!DOCTYPE html>
    <html>
      <head>
        <style>
        table, th, td {
          border: 1px solid black;
          border-collapse: collapse;
        }
        th, td, p {
          padding: 5px;
          text-align: left;
        }
        </style>
      </head>
      <body>
        <h2>GUIA DE TRANSPORTE   </h2>
        
        <table style="width:100%">
        
          <tr>
            <th>ENTIDADES</th>
            <th>DETALHES</th>
          </tr>
          <tr>
            <th colspan="2">
             
                <p>  <b>Sociedade: </b> TARIK & CAROLLINE, LDA </p>
                <p>  <b>Contribuinte (NIPC): </b> 516506021 </p>
                <p>  <b>Capital Social: </b> 50.000 Euros </p>
                <p>  <b>Endereço (Sede): </b> Rua Arlindo Viera de Sá, Nr 319, 1 esq <br> Distrito: Porto Concelho: Gondomar Freguesia: Fânzeres e São Pedro da Cova <br> 4510 499 Fânzeres, Gondomar </p>
            
            </th>
          </tr>
                  <tr>
            <th>TRANSPORTADOR</th>
            <td>
             
                <p>  <b> ${currentCarInfo.transportadora} </b> </p>
                <p>  <b>NIF: </b> ${currentCarInfo.nif}</p>
            
            </td>
          </tr>
          <tr>
            <td>MOTORISTA</td>
            <td>${HelperMethods.getLogisticaEspecifica(widget.logisticaKey).nome_motorista}</td>
          </tr>
           <tr>
            <td>REMETENTE</td>
            <td><b>Nome: </b>${HelperMethods.getLogisticaEspecifica(widget.logisticaKey).remetente} <br>
             <b>Telefone: </b> ${HelperMethods.getClienteDaLogistica(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).uidCliente).telefone}
            </td>
          </tr>
          <tr>
            <td>DESTINATÁRIO</td>
            <td>${HelperMethods.getLogisticaEspecifica(widget.logisticaKey).destinatario}</td>
          </tr>
          <tr>
            <td>LOCAL DE CARGA</td>
            <td>${HelperMethods.getLogisticaEspecifica(widget.logisticaKey).endereco_origem}</td>
          </tr>
          <tr>
            <td>LOCAL DE DESCARGA</td>
            <td>${HelperMethods.getLogisticaEspecifica(widget.logisticaKey).endereco_destino}</td>
          </tr>
          <tr>
            <td>MATRÍCULA</td>
            <td>${currentCarInfo.placa}</td>
          </tr>
          <tr>
            <td>MARCA</td>
            <td>${currentCarInfo.marca}</td>
          </tr>
          <tr>
            <td>MODELO</td>
            <td>${currentCarInfo.modelo}</td>
          </tr>

          <tr>
            <td>INSTRUÇÕES DO EXPEDIDOR</td>
            <td>${HelperMethods.getLogisticaEspecifica(widget.logisticaKey).observacao}</td>
          </tr>
          
          <tr>
            <td>MERCADORIA TRANSPORTADA</td>
            <td>${HelperMethods.getLogisticaEspecifica(widget.logisticaKey).artigos.toString()}</td>
          </tr>

          
          
        </table>
        
        <!--<p>Image loaded from web</p>-->
        <!--<img src="https://i.imgur.com/wxaJsXF.png" alt="web-img">-->
      </body>
    </html>
    """;
      }

      Directory appDocDir = await getApplicationDocumentsDirectory();
      final targetPath = appDocDir.path;
      final targetFileName = "Guia - "+HelperMethods.getLogisticaEspecifica(widget.logisticaKey).referencia;

      final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(htmlContent, targetPath, targetFileName);
      generatedPdfFilePath = generatedPdfFile.path;
    });




  }




  @override
  Widget build(BuildContext context) {

     double custo_porcentagem = double.parse(widget.taxaDeCobranca)/100;
     double custo_por_hora_servico = double.parse('${widget.custo}');
     double custo_envio = double.parse(widget.taxaDeEnvio);

     double total_previsao = (custo_porcentagem * custo_por_hora_servico) + custo_por_hora_servico + custo_envio;
     custo_total_provisorio = total_previsao;

    CameraPosition initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: SOURCE_LOCATION);





    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appbar(),
      body: Stack(
        children: <Widget>[

          GoogleMap(
              myLocationEnabled: false,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              polylines: _polylines,
              mapType: maptype,
              initialCameraPosition: initialLocation,
              onMapCreated: onMapCreated
          ),
          mostrarArtigos(),
         Column(
            children: <Widget>[
              // offLineMode(),
              Expanded(
                child: SizedBox(),
              ),
              mapType(),
              // myLocation(),
              SizedBox(
                height: 50,
              ),

              detalhesDaRota(),
              // offLineModeDetail(),
              Container(
                height: MediaQuery.of(context).padding.bottom,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),

            ],
          ),


        ],
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
            AppLocalizations.of(widget.referencia),
            style: Theme.of(context).textTheme.subtitle2.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headline6.color,
            ),
          ),
          SizedBox(
            width: 16,
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
                          Text("Artigos da logistica",style: Theme.of(context).textTheme.subtitle2),
                          Text(AppLocalizations.of('Referência da logística: ' + widget.referencia),
                              style: Theme.of(context).textTheme.caption),
                          SizedBox(height: 10),
                          // tableData(),
                          Container(
                            height: 500,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color:Colors.black26,
                            ),
                            child: StreamBuilder(
                                stream: FirebaseDatabase.instance.reference().child('logistica').child(logistica.key).child("artigos").onValue,
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

  Widget mapType() {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
      InkWell(
          onTap: () {

            setState(() {
              if(!mapaMudado) {
                mapaMudado = true;
                this.maptype = MapType.normal;
              }else {
                mapaMudado = false;
                this.maptype = MapType.satellite;
              }
            });
          },
        child:  Container(
          decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor,
                blurRadius: 12,
                spreadRadius: -5,
                offset: new Offset(0.0, 0),
              )
            ],
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Icon(
              Icons.public,
              color: Theme.of(context).textTheme.headline6.color,
            ),
          ),
        ),
      ),

        ],
      ),
    );
  }

  Widget detalhesDaRota(){
    return Card(
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).dividerColor.withOpacity(0.03),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.car),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(widget.remetente),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        // Funciona, Serviço adicional
                        // StreamBuilder(
                        //     stream: FirebaseDatabase.instance.reference().child('logistica').child(logistica.key).onValue,
                        //     builder: (context, AsyncSnapshot<Event> snapshot) {
                        //       if (snapshot.hasData) {
                        //         duracaoDoTrabalho = "";
                        //         DataSnapshot dataValues = snapshot.data.snapshot;
                        //         Map<dynamic, dynamic> values = dataValues.value;
                        //
                        //         if(dataValues.value != null){
                        //
                        //           if(values['status'].toString() == "concluido"){
                        //
                        //           }
                        //
                        //
                        //
                        //           return    Text(
                        //             values['servico_adicional'].toString(),
                        //             style: Theme.of(context).textTheme.overline.copyWith(
                        //               fontSize: 6,
                        //             ) ,
                        //           );
                        //
                        //         } else {
                        //           return Center( child:Text(
                        //             AppLocalizations.of('0'),
                        //             style: Theme.of(context).textTheme.subtitle2.copyWith(
                        //               fontWeight: FontWeight.normal,
                        //               color: Colors.black,
                        //             ),
                        //           )
                        //           );
                        //         }
                        //       }
                        //       return Text("...");
                        //     }),

                        Text(widget.destinatario, style: Theme.of(context).textTheme.caption ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      StreamBuilder(
                          stream: FirebaseDatabase.instance.reference().child('logistica').child(logistica.key).onValue,
                          builder: (context, AsyncSnapshot<Event> snapshot) {
                            if (snapshot.hasData) {
                              duracaoDoTrabalho = "";
                              DataSnapshot dataValues = snapshot.data.snapshot;
                              Map<dynamic, dynamic> values = dataValues.value;

                              if(dataValues.value != null){

                                if(values['status'].toString() == "concluido"){

                                }



                                return    Text(
                                  "Total " + values['pagamento'].toString() ,
                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ) ,
                                );

                              } else {
                                return Center( child:Text(
                                  AppLocalizations.of('0'),
                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                )
                                );
                              }
                            }
                            return Text("...");
                          }),



                      StreamBuilder(
                          stream: FirebaseDatabase.instance.reference().child('logistica').child(logistica.key).onValue,
                          builder: (context, AsyncSnapshot<Event> snapshot) {
                            if (snapshot.hasData) {
                              duracaoDoTrabalho = "";
                              DataSnapshot dataValues = snapshot.data.snapshot;
                              Map<dynamic, dynamic> values = dataValues.value;

                              if(dataValues.value != null){

                                  if(values['status'].toString() == "concluido"){

                                    DateTime roundedDateTime1 = DateTime.parse(values['inicio'].toString()).roundDown(delta: Duration(hours: 1));
                                    DateTime addHour1 = roundedDateTime1.add(new Duration(hours: 1));

                                    DateTime roundedDateTime2 = DateTime.parse(values['fim'].toString()).roundDown(delta: Duration(hours: 1));
                                    DateTime addHour2 = roundedDateTime2.add(new Duration(hours: 1));

                                    duracaoDoTrabalho = calculateTimeDifferenceBetween(startDate: addHour1, endDate: addHour2);
                                    int diff = addHour1.difference(addHour2).inHours;

                                    print("Hora arrendondada================================================="+addHour1.toString());
                                    print("Hora arrendondada 111 ================================================="+addHour2.toString());
                                    // print("Hora arrendondada 2222 ================================================= "+duracaoDoTrabalho111.substring(1, (duracaoDoTrabalho111.length-1))+ "|||" + diff.toString());
                                    print(diff);
                                    // duracaoDoTrabalho = calculateTimeDifferenceBetween(startDate: DateTime.parse(values['inicio'].toString()), endDate: DateTime.parse(values['fim'].toString()));

                                    // duracaoDoTrabalho = diff.toString();

                                    print("Logisticas -------------------------------------------------------------------"+ values.toString());
                                  }



                                return    Text(AppLocalizations.of("Duração " + duracaoDoTrabalho), style: Theme.of(context).textTheme.overline.copyWith(
                                  fontSize: 8
                                ));

                              } else {
                                return Center( child:Text(
                                  AppLocalizations.of('0'),
                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                )
                                );
                              }
                            }
                            return Text("...");
                          }),

                      StreamBuilder(
                          stream: FirebaseDatabase.instance.reference().child('logistica').child(logistica.key).onValue,
                          builder: (context, AsyncSnapshot<Event> snapshot) {
                            if (snapshot.hasData) {
                              duracaoDoTrabalho = "";
                              DataSnapshot dataValues = snapshot.data.snapshot;
                              Map<dynamic, dynamic> values = dataValues.value;

                              if(dataValues.value != null){

                                if(values['status'].toString() == "concluido"){

                                }



                                return    Text(
                                  "Serviço " + values['custo'].toString()+  "€",
                                  style: Theme.of(context).textTheme.overline.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ) ,
                                );

                              } else {
                                return Center( child:Text(
                                  AppLocalizations.of('0'),
                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                )
                                );
                              }
                            }
                            return Text("...");
                          }),




                    //   Text(AppLocalizations.of("Taxa de envio   " + widget.taxaDeEnvio +  "€"), style: Theme.of(context).textTheme.overline),
                    //   Text(AppLocalizations.of("Taxa de serviço   " + widget.taxaDeCobranca +  "%"), style: Theme.of(context).textTheme.overline),
                    ],
                  )
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).disabledColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            logisticaKey : logistica.key,
                            referenciaDaLogistic : widget.referencia,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.question_answer,
                          color: Theme.of(context).disabledColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            AppLocalizations.of("Chat"),
                            style: Theme.of(context).textTheme.caption.copyWith(
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                  height: 48,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PDFViewerScaffold(appBar: AppBar(title: Text("Guia de transporte: " +  widget.referencia)), path: generatedPdfFilePath)),
                      );
                      print("Caminho do PDF: " + generatedPdfFilePath.toString());
                      Share.shareFiles(['${generatedPdfFilePath}'], text: 'Your PDF!');
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.local_shipping,
                          color: Theme.of(context).disabledColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Guia",
                            style: Theme.of(context).textTheme.caption.copyWith(
                              color: Theme.of(context).disabledColor,

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                  height: 48,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.loyalty,
                          color: Theme.of(context).disabledColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            widget.tipo,
                            style: Theme.of(context).textTheme.caption.copyWith(
                              color: Theme.of(context).disabledColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context).dividerColor,
                    blurRadius: 8,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  highlightColor: Colors.transparent,
                  onTap: () {
                    showArtigos("Artigos da Logistica");
                  },
                  child: Center(
                    child: Text(
                      AppLocalizations.of('Ver artigos'),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
    setMapPins();
    setPolylines();
  }

  setPolylines() async {

    var thisDetails = await HelperMethods.getDirectionDetails(LatLng(double.parse(logistica.latitudeColeta), double.parse(logistica.longitudeColeta)),
        LatLng(double.parse(logistica.latitudeEntrega), double.parse(logistica.longitudeEntrega)));
    tripDirectionDetails = thisDetails;

    List<PointLatLng> results = polylinePoints.decodePolyline(thisDetails.encodedPoints);
    if (results.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Theme.of(context).primaryColor,
          width: 2,
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: SOURCE_LOCATION,
          icon: sourceIcon,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Local de colecta"),
        ));
      },));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: DEST_LOCATION,
          icon: destinationIcon,
          onTap: () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Local de entrega"),
      ));
      },));
    });
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


enum ProsseType {
  dropOff,
  mapPin,
  requset,
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}

extension DateTimeExtension on DateTime {
  DateTime roundDown({Duration delta = const Duration(hours: 1)}){
    return DateTime.fromMillisecondsSinceEpoch(
        this.millisecondsSinceEpoch -
            this.millisecondsSinceEpoch % delta.inMilliseconds
    );
  }
}

external DateTime add(Duration duration);