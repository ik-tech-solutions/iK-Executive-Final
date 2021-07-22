// library login_view;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_cab_driver/app/constants/assets_constant.dart';
import 'package:my_cab_driver/app/features/login/controllers/login_controller.dart';



class LoginScreend extends StatelessWidget {
  const LoginScreend({Key key}) : super(key: key);

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
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: _HeaderText(),
                // ),
                // Spacer(flex: 4),
                // _IllustrationImage(),
                // Spacer(flex: 4),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: _PhoneNumberField(),
                // ),
                // Spacer(flex: 2),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: _LoginButton(),
                // ),
                // Spacer(flex: 5),
                // _RegistrationButton(),
                Spacer(flex: 2),
              ],
            ),
          ),
        ]))
      ],
    ));
  }
}
