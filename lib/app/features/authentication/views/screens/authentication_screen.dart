library authentication_view;

import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_cab_driver/app/constants/assets_constant.dart';
import 'package:my_cab_driver/app/features/authentication/controllers/authentication_controller.dart';
import 'package:my_cab_driver/app/utils/services/firebase_services.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/constance/routes.dart';
import 'package:my_cab_driver/database/HelperMethods.dart';
import 'package:my_cab_driver/models/usuario.dart';
import 'package:my_cab_driver/notification/notification.dart';
import 'package:my_cab_driver/vehicalManagement/addVehicalScreen.dart';

import 'package:sms_autofill/sms_autofill.dart';

part '../components/header_text.dart';
part '../components/illustration_image.dart';
part '../components/pin_auto_field.dart';
part '../components/resend_button.dart';
part '../components/verification_button.dart';

class AuthenticationScreen extends StatelessWidget {
   // AuthenticationScreen({Key key, @required this.telefoneEmVerificacao}) : super(key: key);
  Registrant registrant;
  String phoneNumber;
  String telefoneEmVerificacao;

  AuthenticationScreen({Key key, this.telefoneEmVerificacao,  this.registrant}) : super(key: key);


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final otp = TextEditingController();

   final _auth = FirebaseAuth.instance;



  String verificationId;
  final isLoading = true.obs;

  final _durationTimeOut = Duration(seconds: 60);
  final isCanResendCode = false.obs;
  final durationCountdown = 0.obs;

   // @override
   void initState(BuildContext context) {
     // // this.initState();
     // registrant = _getUser();
     phoneNumber = telefoneEmVerificacao;
     verifyPhoneNumber(context);

     // print("Numero Na tela de Verificacao 123 __________________________ " + this.telefoneEmVerificacao +" | " + telefoneEmVerificacao );

   }

  @override
  Widget build(BuildContext context) {
    print("Numero Na tela de Verificacao __________________________ " + this.telefoneEmVerificacao.toString() +" | " + registrant.toString() +" | " + registrant.name + " | " + registrant.email +" | " + registrant.phoneNumber );
    initState(context);
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            width: Get.width,
            height: Get.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Container(alignment: Alignment.topLeft, child: BackButton()),
                Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text("Verificação de OTP", style: Theme.of(context).textTheme.headline5),
                      SizedBox(height: 5),
                      RichText(
                        text:
                        TextSpan(style: Theme.of(context).textTheme.bodyText2, children: [
                          TextSpan(text: "Por favor insira o código enviado para "),
                          TextSpan(
                              text: phoneNumber ??
                                  registrant?.phoneNumber ??
                                  "-",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontSize: 16))
                        ]),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Spacer(flex: 4),
                _IllustrationImage(),
                Spacer(flex: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: formKey,
                    child: Container(
                      child: Theme(
                        data: ThemeData(
                          inputDecorationTheme:
                          InputDecorationTheme(fillColor: Theme.of(context).canvasColor),
                        ),
                        child: PinFieldAutoFill(
                          controller: otp,
                          codeLength: 6,
                          decoration: BoxLooseDecoration(
                            bgColorBuilder: FixedColorBuilder(Colors.grey[300]),
                            strokeColorBuilder: FixedColorBuilder(Colors.grey[300]),
                            gapSpace: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                        () => ElevatedButton(
                        onPressed: isLoading.value
                            ? null
                            : () => verifySmsCode(context),
                        child: isLoading.value
                            ? SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(),
                        )
                            : Text("Verificar")),
                  ),
                ),
                Spacer(flex: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Não recebeu o código ? "),
                    Obx(
                          () => TextButton(
                        onPressed: (isCanResendCode.value)
                            ? () => verifyPhoneNumber(context)
                            : null,
                        child: Text((durationCountdown.value) > 0
                            ? "Reenviar (${durationCountdown.value})"
                            : "Reenviar"),
                      ),
                    )
                  ],
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
        ]))
      ],
    ));
  }

   void verifyPhoneNumber(BuildContext context) async {
     isLoading.value = true;

     isCanResendCode.value = false;
     String _phoneNumber = phoneNumber ?? registrant?.phoneNumber;

     if (_phoneNumber != null) {
       await _auth.verifyPhoneNumber(
         phoneNumber: _phoneNumber,
         verificationCompleted: (phoneAuthCredential) async {
           log("verify phone number : verification completed");
           await _auth.signInWithCredential(phoneAuthCredential);

           if (registrant != null) {
             _saveRegistrantAndGoToHome(context);
             print("Registrado com sucesso! ============= OTP");
           } else {
             _goToHome(_auth.currentUser, context);
           }
         },
         verificationFailed: (FirebaseAuthException e) {
           isLoading.value = false;
           isCanResendCode.value = true;
           Get.snackbar(
             "Verification Failed",
             e.code,
             backgroundColor: Colors.white,
             snackPosition: SnackPosition.BOTTOM,
           );
         },
         codeSent: (verificationId, forceResendingToken) async {
           log("verify phone number : code success send");
           this.verificationId = verificationId;
           isLoading.value = false;
           _validateCountdownResendCode();
         },
         codeAutoRetrievalTimeout: (verificationId) {},
         timeout: _durationTimeOut,
       );
     }
   }

   void verifySmsCode(BuildContext context) async {
     if (formKey.currentState.validate() && verificationId != null) {
       isLoading.value = true;

       try {
         await _auth.signInWithCredential(PhoneAuthProvider.credential(
             verificationId: verificationId, smsCode: otp.text));
       } catch (e) {
         print("invalid code ================== ");

         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           content: Text('Código inválido'),
           backgroundColor: Colors.red,
         ));

       } finally {
         isLoading.value = false;

         if (_auth.currentUser != null) {
           /// authentication success
           if (registrant != null) {
             _saveRegistrantAndGoToHome(context);
             print("OTP NICE UM PARA REGISTO");
           } else {
             print("OTP NICE LOGIN");
             _goToHome(_auth.currentUser, context);
           }
         } else {
           print("OTP Errado");

           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
             content: Text('Código inválido'),
             backgroundColor: Colors.red,
           ));


           /// authentication faileed
           Get.snackbar(
             "Invalid Code",
             "Please enter the correct code",
             backgroundColor: Colors.white,
             snackPosition: SnackPosition.BOTTOM,
           );
         }
       }
     }
   }

   void _saveRegistrantAndGoToHome(BuildContext context) {
     UserServices.addUser(
       context,
       registrant,
       onSuccess: () => _goToHome(_auth.currentUser, context),
       onError: (e) => isLoading.value = false,
     );
   }

   void _goToHome(User user_, BuildContext context) {
     isLoading.value = false;

     PushNotificationService notification = PushNotificationService();

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
   }

   void _validateCountdownResendCode() {
     isCanResendCode.value = false;
     var maxDurationInSecond = _durationTimeOut.inSeconds;
     var currentDurationSecond = 0;
     durationCountdown.value = maxDurationInSecond;

     Timer.periodic(Duration(seconds: 1), (timer) {
       currentDurationSecond++;
       if (maxDurationInSecond - currentDurationSecond >= 0) {
         durationCountdown.value = maxDurationInSecond - currentDurationSecond;
       } else {
         isCanResendCode.value = true;
         timer.cancel();
       }
     });
   }

   Registrant _getUser() {
     try {
       return Get.arguments as Registrant;
     } catch (_) {
       return null;
     }
   }

   // String _getPhoneNumber() {
   //   try {
   //     return ;
   //   } catch (_) {
   //     return null;
   //   }
   // }
}
