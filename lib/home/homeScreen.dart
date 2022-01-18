import 'dart:io';

import 'package:animator/animator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/home/riderList.dart';
import 'package:my_cab_driver/models/logistica.dart';
import 'package:my_cab_driver/models/logisticaExtra.dart';
import 'package:my_cab_driver/models/usuario.dart';
import 'package:my_cab_driver/models/veiculoExtra.dart';
import 'package:my_cab_driver/pickup/dropoffScreen.dart';
import 'package:my_cab_driver/pickup/pickupScreen.dart';
import '../appTheme.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/database/HelperMethods.dart';
import 'package:firebase_database/firebase_database.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final FirebaseAuth authFB = FirebaseAuth.instance;
  int lConcluidasInt = 0;
  int lPendenteInt = 0;
  int lDisponivelInt = 0;

  @override
  initState()  {
    super.initState();
    final FirebaseAuth authFB = FirebaseAuth.instance;
    currentUserInfo = HelperMethods.getUsuario((authFB.currentUser).uid);
    print("UIDD HOME:==================== "+ (authFB.currentUser).uid + "  |  " + currentUserInfo.toString());
    HelperMethods.getCurrentUserInfo();
    HelperMethods.getVeiculoDados();
    HelperMethods.getCarList();
    HelperMethods.getTaxasDaEmpresa();
    HelperMethods.getServicosAdicionais();
    HelperMethods.getTiposDeCasas();
    HelperMethods.getTermosContactos();
    // getLoc();

     FirebaseDatabase.instance.reference().child('motorista/${authFB.currentUser.uid}/perfil/modo').once().then((DataSnapshot snapshot) => {
      print("New no INIT ----------------=========------------ Novo estado: " + snapshot.value.toString()),

    //  Verifcar o ultimo estado: Online ou Offline
      snapshot.value.toString() == "online" ? isOffline = true : isOffline = false,

    });
  }

  BitmapDescriptor bitmapDescriptorStartLocation;
  BitmapDescriptor bitmapDescriptorStartLocation2;
  BitmapDescriptor bitmapDescriptorStartLocation3;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = Location();
  LocationData _currentPosition;

  void _onMapCreated(GoogleMapController _cntlr)
  {
    setState(() {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {

      print("Coordenadas para actual localizacao ---------------------------------" + l.toString());
      _currentPosition = l;
      setHomeTrack(l.latitude, l.longitude); //guardar no banco de dados a actual localizacao do driver
      print("Coordenadas para actual localizacao ---------------------------------" + _currentPosition.toString());

      posicaoActual = l;

      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(posicaoActual.latitude, posicaoActual.longitude),zoom: 18),

        ),
      );
    });
      // setMapStyle();
    });
  }

  void setHomeTrack(double lat, double log) async {
    DatabaseReference trackRef = await FirebaseDatabase.instance.reference().child('motorista/${authFB.currentUser.uid}');

    Map rastreioMap = {
      'latitude': lat,
      'longitude': log,
      'date': DateTime.now().toString().substring(0,16)
    };

    trackRef.child('track').set(rastreioMap);

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setLDMapStyle();
    }
  }

  // Future<void> _initMapStyle() async {
  //   maptype ?? =  _controller.setMapStyle(await rootBundle.loadString('assets/styles/google_map.json'));
  // }

  var maptype = MapType.satellite;
  bool mapaMudado = false;


  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
          child: Drawer(
            child: AppDrawer(
              selectItemName: 'Home',
            ),
          ),
        ),
        appBar: AppBar(
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
                child: !isOffline
                    ? Text(
                  AppLocalizations.of('Offline'),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                  textAlign: TextAlign.center,
                )
                    : Text(
                  AppLocalizations.of('Online'),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: AppBar().preferredSize.height,
                width: AppBar().preferredSize.height + 40,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Switch(
                    activeColor: Theme.of(context).primaryColor,
                    value: isOffline,
                    onChanged: (bool value) async {

                      setState(()  {
                        isOffline = !isOffline;

                        DatabaseReference estadoDriverFB = FirebaseDatabase.instance.reference().child('motorista/${authFB.currentUser.uid}/perfil/modo');
                        estadoDriverFB.set(isOffline == true? "online" : "offline");

                      });

                      await FirebaseDatabase.instance.reference().child('motorista/${authFB.currentUser.uid}/perfil/modo').once().then((DataSnapshot snapshot) => {
                        print("New ----------------=========------------ Novo estado: " + snapshot.value.toString()),
                        print ("Estado: " + isOffline.toString()),
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _initialcameraposition),
              mapType: maptype,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
            ),
            !isOffline
                ? Column(
              children: <Widget>[
                offLineMode(),
                Expanded(
                  child: SizedBox(),
                ),
                // myLocation(),
                // SizedBox(
                //   height: 10,
                // ),
                mapType(),
                SizedBox(
                  height: 60,
                ),
                offLineModeDetail(),
                Container(
                  height: MediaQuery.of(context).padding.bottom,
                  color: Theme.of(context).scaffoldBackgroundColor,
                )
              ],
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: SizedBox(),
                ),
                // myLocation(),
                // SizedBox(
                //   height: 10,
                // ),
                SizedBox(
                  height: 10,
                ),
                mapType(),
                SizedBox(
                  height: 35,
                ),
                onLineModeDetail(),

              ],
            ),

          ],
        ),
      ),
    );

  }


  Widget onLineModeDetail() {
    var bootmPadding = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.only(right: 10, left: 10, bottom: bootmPadding),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RiderList(),
              fullscreenDialog: true,
            ),
          );
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 16,
              child: Padding(
                padding: const EdgeInsets.only(right: 24, left: 24),
                child: Animator(
                  tween: Tween<Offset>(
                    begin: Offset(0, 0.5),
                    end: Offset(0, 0),
                  ),
                  duration: Duration(milliseconds: 700),
                  cycles: 1,
                  builder: (anim) => SlideTransition(
                    position: anim,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          new BoxShadow(
                            color: AppTheme.isLightTheme ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 0,
              left: 0,
              bottom: 16,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, left: 12),
                child: Animator(
                  tween: Tween<Offset>(
                    begin: Offset(0, 0.5),
                    end: Offset(0, 0),
                  ),
                  duration: Duration(milliseconds: 700),
                  cycles: 1,
                  builder: (anim) => SlideTransition(
                    position: anim,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          new BoxShadow(
                            color: AppTheme.isLightTheme ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            StreamBuilder(
                stream: FirebaseDatabase.instance.reference().child('logistica').orderByChild('status').equalTo("aguardando").limitToFirst(1).onValue,
                builder: (context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasData) {

                    DataSnapshot dataValues = snapshot.data.snapshot;
print("Logistica ===============================" + dataValues.value.toString());
                    Map<dynamic, dynamic> values = dataValues.value;

                    if(dataValues.value != null){

                      LogisticaExtra logisticaEspec = new LogisticaExtra.fromSnapshot(dataValues);

                      values.forEach((key, values) {

                         logistica = new Logistica();

                        logistica.endereco_origem   = values["endereco_origem"];
                        logistica.endereco_destino  = values["endereco_destino"];

                        logistica.destinatario      = values["destinatario"];
                        logistica.duracao           = values["duracao"];
                        logistica.distancia         = values["distancia"];
                        logistica.preco             = values["custo"];
                        logistica.data              = values["data_envio"];
                        logistica.remetente         = values["nome_usuario"];


                      });
                      return Animator(
                        tween: Tween<Offset>(
                          begin: Offset(0, 0.4),
                          end: Offset(0, 0),
                        ),
                        duration: Duration(milliseconds: 700),
                        cycles: 1,
                        builder: (anim) => SlideTransition(
                          position: anim,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Container(
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
                                                AppLocalizations.of(logistica.remetente),
                                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).textTheme.subtitle2.color,
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
                                                logistica.tipo_de_cliente == "ik_business" ? logistica.preco + "€" : logistica.preco + "€/hora",
                                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).textTheme.headline6.color,
                                                                                                  ),
                                              ),
                                              Text(
                                                logistica.data,
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
                                                AppLocalizations.of(logistica.endereco_origem),
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
                                                AppLocalizations.of(logistica.endereco_destino),
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
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[

                                          Container(
                                            height: 32,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of('Ver mais'),
                                                style: Theme.of(context).textTheme.caption.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: ConstanceData.secoundryFontColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );

                    } else {
                      //Sem encomendas
                      return Animator(
                        tween: Tween<Offset>(
                          begin: Offset(0, 0.4),
                          end: Offset(0, 0),
                        ),
                        duration: Duration(milliseconds: 700),
                        cycles: 1,
                        builder: (anim) => SlideTransition(
                          position: anim,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Container(
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
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[

                                          SizedBox(
                                            width: 8,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[

                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    height: 24,
                                                    width: 20,
                                                    child: Center(
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                      color: Theme.of(context).scaffoldBackgroundColor,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 24,
                                                    width: 250,
                                                    child: Center(
                                                      child: Text(
                                                        AppLocalizations.of("0 SERVIÇOS PENDENTES"),
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
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 0.5,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    Divider(
                                      height: 0.5,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                    Divider(
                                      height: 0.5,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  return Center( child: CircularProgressIndicator());
                }),


          ],
        ),
      ),
    );
  }

  void setLDMapStyle() async {
    if (_controller != null) {
        _controller.setMapStyle(await DefaultAssetBundle.of(context).loadString("jsonFile/lightmapstyle.json"));
    }
  }


  Widget offLineModeDetail() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(
                    ConstanceData.userImage,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    StreamBuilder(
                        stream: FirebaseDatabase.instance.reference().child('motorista/${authFB.currentUser.uid}/perfil').onValue,
                        builder: (context, AsyncSnapshot<Event> snapshot) {
                          if (snapshot.hasData) {

                            DataSnapshot dataValues = snapshot.data.snapshot;
                            Map<dynamic, dynamic> values = dataValues.value;

                            if(dataValues.value != null){

                                Usuario currentUser = Usuario.fromSnapshot(dataValues);


                              return Text(
                                AppLocalizations.of(currentUser.nomecompleto),
                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.headline6.color,
                                ),
                              );

                            } else {
                              return Center( child:Text(
                                AppLocalizations.of('Sem nome'),
                                style: Theme.of(context).textTheme.overline.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              )
                              );
                            }
                          }
                          return Text("...");
                        }),

                  ],
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    StreamBuilder(
                        stream: FirebaseDatabase.instance.reference().child('motorista/${authFB.currentUser.uid}/veiculo').onValue,
                        builder: (context, AsyncSnapshot<Event> snapshot) {
                          if (snapshot.hasData) {

                            DataSnapshot dataValues = snapshot.data.snapshot;
                            Map<dynamic, dynamic> values = dataValues.value;

                            if(dataValues.value != null){

                              VeiculoExtra carUser = VeiculoExtra.fromSnapshot(dataValues);


                              return Text(
                                carUser.transportadora,
                                style: Theme.of(context).textTheme.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.headline6.color,
                                ),
                              );

                            } else {
                              return Center( child:Text(
                                AppLocalizations.of('Sem'),
                                style: Theme.of(context).textTheme.overline.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              )
                              );
                            }
                          }
                          return Text("...");
                        }),

                    Text(
                      AppLocalizations.of('Transportadora'),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.checkCircle,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 20,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        StreamBuilder(
                            stream: FirebaseDatabase.instance.reference().child('logistica').orderByChild('id_motorista').equalTo(authFB.currentUser.uid).onValue,
                            builder: (context, AsyncSnapshot<Event> snapshot) {
                              if (snapshot.hasData) {

                                DataSnapshot dataValues = snapshot.data.snapshot;
                                Map<dynamic, dynamic> values = dataValues.value;
                                if(dataValues.value != null){
                                  lConcluidasInt = 0;
                                  values.forEach((key, values) {

                                    if(values['status'].toString() == "concluido"){

                                        lConcluidasInt++;

                                    }
                                  });
                                  return Text(
                                    lConcluidasInt.toString(),
                                    style: Theme.of(context).textTheme.overline.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                                  );

                                } else {
                                  return Center( child:Text(
                                    AppLocalizations.of('0'),
                                    style: Theme.of(context).textTheme.overline.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  )
                                  );
                                }
                              }
                              return Text("...");
                            }),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('CONCLUÍDAS'),
                              style: Theme.of(context).textTheme.overline.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.tachometerAlt,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 20,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        StreamBuilder(
                            stream:  FirebaseDatabase.instance.reference().child('logistica').orderByChild('id_motorista').equalTo(authFB.currentUser.uid).onValue,
                            builder: (context, AsyncSnapshot<Event> snapshot) {
                              if (snapshot.hasData) {
                                DataSnapshot dataValues = snapshot.data.snapshot;
                                Map<dynamic, dynamic> values = dataValues.value;
                                if(dataValues.value != null){
                                  lPendenteInt = 0;
                                  values.forEach((key, values) {
                                    if(values['status'].toString() == "pendente" ||
                                        values['status'].toString() == "em execução" ||
                                        values['status'].toString() == "entregando"  ){

                                          lPendenteInt++;

                                    }


                                  });
                                  return Text(
                                    lPendenteInt.toString(),
                                    style: Theme.of(context).textTheme.overline.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                                  );

                                } else {
                                  return Center( child:Text(
                                    AppLocalizations.of('0'),
                                    style: Theme.of(context).textTheme.overline.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  )
                                  );
                                }
                              }
                              return Text("...");
                            }),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('PENDENTES'),
                              style: Theme.of(context).textTheme.overline.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.rocket,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 20,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: 4,
                        ),

                        StreamBuilder(
                            stream: FirebaseDatabase.instance.reference().child('logistica').orderByChild('status').equalTo("aguardando").onValue,
                            builder: (context, AsyncSnapshot<Event> snapshot) {
                              if (snapshot.hasData) {
                                DataSnapshot dataValues = snapshot.data.snapshot;
                                Map<dynamic, dynamic> values = dataValues.value;
                                if(dataValues.value != null){
                                  lDisponivelInt = 0;
                                  values.forEach((key, values) {

                                      lDisponivelInt++;

                                  });
                                  return Text(
                                    lDisponivelInt.toString(),
                                    style: Theme.of(context).textTheme.overline.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ConstanceData.secoundryFontColor,
                                    ),
                                  );

                                } else {
                                  return Center( child:Text(
                                    AppLocalizations.of('0'),
                                    style: Theme.of(context).textTheme.overline.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  )
                                  );
                                }
                              }
                              return Text("...");
                            }),

                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('DISPONÍVEIS'),
                              style: Theme.of(context).textTheme.overline.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget myLocation() {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
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
                Icons.my_location,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
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


  Widget offLineMode() {
    return Animator(
      duration: Duration(milliseconds: 400),
      cycles: 1,
      builder: (anim) => SizeTransition(
        sizeFactor: anim,
        axis: Axis.horizontal,
        child: Container(
          height: AppBar().preferredSize.height,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(right: 14, left: 14),
            child: Row(
              children: <Widget>[
                DottedBorder(
                  color: ConstanceData.secoundryFontColor,
                  borderType: BorderType.Circle,
                  strokeWidth: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      FontAwesomeIcons.cloudMoon,
                      color: ConstanceData.secoundryFontColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('Está Offline !'),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ConstanceData.secoundryFontColor,
                          ),
                    ),
                    Text(
                      AppLocalizations.of('Fique online para ver oportunidades para si!'),
                      style: Theme.of(context).textTheme.overline.copyWith(
                            color: ConstanceData.secoundryFontColor,
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
