library registration_view;

import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/app/constants/assets_constant.dart';
import 'package:my_cab_driver/app/features/authentication/views/screens/authentication_screen.dart';
import 'package:my_cab_driver/app/features/registration/controllers/registration_controller.dart';
import 'package:my_cab_driver/app/utils/services/firebase_services.dart';
import 'package:my_cab_driver/auth/loginScreen.dart';
import 'package:my_cab_driver/constance/global.dart';
import 'package:my_cab_driver/database/HelperMethods.dart';
import 'package:my_cab_driver/extension/string_extension.dart';
import 'package:my_cab_driver/models/carteira.dart';
import 'package:my_cab_driver/models/usuario.dart';
import 'package:my_cab_driver/notification/notification.dart';

part '../components/phone_number_field.dart';
part '../components/illustration_image.dart';
part '../components/header_text.dart';
part '../components/register_button.dart';
part '../components/login_button.dart';
part '../components/name_field.dart';

class RegistrationScreen extends StatelessWidget {

  String telefoneEmVerificacao;
  RegistrationScreen({Key key, @required this.telefoneEmVerificacao}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final txtnome = TextEditingController();
  final phoneNumber = TextEditingController();
  final isLoading = false.obs;

  String countryCode = "+351";
  String phoneNumberTemp = '';
  // var txtnome = TextEditingController();
  var txtemail = TextEditingController();
  // var txtphone = TextEditingController();
  // var txtpassword = TextEditingController();

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
                    child: Form(
                      key: formKey,
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
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              controller: txtnome,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.trim() == "") return "";
                                return null;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Nome completo"),
                            ),
                          ),
                          Spacer(flex: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: CountryCodePicker(
                                    onChanged: (e) {
                                      print(e.toLongString());
                                      print(e.name);
                                      print(e.code);
                                      print(e.dialCode);
                                      // setState(() {
                                      countryCode = e.dialCode;
                                      // });
                                    },
                                    initialSelection: 'PT',
                                    showFlagMain: true,
                                    showFlag: true,
                                    favorite: ['+351','PT'],
                                  ),
                                ),
                                Container(
                                  color: Theme.of(context).dividerColor,
                                  height: 32,
                                  width: 1,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0, right: 16),
                                    child: Container(
                                      height: 38,
                                      child: TextFormField(
                                        controller: phoneNumber,
                                        keyboardType: TextInputType.phone,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value == null || value.trim() == "") return "";
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          // prefixIcon: Icon(
                                          //   Icons.phone,
                                          //   color: Colors.grey,
                                          // ),
                                            hintText: "  Número de telefone"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(flex: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              controller: txtemail,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.trim() == "") return "";
                                return null;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Email"),
                            ),
                          ),
                          Spacer(flex: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Obx(
                                  () => ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                                    ),
                                onPressed:
                                isLoading.value ? null : () => register(context),
                                child: isLoading.value
                                    ? SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(),
                                )
                                    : Text("Registar"),
                              ),
                            ),
                          ),
                          Spacer(flex: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Já possui uma conta? "),
                              TextButton(
                                style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
                                onPressed: () =>goToLoginScreen(context),
                                child: Text("Login"),
                              )
                            ],
                          ),
                          Spacer(flex: 2),
                        ],
                      ),
                    ),
                  ),
                ]))
          ],
        ));
  }

  void goToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  void register(BuildContext context) async {
    if (formKey.currentState.validate()) {
      isLoading.value = true;
      UserServices.phoneNumberExists(countryCode+phoneNumber.text.trim(), onError: (_) {})
          .then((exist) {
        isLoading.value = false;
        if (exist) {
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: Text('Este número já foi registado'),
            backgroundColor: Colors.red,
          ));

        } else {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Verifique o código OTP enviado por SMS'),
            backgroundColor: Colors.red,
          ));

          //Manipular o registo Aqui

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AuthenticationScreen(registrant: Registrant(name: txtnome.text, phoneNumber: countryCode+phoneNumber.text, email: txtemail.text)),
            ),
          );

        }
      });
    }
  }


}
