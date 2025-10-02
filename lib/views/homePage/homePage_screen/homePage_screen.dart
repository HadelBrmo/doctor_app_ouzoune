import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ouzoun/Routes/app_routes.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../Widgets/custom_bottom_navigation_bar .dart';
import '../../../Widgets/custom_drawer.dart';
import '../../../core/constants/app_colors.dart';
import '../../procedure/procedure_screen/add_procedure.dart';
import '../HomePage_Controller/homePage_controller.dart';
import '../widget/build_body.dart';

class HomePageScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  NavigationController controller=Get.put(NavigationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[300],
        elevation: 4,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.06,
          height: MediaQuery.of(context).size.width * 0.06,
          child: Icon(Icons.home, color: Colors.black),
        ),
        onPressed: () {
          controller.changeIndex(2);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      key: scaffoldKey,
      drawer: CustomDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
               child: InkWell(
                 onTap: () {
                   debugPrint('Attempting to navigate to: ${AppRoutes.addprocedure}');
                   try {
                     Get.to(() => AddProcedure());
                   } catch (e, stackTrace) {
                     debugPrint('Navigation error: $e');
                     debugPrint('Stack trace: $stackTrace');
                     Get.snackbar('Error', 'Failed to navigate to procedure page');
                   }
                 },
                 child: Stack(
                   alignment: Alignment.topRight,
                   children: [
                     IconButton(onPressed: (){
                       Get.toNamed(AppRoutes.addprocedure);
                     }, icon: Icon( FontAwesomeIcons.tooth,
                     color: Colors.white,
                     )),
                     Icon(Icons.add_circle_outline_sharp,
                     color: Colors.white,
                       size: 20,
                     ),
                   ],
                 ),
               ),
          ),

        ],
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu, color: Colors.white),
        ),
        toolbarHeight: context.height * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.width * 0.06),
          ),
        ),
        title: Text("Welcome Doctor",
            style: Theme.of(context).textTheme.titleSmall),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: BuildBody(context),

    );
  }

}