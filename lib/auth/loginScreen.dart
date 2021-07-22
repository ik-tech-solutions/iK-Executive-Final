library  login_view;

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:my_cab_driver/app/features/authentication/views/screens/authentication_screen.dart';
import 'package:my_cab_driver/app/features/registration/views/screens/registration_screen.dart';
import 'package:my_cab_driver/app/utils/services/firebase_services.dart';
import 'package:my_cab_driver/auth/signUpScreen.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/constance/routes.dart';
import 'package:my_cab_driver/appTheme.dart';
import 'package:my_cab_driver/database/auth/autenticacao.dart';


import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_cab_driver/app/constants/assets_constant.dart';
import 'package:my_cab_driver/app/features/login/controllers/login_controller.dart';

part '../app/features/login/views/components/phone_number_field.dart';
part '../app/features/login/views/components/illustration_image.dart';
part '../app/features/login/views/components/header_text.dart';
part '../app/features/login/views/components/login_button.dart';
part '../app/features/login/views/components/registration_button.dart';


class LoginScreen extends StatelessWidget {
   LoginScreen({Key key}) : super(key: key);

   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

   final phoneNumber = TextEditingController();
   final isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
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
                        Spacer(flex: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _HeaderText(),
                        ),
                        Spacer(flex: 4),
                        _IllustrationImage(),
                        Spacer(flex: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: inputNumber(context),
                        ),
                        Spacer(flex: 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: login(context),
                        ),
                        Spacer(flex: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Não possui uma conta? "),
                            TextButton(
                              style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
                              onPressed: () => goToRegistrationScreen(context),
                              child: Text("Registar"),
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

  Widget login(BuildContext context) {
    return Obx(
          () => ElevatedButton(

            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
            ),
        onPressed: isLoading.value ? null : () async => {
          if (formKey.currentState.validate())  {
            isLoading.value = true,
            await UserServices.phoneNumberExists(phoneNumber.text.trim(),
                onError: (_) {
                  isLoading.value = false;
                }).then((exist) {
              isLoading.value = false;
              if (exist) {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthenticationScreen(telefoneEmVerificacao: phoneNumber.text),
                  ),
                );

                print("Numero ======= Existe ===== " + phoneNumber.text);
              } else {
                print("Numero ======= Não Existe===== " + phoneNumber.text);


                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Este número não foi encontrado'),
                  backgroundColor: Colors.red,
                ));



              }
            }),
          }
        },
        child:isLoading.value
            ? SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        )
            : Text("Login"),
      ),
    );
  }

  Widget inputNumber(BuildContext context){
    return Form(
      key: formKey,
      child: TextFormField(
        controller: phoneNumber,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.trim() == "") return "";
          return null;
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.grey,
            ),
            hintText: "Número de telefone"),
      ),
    );
  }

   void goToRegistrationScreen(BuildContext context) {
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => RegistrationScreen(telefoneEmVerificacao: phoneNumber.text),
       ),
     );
   }


}

