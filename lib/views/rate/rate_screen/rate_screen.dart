import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ouzoun/widgets/custom_button.dart';
import '../../../Routes/app_routes.dart';
import '../../../Widgets/custom_drawer.dart';
import '../../../core/constants/app_colors.dart';
import '../rate_controller/rate_controller.dart';
import '../widget/buildRateHelpeer.dart';



class RateScreen extends StatelessWidget {
  RateScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final RateController controller = Get.put(RateController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        key: scaffoldKey,
        drawer: CustomDrawer(),
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
          toolbarHeight: context.height * 0.1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(context.width * 0.06),
            ),),
            title: Text("Assistance Rating",
                style: Theme.of(context).textTheme.titleSmall),
            backgroundColor: AppColors.primaryGreen,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.width * 0.04),
                  margin: EdgeInsets.only(bottom: context.height * 0.01),
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
                        "On this page you can rate the assistants from 1 to 5 and write your comments about them....",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: context.width * 0.035,
                          color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                buildAssistantDropdown(context),

                const SizedBox(height: 30),

                buildRatingSection(context),

                const SizedBox(height: 15),

                buildFeedbackSection(context),

                SizedBox(height: 30),
                Obx(() {
                  return controller.isLoading.value
                      ? buildProgressIndicator(context)
                      : CustomButton(
                    onTap: () {
                      controller.submitRating();
                    },
                    text: 'Submit Rating',
                    color: AppColors.primaryGreen,
                  );
                }),


              ],
            ),
          ),
        );
    }


}