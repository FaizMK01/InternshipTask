
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../firebase_services/firebase_services.dart';
import '../helper/custom_snackbar.dart';
import '../views/login_view.dart';

class SignupController extends GetxController {
  final FirebaseServices firebaseServices = FirebaseServices();

  RxBool isPasswordVisible = true.obs;

  Future<void> signup(String name,String email, String password,) async {
    try {
      EasyLoading.show(status: "Please wait...");

      await firebaseServices.signup(name, email, password);
      CustomSnackBar.successMessage("Signup Successfully");


      // Navigate to the next screen (e.g., BottomNav)
      // Get.offNamed('/bottomNav'); // Example navigation
      Get.offAll(LoginView());

    } on FirebaseAuthException catch (e) {
      // Handle errors and show appropriate messages
      String errorMessage = '';

      if (e.code == 'user-not-found') {
        errorMessage = 'The email provided is not registered.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'The password you provided is incorrect.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = e.message ?? 'An unknown error occurred.';
      }

      CustomSnackBar.errorMessage(errorMessage);
    } finally {
      EasyLoading.dismiss();
    }
  }


}
