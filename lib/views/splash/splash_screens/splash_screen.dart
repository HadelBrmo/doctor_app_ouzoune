import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ouzoun/Core/Services/media_query_service.dart';
import '../../../Routes/app_routes.dart';
import '../../../Widgets/custom_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../splash_screens/page1_screen.dart';
import '../splash_screens/page2_screen.dart';
import '../splash_screens/page3_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {
  PageController splashController=PageController();
  bool onlastPage=false;
  @override
  Widget build(BuildContext context) {
    @override
    final media = MediaQueryHelper(context);
    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          PageView(
            controller: splashController,
            onPageChanged: (index){
              setState(() {
                onlastPage=(index==2);
              });
            },
            children: [
              Page1(),
              Page2(),
              Page3(),
            ],
          ),
          Container(
              alignment: Alignment(0, 0.85),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child:Text("skip".tr,
                      textAlign: TextAlign.center,
                      style:Theme.of(context).textTheme.headlineSmall,),
                    onTap: (){
                      splashController.jumpToPage(2);
                    },
                  ),
                  SmoothPageIndicator(
                    controller: splashController,
                    count: 3,
                    effect: WormEffect(
                      activeDotColor: AppColors.lightGreen,
                      dotColor: Colors.grey,
                    ),
                  ),
                  onlastPage?
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(AppRoutes.firstchoice);
                    },
                    child:  Text("done".tr,
                      textAlign: TextAlign.center,
                      style:Theme.of(context).textTheme.headlineSmall,),
                  ):
                  GestureDetector(
                    onTap: (){
                      splashController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOut );
                    },
                    child:  Text("next".tr,
                      textAlign: TextAlign.center,style:Theme.of(context).textTheme.headlineSmall,)
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
