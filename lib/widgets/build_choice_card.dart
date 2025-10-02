// widgets/choice_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';

class BuildChoiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  final double height;

  const BuildChoiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.textColor,
    required this.onTap,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width * 0.025),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(context.width * 0.0375),
          child: Container(
            padding: EdgeInsets.all(context.width * 0.025),
            alignment: Alignment.center,
            height: context.height * 0.22,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(context.width * 0.0375),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: context.width * 0.025,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    icon,
                    size: context.width * 0.1125,
                    color: textColor
                ),
                SizedBox(height: context.height * 0.018),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: context.height * 0.006),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}