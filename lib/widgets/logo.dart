import 'package:flutter/material.dart';
import 'package:ouzoun/core/constants/app_images.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(70),
        ),
        child: Image.asset(
          AppAssets.logoForApp,
          height: 50,
        ),
      ),
    );
  }
}





































