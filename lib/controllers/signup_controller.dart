
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_services/firebase_services.dart';
import '../helper/custom_snackbar.dart';
import '../views/login_view.dart';

class SignupController extends GetxController {

  final FirebaseServices firebaseServices = FirebaseServices();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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

  Future<void> signOut() async {
    try {
      // Check if user is signed in via Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Sign out from Firebase
      await auth.signOut();
      print("Signed out from Firebase");


      Get.offAllNamed('/login'); // Replace with your login route
    } catch (e) {
      Get.snackbar("Error", "Failed to sign out: $e");
    }
  }
}
