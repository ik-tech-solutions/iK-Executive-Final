import 'dart:convert';
import 'dart:math';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/database/request.dart';
import 'package:my_cab_driver/models/address.dart';
import 'package:my_cab_driver/models/diretionsDetails.dart';
import 'package:my_cab_driver/models/veiculoExtra.dart';
import 'package:my_cab_driver/models/usuario.dart';
import 'package:my_cab_driver/models/carteira.dart';
import 'package:my_cab_driver/provider/appdata.dart';
import 'package:provider/provider.dart';
import 'package:my_cab_driver/models/logisticaExtra.dart';
import 'package:my_cab_driver/models/taxas.dart';

import 'package:http/http.dart' as http;

class HelperMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static Usuario getUsuario(String key){

      DatabaseReference userPerfilRef = FirebaseDatabase.instance.reference().child('motorista/$key/perfil');
      userPerfilRef.once().then((DataSnapshot snapshot){
        if(snapshot.value!=null){
          currentUserInfo = Usuario.fromSnapshot(snapshot);
          return currentUserInfo;
        }
      });
      return currentUserInfo;
  }

  static Usuario getClienteDaLogistica(String key){

    DatabaseReference userPerfilRef = FirebaseDatabase.instance.reference().child('cliente/$key/perfil');
    userPerfilRef.once().then((DataSnapshot snapshot){
      if(snapshot.value!=null){
        clienteDaLogisitca = Usuario.fromSnapshot(snapshot);
        return clienteDaLogisitca;
      }
    });
    return clienteDaLogisitca;
  }

  static LogisticaExtra getLogisticaEspecifica(String logisticaKey){

    userid = user.uid;

    DatabaseReference logRef = FirebaseDatabase.instance.reference().child('logistica/$logisticaKey');
    logRef.once().then((DataSnapshot snapshot){
      if(snapshot.value!=null){

        logisticaEspecifica = new LogisticaExtra.fromSnapshot(snapshot);
        return logisticaEspecifica;
        print('Logistica Especifica:---------------------------------------- ' + logisticaEspecifica.destinatario.toString() + "..." + snapshot.value.toString());
      }

    });

    return logisticaEspecifica;
  }

  static VeiculoExtra getVeiculo(String key){
      DatabaseReference carPerfilRef = FirebaseDatabase.instance.reference().child('motorista/$key/veiculo');
      carPerfilRef.once().then((DataSnapshot snapshot){
        if(snapshot.value!=null){
          currentCarInfo = VeiculoExtra.fromSnapshot(snapshot);
          return currentCarInfo;
        }
      });
  }

  static  getVersaoDoApp() async{
    final response = await FirebaseDatabase.instance
        .reference()
        .child("versao")
        .once();

    print("Versao No helpers1 Executive ==================== " + response.value['ikexecutive'].toString());
    versaoDoApp = response.value['ikexecutive'].toString();

  }



  static getFeriadosList() async{

    final response = await FirebaseDatabase.instance
        .reference()
        .child("feriados")
        .once();

    listaDeFeriados.clear();

    response.value.forEach((value) {
      if(value != null){
        print("Feriados ==================== " + value.toString());
        listaDeFeriados.add(value);
      }

    });
    print("Feriados no Helpers" + listaDeFeriados.toString());

    DateTime today = DateTime.now();

    print("Hora agora =================== " + today.hour.toString());
    print("Data agora =================== " + today.toString().substring(0,10));

    print("Horas com Aumento =================== " + horasDeTrabalhoComAumento.toString());

    print("Horas com Aumento Especifico Hora Actual =================== " + horasDeTrabalhoComAumento.contains(today.hour).toString());
    print("Horas com Aumento Especifico 22 =================== " + horasDeTrabalhoComAumento.contains(22).toString());
    print("Horas com Aumento Especifico 09 =================== " + horasDeTrabalhoComAumento.contains(09).toString());

    // VER A EXISTENCIA DE FERIADOS
    print("Feriado com Aumento Data de Hoje =================== " + listaDeFeriados.contains(today.toString().substring(0,10)).toString());
    print("Feriado com Aumento Especifico 2022-01-01 =================== " + listaDeFeriados.contains("2022-01-01").toString());
    print("Feriado com Aumento Especifico 2021-01-01 =================== " + listaDeFeriados.contains("2021-01-01").toString());



  }




  static void getCurrentUserInfo(){
    //User currentFirebaseUser = await _auth.currentUser

    if(user != null){
      auth = FirebaseAuth.instance;
      user = auth.currentUser;


      userid = user.uid;

      DatabaseReference userPerfilRef = FirebaseDatabase.instance.reference().child('motorista/$userid/perfil');
      userPerfilRef.once().then((DataSnapshot snapshot){
        if(snapshot.value!=null){

          currentUserInfo = Usuario.fromSnapshot(snapshot);
          print('my name is ${currentUserInfo.nomecompleto}');
          nomeUsuario = currentUserInfo.nomecompleto;
          numeroCelularUsuario = currentUserInfo.telefone;
          emailUsuario = currentUserInfo.email;
          imagemPerfil = currentUserInfo.imagemPerfil;
          print('Print1: $nomeUsuario');

        }
        print('Print2: $nomeUsuario');
      });

      DatabaseReference userCarteiraRef = FirebaseDatabase.instance.reference().child('motorista/$userid/carteira');
      userCarteiraRef.once().then((DataSnapshot snapshot){
        if(snapshot.value!=null){
          userCarteira = Carteira.fromSnapshot(snapshot);
        }
        print('Print2: $nomeUsuario');
      });


    }

  }

  static void getVeiculoDados(){

    if(user != null){
      auth = FirebaseAuth.instance;
      user = auth.currentUser;


      userid = user.uid;

      DatabaseReference carPerfilRef = FirebaseDatabase.instance.reference().child('motorista/$userid/veiculo');
      carPerfilRef.once().then((DataSnapshot snapshot){
        if(snapshot.value!=null){

          currentCarInfo = VeiculoExtra.fromSnapshot(snapshot);

        }

      });



    }

  }

  static getCarList() async{

    final response = await FirebaseDatabase.instance
        .reference()
        .child("tipo_veiculo")
        .once();

    listaDeAlturaVeiculo.clear();
    listaDeVeiculo.clear();
    listaDeCustoVeiculo.clear();
    listaDeTaxaVeiculo.clear();
    listaDeComprimentoVeiculo.clear();

    response.value.forEach((value) {
      if(value != null){


        print(value["altura"].toString());
        listaDeAlturaVeiculo.add(value["altura"].toString());
        listaDeVeiculo.add(value["nome"].toString());
        listaDeCustoVeiculo.add(value["custo"].toString());
        listaDeTaxaVeiculo.add(value["taxa"].toString());
        listaDeComprimentoVeiculo.add(value["comprimento"].toString());
      }

    });
    print("ALturas no Helpers"+listaDeAlturaVeiculo.toString());

  }


  // static getEstadosDaLogisticas() async{
  //
  //   final response = await FirebaseDatabase.instance.reference().child('logistica').orderByChild('id_motorista').equalTo("${user.uid}").once();
  //
  //
  //   response.value.forEach((value) {
  //     if(value != null){
  //
  //       if(value["status"].toString() == "concluido"){
  //
  //         logisticasConcluidas++;
  //       }
  //
  //       if(value["status"].toString() == "pendente"){
  //         logisticasPendentes++;
  //       }
  //
  //     }
  //
  //   });
  //   print("Logisticas dfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"+logisticasConcluidas.toString());
  //
  // }
  //
  // static getTodasLogisticas() async {
  //   final response = await FirebaseDatabase.instance
  //       .reference()
  //       .child('logistica').orderByChild('status').equalTo("aguardando")
  //       .onValue;
  //
  //   AsyncSnapshot<Event> snapshot;
  //   DataSnapshot dataValues = snapshot.data.snapshot;
  //   if (dataValues.value != null) {
  //     dataValues.value.forEach((key, values) {
  //
  //       logisticasDisponiveis++;
  //
  //     });
  //   }
  // }

  static getTaxasDaEmpresa() async{

    final response = await FirebaseDatabase.instance
        .reference()
        .child("taxas_gerais")
        .once();

    response.value.forEach((value) {
      if(value != null){

        print(value["envio"].toString());

        taxaDaEmpresa = new Taxa();
        taxaDaEmpresa.envio = value["envio"].toString();
        taxaDaEmpresa.cobranca = value["cobranca"].toString();
      }

    });
    print(listaDeAlturaVeiculo.toString());

  }
  static getServicosAdicionais() async{

    final response = await FirebaseDatabase.instance
        .reference()
        .child("servicos_adicionais")
        .once();

    listaDeServicosAdicionaisNome.clear();
    listaDeServicosAdicionaisCusto.clear();

    response.value.forEach((value) {
      if(value != null){
        print(value["nome"].toString());

        listaDeServicosAdicionaisNome.add(value["nome"].toString());
        listaDeServicosAdicionaisCusto.add(value["custo"].toString());

      }

    });

    print(listaDeServicosAdicionaisNome.toString());
  }

  static getTiposDeCasas() async{

    final response = await FirebaseDatabase.instance
        .reference()
        .child("tipos_de_casas")
        .once();

    listaDeTiposDeCasasNome.clear();
    listaDeTiposDeCasasCusto.clear();

    response.value.forEach((value) {
      if(value != null){
        print(value["nome"].toString());

        listaDeTiposDeCasasNome.add(value["nome"].toString());
        listaDeTiposDeCasasCusto.add(value["custo"].toString());

      }

    });

    print(listaDeServicosAdicionaisNome.toString());
  }



  static getTermosContactos() async{

    final response = await FirebaseDatabase.instance
        .reference()
        .child("termos_e_politicas")
        .once();

    response.value.forEach((value) {
      if(value != null){
        print(value["termos"].toString());

        dadosDeContactoPadraoGlobal = value["termos"].toString();
        dadosDeTermosPadraoGlobal = value["politicas"].toString();
        dadosDePoliticasPadraoGlobal = value["contacto"].toString();

      }

    });
  }


  static getNotificacoes() async{

    final response = await FirebaseDatabase.instance
        .reference()
        .child('cliente/${user.uid}/notificacoes')
        .once();
    // if (snapshot.hasData) {
    //   lists.clear();
    //   Map<dynamic, dynamic> values = snapshot.data.value;
    //   values.forEach((key, values) {
    //     lists.add(values);
    //   });





    //
    // response.value.forEach((value) {
    //   if(value != null){
    //     print(value["usuario"].toString());
    //
    //     listaDeNotificacoesUser.add(value["usuario"].toString());
    //     listaDeNotificacoesMensagem.add(value["mensagem"].toString());
    //     listaDeNotificacoesData.add(value["data"].toString());
    //
    //   }
    //
    // });
    //
    // print(listaDeNotificacoesMensagem.toString());
  }

  static Future<String> findCordinatesAddress(Position position, context) async{
    String placeAddress = '';



    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKeyANDROID";
    var response = await RequestHelper.getRequest(url);

    if(response != 'failed'){
      placeAddress = response['results'][0]['formatted_address'];

      Address pickupAddress = new Address();
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickAddress(pickupAddress);
    }
    return placeAddress;

  }

  static Future<DirectionDetails>getDirectionDetails(LatLng startPosition, LatLng endPosition)async{

    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKeyANDROID';

    print("Teste 3:  Get Direction in Helper Method" );

    var response = await RequestHelper.getRequest(url);

    if(response == 'failed'){
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue= response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodedPoints = response['routes'][0]['overview_polyline']['points'];

  print("Teste 4: distancia" + directionDetails.distanceText);
    print("Teste 4: duracao" + directionDetails.durationText);
    return directionDetails;
  }

  static int estimateFares(DirectionDetails details){
    //por km ==50MT,
    //por minuto == 30MT,
    //tarifa basica==70

    //double base = 25;
    double distanceFare = (details.distanceValue/1000) * 35;
    double timeFare = (details.durationValue/60) * 35;


    //double totalFare = distanceFare;//baseFare + distanceFare; //+ timeFare;
    double totalFare = distanceFare;

    if(totalFare <=35){
      totalFare = 35;
      //print(totalFare);
      return totalFare.truncate();
    }else{

        totalFare = distanceFare;
      //print(totalFare);
      //totalFare = distanceFare;
      return totalFare.truncate();

    }


  }




   static String formatMyDate(String datestring){

    DateTime thisDate = DateTime.parse(datestring);
    String formattedDate = '${DateFormat.MMMd().format(thisDate)}, ${DateFormat.y().format(thisDate)} - ${DateFormat.jm().format(thisDate)}';

    return formattedDate;
  }


  static User getUserInfo(){
    return user;
  }




}