import 'package:flutter/material.dart';

import '../utils/constants/app_colors.dart';
import '../utils/constants/app_images.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.body,
    required this.actionWidget,
    required this.title,
  });

  final Widget body;
  final Widget actionWidget;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.white),
        Positioned(
          top: -180,
          left: -280,
          child: Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(360),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppbar(),
          body: body,
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppImages.imgNike,
                    height: 30,
                  ),
                  const SizedBox(height: 20),
                   Text(
                    title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              actionWidget
            ],
          ),
        ),
      ),
    );
  }
}
