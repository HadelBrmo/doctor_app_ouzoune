import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:ouzoun/Routes/app_routes.dart';
import 'package:ouzoun/views/procedure/procedure_screen/add_procedure.dart';
import 'package:ouzoun/views/rate/rate_screen/rate_screen.dart';
import '../models/Implant_model.dart';
import '../models/kit_model.dart';
import '../models/procedure_model.dart';
import '../views/doctor_choices/doctor_choices_screens/first_page_choices.dart';
import '../views/doctor_choices/doctor_choices_screens/second_page_choices.dart';
import '../views/forget_password/forget_password_screens/chekEmail.dart';
import '../views/forget_password/forget_password_screens/code.dart';
import '../views/forget_password/forget_password_screens/resetPasswordPage.dart';
import '../views/forget_password/forget_password_screens/resetpasswordpage.dart' hide ResetPasswordPage;
import '../views/homePage/HomePage_Controller/homePage_controller.dart';
import '../views/homePage/homePage_screen/homePage_screen.dart';
import '../views/kits/kits_screens/additional_kits.dart';
import '../views/kits/kits_screens/detail_kit.dart';
import '../views/kits/kits_screens/implant_kits.dart';
import '../views/kits/kits_screens/surgical_kits.dart';
import '../views/login/login_screen.dart';
import '../views/myProfile/myProfile_screen/myProfile_screen.dart';
import '../views/notification/notification_controller/notification_controller.dart';
import '../views/notification/notification_screen/notification_screen.dart';
import '../views/procedure/procedure_screen/get_all_procedures.dart';
import '../views/procedure/procedure_screen/procedure_detail_screen.dart';
import '../views/register/register_screen.dart';
import '../views/setting/setting_screen/setting_screen.dart';
import '../views/splash/splash_screens/splash_screen.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.detail_kit,
      page: () {
        final args = Get.arguments;

        if (args is Map<String, dynamic> &&
            args['implant'] is Implant &&
            args['kit'] is Kit) {
          return ImplantDetailScreen(
            implant: args['implant'],

          );
        } else {
          Get.back();
          Get.snackbar('Error', 'Invalid data received');
          return SizedBox.shrink();
        }
      },
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => MyProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),

    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),

    ),
    GetPage(
      name: AppRoutes.firstchoice,
      page: () => FirstPageChoices(),

    ),
    GetPage(
      name: AppRoutes.secondchoice,
      page: () =>SecondPageChoices(),

    ),
    GetPage(
      name: AppRoutes.chekEmail,
      page: () =>CheckEmail(),

    ),
    GetPage(
      name: AppRoutes.code,
      page: () =>Code(),

    ),
    GetPage(
      name: AppRoutes.resetpage,
      page: () =>ResetPasswordPage(),

    ),
    GetPage(
      name: AppRoutes.homepage,
      page: () =>HomePageScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomePageController());
      }),
    ),
    GetPage(
      name: AppRoutes.surgical_kit,
      page: () =>SurgicalKits(),

    ),
    GetPage(
      name: AppRoutes.additional_kit,
      page: () =>AdditionalKits(),

    ),
    GetPage(
      name: AppRoutes.implant_kit,
      page: () {
        final implant = Get.arguments ?? {};
        return Implantkits();
      },
    ),
    GetPage(
      name: AppRoutes.addprocedure,
      page: () => AddProcedure(),
    ),
    GetPage(
      name: AppRoutes.getAllprocedure,
      page: () =>ProceduresScreen(),
    ),
    GetPage(
      name: AppRoutes.procedure_detail,
      page: () {
        final args = Get.arguments;
        if (args is Procedure) {
          return ProcedureDetailScreen( procedureId: args.id,);
        } else {
          return Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text('Invalid procedure data')),
          );
        }
      },
    ),
    GetPage(
      name: AppRoutes.rate,
      page: () =>RateScreen( ),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => NotificationsScreen(),
    ),
  ];
}



