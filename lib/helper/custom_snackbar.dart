import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../constants/app_colors.dart';

class CustomSnackBar{

  static successMessage(String message){
    return Get.showSnackbar(GetSnackBar(
      title: "Success",
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(milliseconds: 2000),
      backgroundColor: AppColors.primaryColor,
    ));


  }
  static errorMessage(String eMessage){
    return Get.showSnackbar(GetSnackBar(
      title: "Error",
      message: eMessage,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(milliseconds: 2000),
      backgroundColor: AppColors.redColor
    ));

  }

}