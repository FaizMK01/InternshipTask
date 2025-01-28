import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:interni_task/helper/custom_snackbar.dart';
import 'package:interni_task/views/sign_up_view.dart';
import '../firebase_services/firebase_services.dart';
import '../helper/TextField.dart';
import '../helper/UI_button.dart';
import '../helper/shared_prefs.dart';
import 'home_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SharedPrefService sharedPrefService = SharedPrefService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseServices firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(screenHeight * 0.02),

              HelperField(
                controller: emailController,
                hintText: "Enter your Email",
                prefixIcon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your Email";
                  }
                  return null;
                },
              ),
              Gap(screenHeight * 0.02),

              Obx(
                    () => HelperField(
                  controller: passwordController,
                  hintText: "Enter your Password",
                  prefixIcon: Icons.lock,
                  obscureText: firebaseServices.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    onPressed: () {
                      firebaseServices.isPasswordVisible.toggle();
                    },
                    icon: Icon(
                      firebaseServices.isPasswordVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              Gap(screenHeight * 0.01),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Add Forgot Password Logic Here
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  ),
                ),
              ),
              Gap(screenHeight * 0.02),

              UiButton(
                message: "Login",
                onTap: firebaseServices.isLoading.value
                    ? null
                    : () async {
                  if (_formKey.currentState!.validate()) {
                    firebaseServices .isLoading.value = true;
                    try {
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();

                      Map<String, String> userData = await firebaseServices.login(email, password);

                      await sharedPrefService.saveUserData(
                        userData['name']!,
                        userData['email']!,
                        userData['uid']!,
                      );

                      Get.off(() => HomeView());
                      CustomSnackBar.successMessage("Login Successfully");
                    } catch (e) {
                      CustomSnackBar.errorMessage("Login Failed, ${e.toString()}");
                    } finally {
                  firebaseServices.isLoading.value = false;
                    }
                  }
                },
              ),
              Gap(screenHeight * 0.015),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  ),
                  Gap(screenWidth * 0.01),
                  TextButton(
                    onPressed: () {
                      Get.to(
                            () => SignUpView(),
                        transition: Transition.upToDown,
                        duration: const Duration(seconds: 1),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ),
                ],
              ),
              Gap(screenHeight * 0.015),


              GestureDetector(
                onTap: () {
                  firebaseServices.signInWithGoogle();
                },
                child: Image.asset(
                  "assets/google_image.png",
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
