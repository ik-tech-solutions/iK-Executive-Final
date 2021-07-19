import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:my_cab_driver/constance/routes.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/database/HelperMethods.dart';
import 'package:my_cab_driver/models/usuario.dart';
import 'package:my_cab_driver/models/carteira.dart';
import 'package:crypto/crypto.dart';
import 'package:my_cab_driver/notification/notification.dart';
import 'dart:convert';
import 'dart:io' show Platform, exit;

import 'package:my_cab_driver/vehicalManagement/addVehicalScreen.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;



class Autenticacao{

  //Registro
  static  registrarUsuario(String nome, String email, String telefone, String password, BuildContext context) async {
    User user_;
    String errorMessage;
    PushNotificationService notification = PushNotificationService();

    String generateMd5(String texto) {
      return "ik"+(md5.convert(utf8.encode(texto)).toString()).substring(1,8);
    }

    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      user_ = result.user; //Local
      user = result.user; //global

    //  Salvar no Database
      if(user_ !=null){
        DatabaseReference newUserRef = FirebaseDatabase.instance.reference().child('motorista/${user_.uid}');
        Map userMap = {
          'nome': nome,
          'email':email,
          'phone': telefone,
          'senha': password,
          'status': 'aguardando',
          'token': generateMd5(telefone),
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
              'mensagem' : 'Seja muito bem vindo ' + user_.email,
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



                print("Registrado com sucesso. " + nome);

                resultadoDoRegistro = true;

                FlutterRestart.restartApp();
              }

            });

          });

        });
      }



    } catch (error) {
      switch (error.code) {
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          errorMessage = "Contas anônimas não estão habilitadas";
          break;
        case "ERROR_WEAK_PASSWORD":
        case "weak-password":
          errorMessage = "Sua senha é muito fraca";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          errorMessage = "Seu e-mail é inválido";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          errorMessage = "O e-mail já está em uso em outra conta";
          break;
        case "ERROR_INVALID_CREDENTIAL":
        case "invalid-credential":
          errorMessage = "Seu e-mail é inválido";
          break;

        default:
          errorMessage = "Preencha todos os campos";
      }
    }
    if (errorMessage != null) {
      print("Erro: ================" + errorMessage);

      Navigator.pop(context);
      final snackBar = SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.deepOrange,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // return print("Erro: ================" + errorMessage);
    }


    // return print("SHOW: ================" + errorMessage);
  }

  static void login(String email, String password, BuildContext context) async{
    User user_;
    String errorMessage;
    PushNotificationService notification = PushNotificationService();
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      user_ = result.user; //local
      user = result.user; //global

      if(user_ !=null){
        FirebaseDatabase.instance
            .reference()
            .child("tipo_veiculo")
            .once().then((DataSnapshot snapshot) => {

          snapshot.value.forEach((value) {

          }),
        }).then((value) async => {

          HelperMethods.getCurrentUserInfo(),
          HelperMethods.getVeiculoDados(),
          HelperMethods.getCarList(),
          HelperMethods.getTaxasDaEmpresa(),
          HelperMethods.getServicosAdicionais(),
          HelperMethods.getTiposDeCasas(),
          HelperMethods.getTermosContactos(),
        HelperMethods.getFeriadosList(),
 
          notification.initialize(context),
          notification.getToken(),
          
          print("Entrrou111111111100000000000000000-----==================="),
         await FirebaseDatabase.instance.reference().child('motorista/${user_.uid}/perfil').once().then((DataSnapshot snapshot) => {
                    if(snapshot.value!=null){

                    currentUserInfo = Usuario.fromSnapshot(snapshot),
                        print('my status ${currentUserInfo.status}'),
                    nomeUsuario = currentUserInfo.nomecompleto,
                    print('Status of: $nomeUsuario'),

                    if(currentUserInfo.status == "aguardando"){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("A sua conta ainda está em análise. Brevemente entraremos em contacto consigo por meio do seu e-mail."),
                        duration: const Duration(seconds: 19),
                      )),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewVehical(),
                        ),
                      ),
                    } else {
                      //  Liberado
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.HOME, (Route<dynamic> route) => false),
                    }

                  }
          }),

        });

      }


    } catch (error) {
      switch (error.code) {

        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          errorMessage = "Seu endereço de e-mail está incorreto.";
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          errorMessage = "Sua senha está errada.";
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          errorMessage = "O usuário com este e-mail não existe.";
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          errorMessage = "O usuário com este e-mail foi desativado.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "too-many-requests":
          errorMessage = "Muitos pedidos. Tente mais tarde.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          errorMessage = "O login com e-mail e senha não está ativado.";
          break;

        default:
          errorMessage = "Preencha todos os campos";
      }
    }
    if (errorMessage != null) {
      print("Erro: ================" + errorMessage);

      Navigator.pop(context);
      final snackBar = SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.deepOrange,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // return print("Erro: ================" + errorMessage);
    }


    }



    static logOut(context) async {
    
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut().then(
      (_){
        user = null;
        Navigator.pushReplacementNamed(context, Routes.INTRODUCTION);
      }
    );
    
    
  }
}




class NavigationService{
  GlobalKey<NavigatorState> navigationKey;

  static NavigationService instance = NavigationService();

  NavigationService(){
    navigationKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String _rn){
    return navigationKey.currentState.pushReplacementNamed(_rn);
  }
  Future<dynamic> navigateTopushAndRemoveUntil(MaterialPageRoute _rn){
    return navigationKey.currentState.pushAndRemoveUntil(_rn, (Route<dynamic> route) => false);
  }
  Future<dynamic> navigateTo(String _rn){
    return navigationKey.currentState.pushNamed(_rn);
  }
  Future<dynamic> navigateToRoute(MaterialPageRoute _rn){
    return navigationKey.currentState.push(_rn);
  }


  goback(){
    return navigationKey.currentState.pop();
  }
}