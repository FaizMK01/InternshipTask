import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:interni_task/views/home_view.dart';
import 'package:interni_task/views/login_view.dart';
import '../firebase_services/firebase_services.dart';
import '../helper/custom_snackbar.dart';

class SignupController extends GetxController {

  final FirebaseServices firebaseServices = FirebaseServices();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  RxBool isPasswordVisible = true.obs;

  Future<void> signup(String name, String email, String password) async {
    try {
      EasyLoading.show(status: "Please wait...");

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification(); // Send email verification

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'docID': user.uid,
        });

        CustomSnackBar.successMessage("Signup Successful. Please verify your email.");

        Get.offAll(HomeView());
      }

    } on FirebaseAuthException catch (e) {
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
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      await auth.signOut();
      print("Signed out from Firebase");


      Get.offAll(LoginView());

     // Get.offAllNamed('/login'); // Replace with your login route
    } catch (e) {
      Get.snackbar("Error", "Failed to sign out: $e");
    }
  }
}
