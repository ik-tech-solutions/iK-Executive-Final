import 'package:get/get.dart';
import 'package:my_cab_driver/app/features/authentication/bindings/authentication_binding.dart';
import 'package:my_cab_driver/app/features/authentication/views/screens/authentication_screen.dart';
import 'package:my_cab_driver/app/features/home/bindings/home_binding.dart';
import 'package:my_cab_driver/app/features/home/views/views/home_screen.dart';
import 'package:my_cab_driver/app/features/login/bindings/login_binding.dart';
import 'package:my_cab_driver/app/features/login/views/screens/login_screen.dart';
import 'package:my_cab_driver/app/features/registration/bindings/registration_binding.dart';
import 'package:my_cab_driver/app/features/registration/views/screens/registration_screen.dart';
import 'package:my_cab_driver/app/features/splash/views/screens/splash_screen.dart';
import 'package:my_cab_driver/auth/loginScreen.dart';

part 'app_routes.dart';

abstract class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.registration,
      page: () => RegistrationScreen(),
      binding: RegistrationBinding(),
    ),
    GetPage(
        name: _Paths.authentication,
        page: () => AuthenticationScreen(),
        transition: Transition.cupertino,
        binding: AuthenticationBinding()),
    GetPage(
      name: _Paths.home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    )
  ];
}
