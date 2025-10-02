import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../Widgets/custom_bottom_navigation_bar .dart';
import '../../../Widgets/custom_button.dart';
import '../../../Widgets/custom_drawer.dart';
import '../../../core/constants/app_colors.dart';
import '../Kits_Controller/kits_controller.dart';
import '../widget/BuildSurgicalCard.dart';
import '../widget/buildToolCard.dart';

class SurgicalKits extends StatelessWidget {
  final KitsController controller = Get.put(KitsController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final List<Map<String, dynamic>> surgicalTools = [
    {
       "id":1,
      'name': 'Dental Drill',
      'image': 'assets/images/forceps.png',
      'length': '15 cm',
      'width': '3 cm',
      'thickness': '2 cm',
      'quantity': "0",
    },
    {
      "id":2,
      'name': 'Surgical Scissors',
      'image': 'assets/images/mouth-mirror.png',
      'length': '12 cm',
      'width': '4 cm',
      'thickness': '0.5 cm',
      'quantity': "3",
    },
    {
      "id":3,
      'name': 'Bone File',
      'image': 'assets/images/probe.png',
      'length': '18 cm',
      'width': '2 cm',
      'thickness': '0.8 cm',
      'quantity': "2",
    },
    {
      "id":4,
      'name': 'Retractor',
      'image': 'assets/images/tooth.png',
      'length': '20 cm',
      'width': '5 cm',
      'thickness': '1 cm',
      'quantity': "1",
    },
    {
      "id":5,
      'name': 'Dental Drill',
      'image': 'assets/images/forceps.png',
      'length': '15 cm',
      'width': '3 cm',
      'thickness': '2 cm',
      'quantity': "4",
    },
    {
      "id":6,
      'name': 'Surgical Scissors',
      'image': 'assets/images/mouth-mirror.png',
      'length': '12 cm',
      'width': '4 cm',
      'thickness': '0.5 cm',
      'quantity': "5",
    },
  ];
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
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
        title: Text("Surgical Kits",
            style: Theme.of(context).textTheme.titleSmall),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.04, vertical: context.height * 0.02),
          child: Column(
            children: [
              // Welcome message
                   Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.width * 0.04),
                margin: EdgeInsets.only(bottom: context.height * 0.02),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello Doctor,",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: context.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: context.height * 0.01),
                    Text(
                      "This page is dedicated to fixed surgical tools, which must be present in every operation..",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: context.width * 0.035,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
                 AnimationLimiter(
                child: Column(
                  children: List.generate(
                    surgicalTools.length,
                        (index) => AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child:  BuildSurgicalCard(
                            showQuantityDetail: true,
                            isAppear: false,
                            context: context,
                            imagePath: surgicalTools[index]['image'],
                            toolName: surgicalTools[index]['name'],
                            length: surgicalTools[index]['length'],
                            width: surgicalTools[index]['width'],
                            thickness: surgicalTools[index]['thickness'],
                            quantity: surgicalTools[index]['quantity'],
                             selectedQuantity:0,
                            onQuantitySelected: (quantity) {
                              // controller.updateSurgicalToolQuantity(index, quantity);
                            },
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
      ],
        ),
      ),
    ));
  }
}
