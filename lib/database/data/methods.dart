import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/database/HelperMethods.dart';
import 'package:my_cab_driver/models/carteira.dart';
import 'package:my_cab_driver/models/logisticaExtra.dart';
import 'package:my_cab_driver/models/servicosAdcionais.dart';
import 'package:my_cab_driver/notification/notification.dart';
import 'package:my_cab_driver/provider/appdata.dart';
import 'package:provider/provider.dart';

class Metodos {

  final FirebaseAuth authFB = FirebaseAuth.instance;
  static String device = 'nao';

  static void carRegisterRequest(
      context,
      String userUID,
      String marca,
      String modelo,
      String ano,
      String placa,
      String cor,
      String classe,
      String local_actuacao,
      String transportadora,
      String NIF) {
    DatabaseReference carRef = FirebaseDatabase.instance
        .reference()
        .child('motorista')
        .child('${userUID}')
        .child("veiculo");

    Map carMap = {
      'criado_em': HelperMethods.formatMyDate(DateTime.now().toString()),
      'marca': marca,
      'modelo': modelo,
      'ano': ano,
      'placa': placa,
      'local_actuacao': local_actuacao,
      'cor': cor,
      'classe': classe,
      'transportadora': transportadora,
      'nif': NIF
    };

    carRef.set(carMap).catchError((ex) {
      print(ex);
      // Navigator.pop(context);

      final snackBar = SnackBar(
        content: Text('Ocorreu um erro! Tente novamente'),
        backgroundColor: Colors.deepOrange,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    });

    Navigator.pop(context);
    final snackBar = SnackBar(
      content: Text('Dados cadastrados com sucesso!'),
      backgroundColor: Colors.deepOrange,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //PUSH NOTIFICATION
  static Future<String> getRiderNotification(
      String logistica, String body, String title) async {
    FirebaseDatabase.instance
        .reference()
        .child('logistica')
        .once()
        .then((DataSnapshot snapshot) => {
      snapshot.value.forEach(
            (key, values) {
          if (values['key'].toString() == '$logistica') {
            print('ESSSSSTTTTTTTOOOOOOOOOOOOUUUUUUUUU.........' +
                values['id_usuario'].toString());
            //Chamada do método que retorna Tokem
            getRiderDevice(
                values['id_usuario'].toString(), body, title);
          }
        },
      )
    });
  }

  //PUSH NOTIFICATION
  static Future<String> getRiderDevice(
      String riderID, String body, String title) async {
    FirebaseDatabase.instance
        .reference()
        .child('cliente')
        .once()
        .then((DataSnapshot snapshot) => {
      snapshot.value.forEach(
            (key, values) {
          values.forEach((key, values) {
            if (values['uid'].toString() == '$riderID') {
              print('FUNCIONOOOOOOOOOOOOOOOOOOOOOOOOO.........' +
                  values['device_token'].toString());
              //Chamamento do método que envia notificação
              PushNotificationService.sendNotification(
                  values['device_token'].toString(),
                  body,
                  title,
                  riderID);
            }
          });
        },
      )
    });
  }


  static void acceptRouteRequest(context, String logisticaKey) {


    DatabaseReference routeRef = FirebaseDatabase.instance
        .reference()
        .child('logistica')
        .child("$logisticaKey");

    routeRef.child('status').set("pendente");
    routeRef.child('id_motorista').set(currentUserInfo.id);
    routeRef.child('nome_motorista').set(currentUserInfo.nomecompleto);
    routeRef.child('token_motorista').set(currentUserInfo.token);
    routeRef.child('company_key').set(currentUserInfo.company_key);

    DatabaseReference chatRef =
    FirebaseDatabase.instance.reference().child('chat');
    Map messageMap = {
      'message': 'Querido/a! Sou ' +
          currentUserInfo.nomecompleto +
          ', com iktoken ' +
          currentUserInfo.token +
          ", irei fazer a entrega da sua encomenda.",
      'type_user': 'driver',
      'date': DateTime.now().toString().substring(0,16)
    };
    chatRef.child(logisticaKey).push().set(messageMap);

    //Chamamento da funcao de envio de notificacao
    getRiderNotification(
        logisticaKey,
        "Seu serviço foi aceito por ${currentUserInfo.nomecompleto}, entre em contacto através do Chat.",
        "Caro cliente!");
  }

  static void goToPickUpRouteRequest(context, String logisticaKey) {
    DatabaseReference routeRef = FirebaseDatabase.instance
        .reference()
        .child('logistica')
        .child("${logisticaKey}");

    routeRef.child('status').set("em execução");
    routeRef.child('id_motorista').set(currentUserInfo.id);
    routeRef.child('nome_motorista').set(currentUserInfo.nomecompleto);
    routeRef.child('token_motorista').set(currentUserInfo.token);
    routeRef.child('company_key').set(currentUserInfo.company_key);

    DatabaseReference chatRef =
    FirebaseDatabase.instance.reference().child('chat');

    Map messageMap = {
      'message': 'Querido/a! ' +
          currentUserInfo.nomecompleto +
          ', com iktoken ' +
          currentUserInfo.token +
          ", já está se dirigindo até ao local de recolha.",
      'type_user': 'driver',
      'date': DateTime.now().toString()
    };
    chatRef.child(logisticaKey).push().set(messageMap);

    //Chamamento da funcao de envio de notificacao
    getRiderNotification(
        logisticaKey,
        'O executivo ${currentUserInfo.nomecompleto} está se deslocando rumo ao local de recolha da sua encomenda',
        "Caro cliente!");

  }

  static void rejeitarRouteRequest(context, String logisticaKey) {
    DatabaseReference routeRef = FirebaseDatabase.instance
        .reference()
        .child('logistica')
        .child("${logisticaKey}");

    routeRef.child('status').set("aguardando");
    routeRef.child('id_motorista').set("aguardando");
    routeRef.child('nome_motorista').set("aguardando");
    routeRef.child('token_motorista').set("aguardando");
    routeRef.child('company_key').set("aguardando");

    DatabaseReference chatRef =
    FirebaseDatabase.instance.reference().child('chat');

    Map messageMap = {
      'message': 'Querido/a! ' +
          currentUserInfo.nomecompleto +
          ', com iktoken ' +
          currentUserInfo.token +
          ", desistiu de gerir a encomenda " +
          "${logisticaKey}",
      'type_user': 'driver',
      'date': DateTime.now().toString()
    };
    chatRef.child(logisticaKey).push().set(messageMap);

    //Chamamento da funcao de envio de notificacao
    getRiderNotification(
        logisticaKey,
        'O executivo ${currentUserInfo.nomecompleto} desistiu da sua encomenda',
        'Caro cliente!');
  }

  static void iniciarViagemRouteRequest(context, String logisticaKey) {
    DatabaseReference routeRef = FirebaseDatabase.instance
        .reference()
        .child('logistica')
        .child("${logisticaKey}");

    routeRef.child('status').set("entregando");
    routeRef.child('id_motorista').set(currentUserInfo.id);
    routeRef.child('nome_motorista').set(currentUserInfo.nomecompleto);
    routeRef.child('token_motorista').set(currentUserInfo.token);
    routeRef.child('inicio').set(DateTime.now().toString().substring(0, 16));

    DatabaseReference chatRef =
    FirebaseDatabase.instance.reference().child('chat');

    Map messageMap = {
      'message': 'Querido/a! ' +
          currentUserInfo.nomecompleto +
          ', com iktoken ' +
          currentUserInfo.token +
          ", confirmou a recolha da encomenda ",
      'type_user': 'driver',
      'date': DateTime.now().toString()
    };
    // chatRef.child(logisticaKey).push().set(messageMap);

    //Chamamento da funcao de envio de notificacao
    getRiderNotification(
        logisticaKey,
        'O executivo ${currentUserInfo.nomecompleto} confirmou a recolha da encomenda e já está no caminho rumo ao local de entrega',
        "Caro cliente!");
   }

  static void completarRouteRequest(context, String logisticaKey) async {
    DatabaseReference routeRef = FirebaseDatabase.instance
        .reference()
        .child('logistica')
        .child("${logisticaKey}");

    DatabaseReference adminRef = FirebaseDatabase.instance
        .reference()
        .child('pagamentos')
        .child("${logisticaKey}");

    routeRef.child('status').set("concluido");
    routeRef.child('id_motorista').set(currentUserInfo.id);
    routeRef.child('nome_motorista').set(currentUserInfo.nomecompleto);
    routeRef.child('token_motorista').set(currentUserInfo.token);
    routeRef.child('fim').set(DateTime.now().toString().substring(0, 16));
    print("OLASSASSASS");

    DatabaseReference logRef =
    FirebaseDatabase.instance.reference().child('logistica/$logisticaKey');
    logRef.once().then((DataSnapshot snapshot1) async {
      if (snapshot1.value != null) {
        logisticaEspecifica = new LogisticaExtra.fromSnapshot(snapshot1);

        print("OLASSASSASS2111 " + logisticaEspecifica.referencia);

        if (logisticaEspecifica != null) {
          print(logisticaEspecifica.servico_adicional);

          //               Entrar nos servicos adicionais

          servicoAdicionalHelper = '0';
          servicoAdicionalHelper = '0';
          custo_total_servicos_adicionais = 0;
          custo_total_provisorio = 0;
          double quantidadeTotalCada = 0.0;

          if (logisticaEspecifica.servico_adicional != null) {
            // servicoAdicionalHelper =  ((logisticaEspecifica.servico_adicional).replaceAll(" ", "")).substring(((logisticaEspecifica.servico_adicional).replaceAll(" ", "")).indexOf("-")+1, ((logisticaEspecifica.servico_adicional).replaceAll(" ", "")).indexOf("€") );

            for (int i = 0;
            i < logisticaEspecifica.servico_adicional.length;
            i++) {
              print("Servi Add---------------- " +
                  logisticaEspecifica.servico_adicional[i]);
              print("Servi Quant---------------- " +
                  (logisticaEspecifica.servico_adicional[i]).substring(0, 1));
              print("Servi Valor---------------- " +
                  ((logisticaEspecifica.servico_adicional[i])
                      .replaceAll(" ", ""))
                      .substring(
                      ((logisticaEspecifica.servico_adicional[i])
                          .replaceAll(" ", ""))
                          .indexOf("-") +
                          1,
                      ((logisticaEspecifica.servico_adicional[i])
                          .replaceAll(" ", ""))
                          .indexOf("€")));

              //Calculos dos servicos adicionais
              quantidadeTotalCada = double.parse(
                  (logisticaEspecifica.servico_adicional[i])
                      .substring(0, 1)) *
                  double.parse(((logisticaEspecifica.servico_adicional[i])
                      .replaceAll(" ", ""))
                      .substring(
                      ((logisticaEspecifica.servico_adicional[i])
                          .replaceAll(" ", ""))
                          .indexOf("-") +
                          1,
                      ((logisticaEspecifica.servico_adicional[i])
                          .replaceAll(" ", ""))
                          .indexOf("€")));
              print("Total cada---------------- " +
                  quantidadeTotalCada.toString());

              custo_total_servicos_adicionais =
                  custo_total_servicos_adicionais + quantidadeTotalCada;
            }
            print("Total cada11111111111---------------- " +
                quantidadeTotalCada.toString());
            print("Total De Servicos Adicionais---------------- " +
                custo_total_servicos_adicionais.toString());
          }

//          End Servicos Adicionais

          print("Custo do Servico Adicional================= :" +
              logisticaEspecifica.servico_adicional.toString() +
              " | " +
              servicoAdicionalHelper);

          //Start Carteira

          DatabaseReference carteiraRef = FirebaseDatabase.instance
              .reference()
              .child('motorista')
              .child(currentUserInfo.id)
              .child("carteira");

          await carteiraRef.once().then((DataSnapshot snapshot3) => {
            ganhoTotal = snapshot3.value['ganho_total'].toString(),
            taxa_da_plataforma_total = snapshot3.value['taxa_total'].toString(),
          });
          print("Carteira - Ganho Total: =========================" + ganhoTotal);
          print("Carteira - Taxa da Plataforma Total: =========================" + taxa_da_plataforma_total);
          //End Carteira

          Future.delayed(const Duration(seconds: 3), () async {
// Calculos

            DateTime roundedDateTime1 =
            DateTime.parse(logisticaEspecifica.inicio)
                .roundDown(delta: Duration(hours: 1));
            DateTime addHour1 = roundedDateTime1.add(new Duration(hours: 1));

            DateTime roundedDateTime2 =
            DateTime.parse(DateTime.now().toString().substring(0, 16))
                .roundDown(delta: Duration(hours: 1));
            DateTime addHour2 = roundedDateTime2.add(new Duration(hours: 1));

            int horasDeTrabalho = addHour1.difference(addHour2).inHours;

            print(
                "horasDeTrabalho=================================================" +
                    horasDeTrabalho.toString());
            print(
                "Hora arrendondada=================================================" +
                    addHour1.toString());
            print(
                "Hora arrendondada 111 =================================================" +
                    addHour2.toString());
            print(
                "Hora arrendondada 2222 ================================================= " +
                    horasDeTrabalho.toString().substring(1) +
                    "|||" +
                    horasDeTrabalho.toString());

            int HorasFinais = 0;
            if (horasDeTrabalho == 0 || horasDeTrabalho == 1) {
              HorasFinais = 1; //Horas normais, comumente usado no Produto individual
            } else {
              if (horasDeTrabalho.toString().substring(0, 1) == '-') {
                HorasFinais =
                    int.parse(horasDeTrabalho.toString().substring(1));
              } else {
                HorasFinais = horasDeTrabalho;
              }
            }

            print(
                "HorasFinais=================================================" +
                    HorasFinais.toString());
            double custo_porcentagem =
                double.parse(logisticaEspecifica.taxaCobranca) / 100;
            print(
                "custo_porcentagem=================================================" +
                    custo_porcentagem.toString());

            double custo_por_hora_servico =
                double.parse(logisticaEspecifica.preco) * HorasFinais;
            print(
                "custo_por_hora_servico=================================================" +
                    custo_por_hora_servico.toString());
            if (HorasFinais != 0) {
              custo_por_hora_servico =
                  double.parse(logisticaEspecifica.preco) * HorasFinais;
            }

            //Verificar tipo de casa na mudança

            if (logisticaEspecifica.tipoDeCasa == "T0") {
              if (HorasFinais <= 3) {
                custo_por_hora_servico =
                    double.parse(logisticaEspecifica.preco) * 3;
              }
            }
            if (logisticaEspecifica.tipoDeCasa == "T1") {
              if (HorasFinais <= 4) {
                custo_por_hora_servico =
                    double.parse(logisticaEspecifica.preco) * 4;
              }
            }
            if (logisticaEspecifica.tipoDeCasa == "T2") {
              if (HorasFinais <= 6) {
                custo_por_hora_servico =
                    double.parse(logisticaEspecifica.preco) * 6;
              }
            }
            if (logisticaEspecifica.tipoDeCasa == "T3") {
              if (HorasFinais <= 8) {
                custo_por_hora_servico =
                    double.parse(logisticaEspecifica.preco) * 8;
              }
            }
            if (logisticaEspecifica.tipoDeCasa == "T4") {
              if (HorasFinais <= 9) {
                custo_por_hora_servico =
                    double.parse(logisticaEspecifica.preco) * 9;
              }
            }
            if (logisticaEspecifica.tipoDeCasa == "T5") {
              if (HorasFinais <= 12) {
                custo_por_hora_servico =
                    double.parse(logisticaEspecifica.preco) * 12;
              }
            }
            if (logisticaEspecifica.tipoDeCasa == "T5+") {
              if (HorasFinais <= 16) {
                custo_por_hora_servico =
                    double.parse(logisticaEspecifica.preco) * 16;
              }
            }
            //Elevador no minimo opera em 3 horas
            if (logisticaEspecifica.carro == "Elevador Externo") {
              if (HorasFinais <= 2) {
                custo_por_hora_servico =
                    double.parse(logisticaEspecifica.preco) * 2;
              }
            }

            //Verificar se é de segunda a sabado das 20h as 08h - ou feriado
            // if (ehSegunda_Sabado(
            //     DateTime(today.year, today.month, today.day))) {
            //   if (horasDeTrabalhoComAumento.contains(today.hour) ||
            //       listaDeFeriados.contains(today.toString().substring(0, 10))) {
            //     custo_por_hora_servico =
            //         custo_por_hora_servico + (custo_por_hora_servico * 0.5);
            //   } else {
                custo_por_hora_servico = custo_por_hora_servico;
              // }
            // } else {
            //   // eh domingo
            //   custo_por_hora_servico =
            //       custo_por_hora_servico + (custo_por_hora_servico * 0.5);
            // }
            //End verificar de segunda a saba das 20h as 08h - ou feriado

            print(
                "custo_por_hora_servico1=================================================" +
                    custo_por_hora_servico.toString());

            double custo_da_distancia =
            double.parse(logisticaEspecifica.custo_da_distancia);
            print(
                "custo_da_distancia=================================================" +
                    custo_da_distancia.toString());

            double custo_envio = double.parse(logisticaEspecifica.taxaEnvio);
            print(
                "custo_envio=================================================" +
                    custo_envio.toString());
            print(
                "custo_servico_adicional=================================================" +
                    custo_total_servicos_adicionais.toString());

            double total_previsao = custo_por_hora_servico +
                custo_total_servicos_adicionais +
                custo_da_distancia; // O motorista recebe esse

            custo_total_provisorio = roundDouble(
                total_previsao +
                    (custo_porcentagem * total_previsao) +
                    custo_envio,
                2);

            double custo_apenas_do_motorista = custo_por_hora_servico +
                custo_total_servicos_adicionais +
                custo_da_distancia; // Mesma coisa do motorista encima

            double custo_da_empresa = roundDouble(
                (custo_porcentagem * total_previsao) + custo_envio,
                2); //para a empresa

            //Volor actualizado na carteira
            double custo_global_novo =
                double.parse(ganhoTotal) + custo_total_provisorio;

            double taxa_da_plataforma = double.parse(taxa_da_plataforma_total) + custo_da_empresa;

            print(
                "TOTALLLLLLLLLLLLLLLLLLLLLLL+++++++++++++++++++++++++++++++++++++" +
                    custo_total_provisorio.toString());

            // Salvando
            routeRef.child('custo').set(custo_apenas_do_motorista.toString());
            routeRef
                .child('pagamento')
                .set(custo_total_provisorio.toString() + "€");

            //Carteira do Motorista
            carteiraRef.child("ganho_total").set(custo_global_novo.toString());
            carteiraRef.child("taxa_total").set(taxa_da_plataforma.toString());

            //  Salvando o Pagamento da Empresa IK Tech
            adminRef.child("total").set(custo_total_provisorio.toString());
            adminRef.child("servico").set(custo_apenas_do_motorista.toString());
            adminRef.child("taxa").set(custo_da_empresa.toString());
            adminRef.child("estado").set("aguardando");
            adminRef.child("created_at").set(DateTime.now().toString());
          });
        }


        //  Setar CONLUIDO NO RASTREIO
        DatabaseReference trackRef = FirebaseDatabase.instance.reference().child('rastreio').child('$logisticaKey');
        trackRef.child("estado").set("concluido");

        //Chamamento da funcao de envio de notificacao
        getRiderNotification(
            logisticaKey,
            'O executivo ${currentUserInfo.nomecompleto} confirmou o término do trabalho',
            'Caro cliente!');

  }
    });

    DatabaseReference chatRef =
    FirebaseDatabase.instance.reference().child('chat');

    Map messageMap = {
      'message': 'Querido/a! O ' +
          currentUserInfo.nomecompleto +
          ', com iktoken ' +
          currentUserInfo.token +
          ", confirmou a entrega da encomenda ",
      'type_user': 'driver',
      'date': DateTime.now().toString()
    };
    chatRef.child(logisticaKey).push().set(messageMap);
  }

  static double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  //Verificar os dias de segunda a sabado
  static bool ehSegunda_Sabado(DateTime data) {
    var diaDaSemana = data.weekday;

    return diaDaSemana == 1 ||
        diaDaSemana == 2 ||
        diaDaSemana == 3 ||
        diaDaSemana == 4 ||
        diaDaSemana == 5 ||
        diaDaSemana == 6;
  }

  static DateTime today = DateTime.now();
}

extension DateTimeExtension on DateTime {
  DateTime roundDown({Duration delta = const Duration(hours: 1)}) {
    return DateTime.fromMillisecondsSinceEpoch(this.millisecondsSinceEpoch -
        this.millisecondsSinceEpoch % delta.inMilliseconds);
  }
}

external DateTime add(Duration duration);