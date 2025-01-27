import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';
import '../firebase_services/firebase_services.dart';
import '../helper/TextField.dart';
import '../helper/UI_button.dart';
import 'login_view.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});

  final SignupController signUpController = Get.put(SignupController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseServices firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  HelperField(
                    controller: nameController,
                    hintText: "Enter Your Name",
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  HelperField(
                    controller: emailController,
                    hintText: "Enter Your Email",
                    prefixIcon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email.";
                      }
                      final emailRegex = RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return "Please enter a valid email address.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Obx(
                        () => HelperField(
                      controller: passwordController,
                      hintText: "Enter your password",
                      prefixIcon: Icons.lock,
                      obscureText: signUpController.isPasswordVisible.value,
                      suffixIcon: IconButton(
                        onPressed: () {
                          signUpController.isPasswordVisible.toggle();
                        },
                        icon: Icon(
                          signUpController.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  UiButton(
                    message: "Sign Up",
                    onTap: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      } else {
                        String name = nameController.text;
                        String email = emailController.text;
                        String password = passwordController.text;
                        await FirebaseServices().signup(name, email, password);
                      }
                      nameController.clear();
                      emailController.clear();
                      passwordController.clear();
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      SizedBox(width: screenWidth * 0.01),
                      TextButton(
                        onPressed: () {
                          Get.to(
                                () => LoginView(),
                            transition: Transition.upToDown,
                            duration: const Duration(seconds: 1),
                          );
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onTap: () {
                      firebaseServices.signInWithGoogle();
                    },
                    child: Image.asset(
                      "assets/google_image.png",
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.15,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
