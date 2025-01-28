import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:interni_task/constants/app_colors.dart';
import 'package:interni_task/helper/custom_snackbar.dart';
import 'package:interni_task/views/home_view.dart';
import 'package:interni_task/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseServices {

  RxBool isPasswordVisible = true.obs;
  RxBool isLoading = false.obs;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  Future<void> signup(String name, String email, String password) async {
    try {
      UserCredential userCredential =
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'uid': userCredential.user!.uid,
      });

      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
      }

      Get.to(() => LoginView(), arguments: {
        CustomSnackBar.successMessage("Verification', 'An verification link is send to you email address.")
      });
    } catch (e) {
      CustomSnackBar.errorMessage("Error', Signup failed: ${e.toString()}");
    }
  }

  Future<Map<String, String>> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!userCredential.user!.emailVerified) {
        int timer = 60;
        Timer? timerInstance;

        await Get.dialog(
          StatefulBuilder(
            builder: (context, setState) {
              if (timerInstance == null) {
                timerInstance = Timer.periodic(
                  const Duration(seconds: 1),
                      (instance) {
                    if (timer <= 0) {
                      instance.cancel();
                    } else {
                      setState(() => timer--);
                    }
                  },
                );
              }

              return AlertDialog(
                title: const Text('Email Not Verified'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Please verify your email to proceed.'),
                    const SizedBox(height: 10),
                    Text('Resend available in $timer seconds'),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: timer > 0
                        ? null
                        : () async {
                      await userCredential.user!.sendEmailVerification();
                      timer = 60;
                      setState(() {});
                    },

                    child: const Text('Resend Email')
                  ),
                  TextButton(
                    onPressed: () {
                      if (timerInstance != null) {
                        timerInstance!.cancel();
                      }
                      Get.back();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          ),
        );

        if (timerInstance != null) {
          timerInstance?.cancel();
        }
        throw Exception('Email not verified. Please verify to continue.');
      }

      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User data not found in the database.');
      }

      Map<String, String> userData = {
        'name': userDoc['name'],
        'email': userDoc['email'],
        'uid': userDoc['uid'],
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', userData['name']!);
      await prefs.setString('email', userData['email']!);
      await prefs.setString('uid', userData['uid']!);

      return userData;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAll(() => LoginView());
      CustomSnackBar.successMessage("Logout successfully");
    } catch (e) {
      CustomSnackBar.errorMessage("Error, Logout failed: ${e.toString()}");
    }
   }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(credential);
      Get.offAll(HomeView());
      return userCredential.user;

    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }



}