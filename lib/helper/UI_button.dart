import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class UiButton extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;
   const UiButton({super.key,required this.message,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 50,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.whiteColor,
          ),
          child: Text(message),
        ),
      ),
    );
  }
}
