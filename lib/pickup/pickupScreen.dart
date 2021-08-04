import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/home/chatScreen.dart';
import 'package:my_cab_driver/models/logisticaExtra.dart';
import 'package:my_cab_driver/models/usuario.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/database/HelperMethods.dart';
import 'package:my_cab_driver/database/data/methods.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../appTheme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_cab_driver/pickup/dropoffScreen.dart';
import 'package:location/location.dart';

class PickupScreen extends StatefulWidget {

  final String logisticaKey;
  const PickupScreen({Key key, this.logisticaKey}) : super(key: key);

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseAuth authFB = FirebaseAuth.instance;

  //Track Realtime
  Location location;
  LocationData _currentPosition;
  LocationData destinationLocation;
  String _address,_dateTime;
  Marker marker1;
  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);

  String duracaoRemanescente;
  String distanciaRemanescente;



  //End Track Realtime

  final double CAMERA_ZOOM = 15;
  final double CAMERA_TILT = 80;
  final double CAMERA_BEARING = 30;
  // final LatLng SOURCE_LOCATION = LatLng(double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).latitudeColeta), double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).longitudeColeta));
  // final LatLng DEST_LOCATION   = LatLng(double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).latitudeEntrega), double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).longitudeEntrega));
  // //
  Completer<GoogleMapController> _controller = Completer();
  PolylinePoints polylinePoints;
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



  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5), ConstanceData.drivingPin,
    );
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        ConstanceData.endPin);
  }

  static Future<void> navigateTo(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  void initState() {
    super.initState();

    HelperMethods.getLogisticaEspecifica(widget.logisticaKey);
    // generateExampleDocument1();
    setSourceAndDestinationIcons();
    setInitialLocation();

    location = new Location();
    polylinePoints = PolylinePoints();

    location.onLocationChanged.listen((l) {
      print("Coordenadas---------------------------------" + l.toString());
      _currentPosition = l;
      updatePinOnMap();

      setTrack(_currentPosition.latitude, _currentPosition.longitude);
      setDuracao_e_Distancia (_currentPosition.latitude,
                              _currentPosition.longitude,
                              double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).latitudeColeta),
                              double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).longitudeColeta));

                            });

    getLoc();

  }

  void updatePinOnMap() async {

    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: 18,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(_currentPosition.latitude,
          _currentPosition.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition = LatLng(_currentPosition.latitude,
          _currentPosition.longitude);

      //Remover
      _markers.removeWhere((m) => m.markerId.value == 'actualPin');


      // Actual posicao
      _markers.add(Marker(
        markerId: MarkerId('actualPin'),
        position: pinPosition,
        icon: sourceIcon,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Minha localização"),
          ));
        },));

    });
  }

  void setInitialLocation() async {
    _currentPosition = await location.getLocation();

    destinationLocation = LocationData.fromMap({
      "latitude": double.parse(HelperMethods
          .getLogisticaEspecifica(widget.logisticaKey)
          .latitudeColeta),
      "longitude": double.parse(HelperMethods
          .getLogisticaEspecifica(widget.logisticaKey)
          .longitudeColeta)
    });
  }

  void showPinsOnMap() async {

    setState(() {
      // source pin
      _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: LatLng(double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).latitudeColeta), double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).longitudeColeta)),
        icon: destinationIcon,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Local de colecta"),
          ));
        },));
      // destination pin
      // _markers.add(Marker(
      //   markerId: MarkerId('destPin'),
      //   position: LatLng(double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).latitudeEntrega), double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).longitudeEntrega)),
      //   icon: destinationIcon,
      //   onTap: () {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       content: Text("Local de entrega"),
      //     ));
      //   },));

    });

    // setPolylines();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state,) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
          this.maptype = MapType.normal;
      });
    }
  }

  Future<void> setDuracao_e_Distancia (double latActual, double logActual, double latDestino, double logDestiono) async {

    var thisDetails = await HelperMethods.getDirectionDetails(LatLng(latActual, logActual), LatLng(latDestino, logDestiono));

    setState(() {
      tripDirectionDetails = thisDetails;
    });

  }

  void setTrack(double lat, double log) async {
    DatabaseReference trackRef = await FirebaseDatabase.instance.reference().child('rastreio');

    Map rastreioMap = {
      'latitude': lat,
      'longitude': log,
      'ikatoken' : HelperMethods.getLogisticaEspecifica(widget.logisticaKey).token_motorista,
      'status' : HelperMethods.getLogisticaEspecifica(widget.logisticaKey).estado,
      'date': DateTime.now().toString().substring(0,16)
    };

    trackRef.child('${widget.logisticaKey}').set(rastreioMap);

  }

  getLoc() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // _permissionGranted = await location.hasPermission();
    // if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     return;
    //   }
    // }

    _currentPosition = await location.getLocation();
    _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.latitude} : ${currentLocation.longitude}");
      print("Coordenadas123---------------------------------");
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);

      });
    });
  }


  void onMapCreated(GoogleMapController controller) async  {
    controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
    showPinsOnMap();
    // setPolylines();
  }

  // setPolylines() async {
  //
  //   Future.delayed(const Duration(seconds: 1), () async {
  //     var thisDetails = await HelperMethods.getDirectionDetails(
  //         LatLng(_currentPosition.latitude, _currentPosition.longitude),
  //         LatLng(double.parse(HelperMethods
  //             .getLogisticaEspecifica(widget.logisticaKey)
  //             .latitudeColeta), double.parse(HelperMethods
  //             .getLogisticaEspecifica(widget.logisticaKey)
  //             .longitudeColeta)));
  //     tripDirectionDetails = thisDetails;
  //
  //     List<PointLatLng> results = polylinePoints.decodePolyline(
  //         thisDetails.encodedPoints);
  //     if (results.isNotEmpty) {
  //       // loop through all PointLatLng points and convert them
  //       // to a list of LatLng, required by the Polyline
  //       results.forEach((PointLatLng point) {
  //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //       });
  //     }
  //
  //     setState(() {
  //       // create a Polyline instance
  //       // with an id, an RGB color and the list of LatLng pairs
  //       Polyline polyline = Polyline(
  //           polylineId: PolylineId("poly"),
  //           color: Theme
  //               .of(context)
  //               .primaryColor,
  //           width: 5,
  //           points: polylineCoordinates);
  //
  //       _polylines.add(polyline);
  //     });
  //   });
  // }

  setPolylines() async {

    // var thisDetails = await HelperMethods.getDirectionDetails(LatLng(_currentPosition.latitude,_currentPosition.longitude),
    //     LatLng(double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).latitudeColeta), double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).longitudeColeta)));
    // tripDirectionDetails = thisDetails;
    Future.delayed(const Duration(seconds: 2), () async {
      PolylineResult  results =
      await polylinePoints.getRouteBetweenCoordinates(googleAPIKey,
          PointLatLng(_currentPosition.latitude, _currentPosition.longitude),
          PointLatLng(double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).latitudeColeta), double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).longitudeColeta)),
          travelMode: TravelMode.driving);//.decodePolyline(thisDetails.encodedPoints);

      print("Polilinhas-----------------------: "+ results.toString());
      if (results.points.isNotEmpty) {
        // loop through all PointLatLng points and convert them
        // to a list of LatLng, required by the Polyline
        results.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          print("Polilinhas1-----------------------: "+ LatLng(point.latitude, point.longitude).toString());
        });
      }

      setState(() {
        // create a Polyline instance
        // with an id, an RGB color and the list of LatLng pairs
        Polyline polyline = Polyline(
            polylineId: PolylineId("poly"),
            color: Theme.of(context).primaryColor,
            width: 4,
            points: polylineCoordinates);

        // add the constructed polyline as a set of points
        // to the polyline set, which will eventually
        // end up showing up on the map
        _polylines.add(polyline);
      });

    });
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: LatLng(double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).latitudeColeta), double.parse(HelperMethods.getLogisticaEspecifica(widget.logisticaKey).longitudeColeta)),
        icon: destinationIcon,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Local de carga"),
          ));
        },));
    });
  }


  var maptype = MapType.normal;
  bool mapaMudado = false;
  String generatedPdfFilePath1;

  Future<void> generateExampleDocument1() async {

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

      if(logisticaEspecifica.nome_motorista != null){
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
            <td>${logisticaEspecifica.nome_motorista}</td>
          </tr>
           <tr>
            <td>REMETENTE</td>
            <td><b>Nome: </b>${logisticaEspecifica.remetente} <br>
                <b>Telefone: </b> ${clienteDaLogisitca.telefone}
            </td>
          </tr>
          <tr>
            <td>DESTINATÁRIO</td>
            <td>${logisticaEspecifica.destinatario}</td>
          </tr>
          <tr>
            <td>LOCAL DE CARGA</td>
            <td>${logisticaEspecifica.endereco_origem}</td>
          </tr>
          <tr>
            <td>LOCAL DE DESCARGA</td>
            <td>${logisticaEspecifica.endereco_destino}</td>
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
            <td>${logisticaEspecifica.observacao}</td>
          </tr>
          
          <tr>
            <td>MERCADORIA TRANSPORTADA</td>
            <td>${logisticaEspecifica.artigos.toString()}</td>
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
      final targetFileName = "Guia - "+logisticaEspecifica.referencia;

      final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(htmlContent, targetPath, targetFileName);
      generatedPdfFilePath1 = generatedPdfFile.path;
    });

  }

  int count = 0;


  @override
  Widget build(BuildContext context) {

    CameraPosition _initialcameraposition = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: LatLng(0.5937, 0.9629));

    if (_currentPosition != null) {
      _initialcameraposition = CameraPosition(
          zoom: CAMERA_ZOOM,
          bearing: CAMERA_BEARING,
          tilt: CAMERA_TILT,
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude));
    }

    return  StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child('logistica').child(widget.logisticaKey).onValue,
        builder: (context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {

            DataSnapshot dataValues = snapshot.data.snapshot;
            Map<dynamic, dynamic> values = dataValues.value;
            if(dataValues.value != null){
              values.forEach((key, values) {


              });
              return  Scaffold(
                appBar: appBar(),
                key: _scaffoldKey,
                drawer: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
                  child: Drawer(
                    child: AppDrawer(
                      selectItemName: 'INDO A RECOLHA',
                    ),
                  ),
                ),
                body: Stack(
                  children: <Widget>[
                    GoogleMap(
                      myLocationEnabled: true,
                      compassEnabled: true,
                      tiltGesturesEnabled: false,
                      markers: _markers,
                      mapType: maptype,
                      initialCameraPosition: _initialcameraposition,
                      onMapCreated: onMapCreated,

                    ),mapType(),
                    DraggableScrollableSheet(
                      initialChildSize: 0.15,
                      minChildSize: 0.15,
                      maxChildSize: 0.9,
                      builder: (BuildContext context, ScrollController scrollController) {
                        return  StreamBuilder(
                            stream: FirebaseDatabase.instance.reference().child('logistica').child(widget.logisticaKey).onValue,
                            builder: (context, AsyncSnapshot<Event> snapshot) {
                              if (snapshot.hasData) {

                                DataSnapshot dataValues = snapshot.data.snapshot;
                                Map<dynamic, dynamic> values = dataValues.value;



                                if(dataValues.value != null){
                                  values.forEach((key, values) {

                                    logisticaEspecifica = LogisticaExtra.fromSnapshot(dataValues);

                                    count++;
                                    if(count == 1) {
                                      DatabaseReference userPerfilRef = FirebaseDatabase
                                          .instance.reference().child(
                                          'cliente/${logisticaEspecifica
                                              .uidCliente}/perfil');
                                      userPerfilRef.once().then((
                                          DataSnapshot snapshot) {
                                        if (snapshot.value != null) {
                                          clienteDaLogisitca =
                                              Usuario.fromSnapshot(snapshot);
                                          print(
                                              "Dados do CLientes ========================================================== " +
                                                  clienteDaLogisitca
                                                      .nomecompleto);


                                          generateExampleDocument1();
                                          print(
                                              "Dados do CLientes ========================================================== " +
                                                  clienteDaLogisitca.telefone);


                                          print(
                                              "Dados do CLientes1111 ========================================================== " +
                                                  clienteDaLogisitca.telefone);
                                        }
                                      });
                                    }




                                  });
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.isLightTheme ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                    child: ListView(
                                      controller: scrollController,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 80, left: 80),
                                          child: Container(
                                            height: 10,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                              color: Colors.black12,
                                            ),
                                            child: Text("Deslize para cima", style: TextStyle(color: Colors.black, fontSize: 8), textAlign: TextAlign.center,),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),


                                        //Duracao e Distancia
                                        Padding(
                                          padding: const EdgeInsets.only(right: 14, left: 14, top: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    'Duração',
                                                    style: Theme.of(context).textTheme.caption.copyWith(
                                                      color: Theme.of(context).disabledColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(tripDirectionDetails == null? "" : tripDirectionDetails.durationText),
                                                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Theme.of(context).textTheme.headline6.color,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    AppLocalizations.of('Distância'),
                                                    style: Theme.of(context).textTheme.caption.copyWith(
                                                      color: Theme.of(context).disabledColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    tripDirectionDetails == null? "" : tripDirectionDetails.distanceText  ,
                                                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Theme.of(context).textTheme.headline6.color,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    AppLocalizations.of('Guia'),
                                                    style: Theme.of(context).textTheme.caption.copyWith(
                                                      color: Theme.of(context).disabledColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Container(
                                                      alignment: Alignment.centerRight,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => PDFViewerScaffold(appBar: AppBar(title: Text("Guia de transporte: " +  logisticaEspecifica.referencia)), path: generatedPdfFilePath1)),
                                                          );

                                                          print("Caminho do PDF: " + generatedPdfFilePath1.toString());
                                                          Share.shareFiles(['${generatedPdfFilePath1}'], text: 'Your PDF!');

                                                        },
                                                        child: Icon(
                                                          Icons.cloud_download_sharp,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),


                                        //NAVEGACAO
                                        Padding(
                                          padding: const EdgeInsets.all(14),
                                          child:  InkWell(
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
                                                          Icons.navigation_outlined,
                                                          size: 80,
                                                          color: Colors.blueGrey,
                                                        ),
                                                        Text(
                                                          AppLocalizations.of('Navegar'),
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
                                                            AppLocalizations.of('Será direcionado para a tela de navegação, após o término do mesmo, confirme a recolha da encomenda.'),
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
                                                                  Navigator.pop(context);
                                                                  navigateTo(double.parse(values['latitude_origem'].toString()), double.parse(values['longitude_origem'].toString()));

                                                                },
                                                                child: Container(
                                                                  child: Text(
                                                                    AppLocalizations.of('Navegar'),
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
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.black,
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[

                                                    SizedBox(
                                                      width: 80,
                                                    ),

                                                    Icon(
                                                      Icons.assistant_navigation,
                                                      color: ConstanceData.secoundryFontColor,
                                                      size: 30,
                                                    ),
                                                    SizedBox(
                                                      width: 16,
                                                    ),


                                                    Expanded(
                                                      child:  Text(
                                                        AppLocalizations.of("Abrir navegação"),
                                                        style: Theme.of(context).textTheme.button.copyWith(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      width: 10,
                                                    )
                                                  ],
                                                ),


                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),

                                        //Remetente e CHAT
                                        Padding(
                                          padding: EdgeInsets.only(left: 14, right: 14),
                                          child: Row(
                                            children: <Widget>[
                                              CircleAvatar(
                                                backgroundColor: Theme.of(context).primaryColor,
                                                radius: 22,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ChatScreen(
                                                          logisticaKey : widget.logisticaKey,
                                                          referenciaDaLogistic : logisticaEspecifica.referencia,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.question_answer,
                                                    color: Colors.white,
                                                  ),
                                                ),



                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    AppLocalizations.of('Remetente'),
                                                    style: Theme.of(context).textTheme.caption.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Theme.of(context).disabledColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(logisticaEspecifica.remetente),
                                                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Theme.of(context).textTheme.headline6.color,
                                                    ),
                                                  )
                                                ],
                                              ),



                                            ],
                                          ),
                                        ),

                                        //CONFIRMAR RECOLHA
                                        Padding(
                                          padding: const EdgeInsets.all(14),
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
                                                          color: Colors.blueGrey,
                                                        ),
                                                        Text(
                                                          AppLocalizations.of('Confirmar a recolha'),
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
                                                            AppLocalizations.of('Ao clicar em COMEÇAR, confirma que já chegou ao local de recolha e fez a devida recolha da encomenda'),
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
                                                                  Metodos.iniciarViagemRouteRequest(context, '${widget.logisticaKey}');

                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                    content: Text("Bom trabalho, boa viagem!"),
                                                                    duration: const Duration(seconds: 9),
                                                                  ));

                                                                  Navigator.pop(context);
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => DropOffScreen(
                                                                        logisticaKey: "${widget.logisticaKey}",
                                                                      ),
                                                                    ),
                                                                  );

                                                                  // Navigator.pushReplacementNamed

                                                                },
                                                                child: Container(
                                                                  child: Text(
                                                                    AppLocalizations.of('Começar'),
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
                                                  AppLocalizations.of('CONFIRMAR A RECOLHA'),
                                                  style: Theme.of(context).textTheme.button.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: ConstanceData.secoundryFontColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),





                                        // Padding(
                                        //   padding: const EdgeInsets.all(14),
                                        //   child: InkWell(
                                        //     highlightColor: Colors.transparent,
                                        //     splashColor: Colors.transparent,
                                        //     onTap: () {
                                        //
                                        //       Navigator.push(
                                        //         context,
                                        //         MaterialPageRoute(builder: (context) => PDFViewerScaffold(appBar: AppBar(title: Text("Guia de transporte: " +  HelperMethods.getLogisticaEspecifica(widget.logisticaKey).referencia)), path: generatedPdfFilePath1)),
                                        //       );
                                        //
                                        //       print("Caminho do PDF: " + generatedPdfFilePath1.toString());
                                        //       Share.shareFiles(['${generatedPdfFilePath1}'], text: 'Your PDF!');
                                        //
                                        //     },
                                        //     child: Container(
                                        //       height: 40,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius: BorderRadius.circular(10),
                                        //         color: Colors.grey,
                                        //       ),
                                        //       child: Center(
                                        //         child: Text(
                                        //           AppLocalizations.of('GUIA DE TRANSPORTE'),
                                        //           style: Theme.of(context).textTheme.button.copyWith(
                                        //             fontWeight: FontWeight.bold,
                                        //             color: ConstanceData.secoundryFontColor,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),

                                        //Instrucoes

                                        //Instrucoes
                                        Padding(
                                          padding: EdgeInsets.only(right: 14, left: 14, top: 10),
                                          child: Row(
                                            children: <Widget>[

                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                AppLocalizations.of('Instruções'),
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).textTheme.headline6.color,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15, top: 10),
                                          child: Row(
                                            children: <Widget>[
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
                                                        HelperMethods.getLogisticaEspecifica(widget.logisticaKey).observacao,
                                                        style: TextStyle(fontSize: 6.0, color: Colors.black),
                                                      ),
                                                    ),
                                                  ),

                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 1,
                                                  width: 50,
                                                  color: Theme.of(context).dividerColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        //Servicos Adicionais
                                        Padding(
                                          padding: EdgeInsets.only(right: 14, left: 14, top: 10),
                                          child: Row(
                                            children: <Widget>[

                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                AppLocalizations.of('Itens e serviços adicionais'),
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).textTheme.headline6.color,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15, top: 10),
                                          child: Row(
                                            children: <Widget>[

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
                                           HelperMethods.getLogisticaEspecifica(widget.logisticaKey).servico_adicional == null ?
                                           "Nenhum serviço adicional" : HelperMethods.getLogisticaEspecifica(widget.logisticaKey).servico_adicional.toString(),
                                                        style: TextStyle(fontSize: 6.0, color: Colors.black),
                                                      ),
                                                    ),
                                                  ),

                                                ),
                                              ),

                                              SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 1,
                                                  width: 50,
                                                  color: Theme.of(context).dividerColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        SizedBox(
                                          height: MediaQuery.of(context).padding.bottom + 16,
                                        ),
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
                            });




                      },
                    ),

                    StreamBuilder(
                        stream: FirebaseDatabase.instance.reference().child('logistica').child(widget.logisticaKey).onValue,
                        builder: (context, AsyncSnapshot<Event> snapshot) {
                          if (snapshot.hasData) {

                            DataSnapshot dataValues = snapshot.data.snapshot;
                            Map<dynamic, dynamic> values = dataValues.value;
                            if(dataValues.value != null){
                              values.forEach((key, values) {


                              });
                              return Column(
                                children: <Widget>[
                                  // Container(
                                  //   height: AppBar().preferredSize.height -20,
                                  //   color: Theme.of(context).primaryColor,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(right: 14, left: 14),
                                  //     child: Row(
                                  //       children: <Widget>[
                                  //         Icon(
                                  //           Icons.assistant_photo,
                                  //           color: ConstanceData.secoundryFontColor,
                                  //         ),
                                  //         // Text(
                                  //         //   " Para:",
                                  //         //   style: Theme.of(context).textTheme.headline6.copyWith(
                                  //         //     fontWeight: FontWeight.bold,
                                  //         //     color: ConstanceData.secoundryFontColor,
                                  //         //   ),
                                  //         // ),
                                  //         SizedBox(
                                  //           width: 16,
                                  //         ),
                                  //
                                  //         Expanded(
                                  //           child: Text(
                                  //             AppLocalizations.of(logistica.endereco_origem),
                                  //             style: Theme.of(context).textTheme.subtitle2.copyWith(
                                  //               fontWeight: FontWeight.bold,
                                  //               color: ConstanceData.secoundryFontColor,
                                  //             ),
                                  //             overflow: TextOverflow.ellipsis,
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    height: AppBar().preferredSize.height,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child:  InkWell(
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
                                                      color: Colors.blueGrey,
                                                    ),
                                                    Text(
                                                      AppLocalizations.of('EMERGÊNCIA'),
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
                                                        AppLocalizations.of('Reportar emergência'),
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

                                                              sos("Emergencia", '${widget.logisticaKey}', authFB.currentUser.uid, _currentPosition.latitude.toString(), _currentPosition.longitude.toString());

                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                content: Text("Pedido enviado com sucesso! Brevemente entraremos em contacto consigo."),
                                                                duration: const Duration(seconds: 9),
                                                              ));

                                                              Navigator.pop(context);


                                                              // Navigator.pushReplacementNamed

                                                            },
                                                            child: Container(
                                                              child: Text(
                                                                AppLocalizations.of('Reportar'),
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
                                            color: Colors.red,
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of("S.O.S"),
                                              style: Theme.of(context).textTheme.button.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: ConstanceData.secoundryFontColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                        })

                  ],
                ),
              );

            } else {
              return Center( child: CircularProgressIndicator());
            }
          }
          return Center( child: CircularProgressIndicator());
        });





  }


  void sos(String mensagem, String keyLogistica, String uidExecutivo, String lat, String log) async {
    DatabaseReference newUserRef =
    FirebaseDatabase.instance.reference().child("sos_executivo/" + keyLogistica);
    Map func = {
      'mensagem': mensagem,
      'key_executive': uidExecutivo,
      'latitude': lat,
      'longitude': log,
      'key_logistica': keyLogistica,
      'estado': 'aguardando',
      'created_at': DateTime.now().toString()
    };
    newUserRef.set(func);
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
              AppLocalizations.of('INDO A RECOLHA'),
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
