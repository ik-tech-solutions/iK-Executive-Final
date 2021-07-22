import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/database/HelperMethods.dart';
import 'package:my_cab_driver/models/carteira.dart';
import 'package:my_cab_driver/models/usuario.dart';
import 'package:my_cab_driver/notification/notification.dart';

abstract class UserServices {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  /// return true if phone number already exists
  static Future<bool> phoneNumberExists(String phoneNumber,
      {Function(Object) onError}) async {
    var isValidUser = false;
    print("Numero ======= ===== 111" + phoneNumber);

    // DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference().child('motorista').orderByChild('phone').equalTo(phoneNumber).once();
    // if(dataSnapshot.value!=null){
    //   print("Já registrado ================ {{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}} ");
    //   isValidUser = true;
    // } else{
    //   isValidUser = false;
    //   print("Ainda não registrado ================ {{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}} ");
    // }

    await  FirebaseDatabase.instance.reference().child('motorista').once().then((DataSnapshot snapshot) => {

      print("Data: ================== 1" + snapshot.toString()),
      print("Data: ================== 2" + snapshot.value.toString()),


      snapshot.value.forEach((key, values) {
        values.forEach((key, values) {


          if(values['phone'].toString() == phoneNumber){
            print("Data:4 UID ================== " + values['uid'].toString());
            print("Data:4 NOME ================== " + values['nome'].toString());
            print("Data:4 TOKEN ================== " + values['token'].toString());

            isValidUser = true;
          }

        });
      }),
    });

    // await _firestore
    //     .collection('users')
    //     .where('phone_number', isEqualTo: phoneNumber)
    //     .get()
    //     .then((result) {
    //   if (result.docs.length > 0) {
    //     print("Numero ======= ===== 111222" + phoneNumber);
    //     isValidUser = true;
    //   }
    // }).catchError(
    //
    //   onError ??
    //       (_) {
    //         print("Numero ======= ===== Error" + phoneNumber);
    //         log("checking phone number : failed");
    //       },
    // );
    return isValidUser;
  }

 static String generateMd5(String texto) {
    return "ik"+(md5.convert(utf8.encode(texto)).toString()).substring(1,8);
  }


  static void addUser( BuildContext context,
    Registrant data, {
    Function() onSuccess,
    Function(Object) onError,
  }) async {

    PushNotificationService notification = PushNotificationService();
    print("Telefone informado =======  Registo " + data.phoneNumber);
    User user_ = _auth.currentUser;

    if(_auth.currentUser !=null){
      DatabaseReference newUserRef = FirebaseDatabase.instance.reference().child('motorista/${user_.uid}');
      Map userMap = {
        'nome': data.name,
        'email': data.email,
        'phone': data.phoneNumber,
        'company_key': 'individual',
        'status': 'aguardando',
        'token': generateMd5(data.phoneNumber),
        'uid': user_.uid,
      };
      newUserRef.child("perfil").set(userMap).then((_) {

        /**
         * Salvar a carteira
         */

        Map carteiraMap = {
          'ganho_total': "0",
          'taxa_total': "0",
          'desconto_total': "0",
        };


        newUserRef.child("carteira").set(carteiraMap).then((_) {

          /**
           * Salvar a notificacao
           */
          notificacaoRef = FirebaseDatabase.instance.reference().child('motorista').child(user_.uid).child("notificacoes");

          Map notificacaoPadrao = {
            'usuario'  : 'Sistema',
            'mensagem' : 'Seja muito bem vindo ' + data.email,
            'data'     : DateTime.now().toString().substring(0,16)
          };

          // /**
          //  * REgitro de Online/Offline
          //  */
          // newUserRef.child("estado").set(isOffline);

          notificacaoRef.push().set(notificacaoPadrao).then((_) {

            if(user_ != null) {
              auth = FirebaseAuth.instance;
              userid = user_.uid;

              DatabaseReference userPerfilRef = FirebaseDatabase.instance.reference().child('motorista/$userid/perfil');
              userPerfilRef.once().then((DataSnapshot snapshot){
                if(snapshot.value!=null){
                  currentUserInfo = new Usuario.fromSnapshot(snapshot);
                }
              });

              DatabaseReference userCarteiraRef = FirebaseDatabase.instance.reference().child('motorista/$userid/carteira');
              userCarteiraRef.once().then((DataSnapshot snapshot){
                if(snapshot.value!=null){
                  userCarteira = Carteira.fromSnapshot(snapshot);
                }
                print('Print2: $nomeUsuario');
              });

              HelperMethods.getCurrentUserInfo();
              HelperMethods.getVeiculoDados();
              HelperMethods.getCarList();
              HelperMethods.getTaxasDaEmpresa();
              HelperMethods.getServicosAdicionais();
              HelperMethods.getTiposDeCasas();
              HelperMethods.getTermosContactos();
              HelperMethods.getFeriadosList();

              notification.initialize(context);
              notification.getToken();



              print("Registrado com sucesso. " + data.name);

              resultadoDoRegistro = true;

              FlutterRestart.restartApp();
            }

          });

        });

      });
    }







    await _firestore.collection('users').doc(_auth.currentUser.uid).set(
        {'name': data.name, 'phone_number': data.phoneNumber},
        SetOptions(merge: true)).then((value) {
      if (onSuccess != null) onSuccess();
    }).catchError(
      onError ??
          (_) {
            log("add user : failed");
          },
    );
  }

  static Future<Registrant> getUserLogin() async {
    Registrant registrant;
    if (_auth.currentUser != null) {
      var phoneNumber = _auth.currentUser.phoneNumber;
      await _firestore
          .collection('users')
          .where('phone_number', isEqualTo: phoneNumber)
          .get()
          .then((result) {
        if (result.docs.length > 0) {
          registrant = Registrant(
            name: result.docs[0].data()['name'],
            phoneNumber: phoneNumber,
          );
        }
      }).catchError((_) {});
    }
    return registrant;
  }
}

class Registrant {
  String name;
  String phoneNumber;
  String email;

  Registrant({ this.name,  this.phoneNumber, this.email});
}
