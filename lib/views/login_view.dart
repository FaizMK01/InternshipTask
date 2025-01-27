
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:interni_task/views/sign_up_view.dart';
import '../controllers/login_controller.dart';
import '../firebase_services/firebase_services.dart';
import '../helper/TextField.dart';
import '../helper/UI_button.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();
  final FirebaseServices firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Gap(20),


              HelperField(
                controller: nameController,
                hintText: "Enter your name",
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Your Name";
                  }
                  return null;
                },
              ),
              // Email TextFormField

              Gap(20),

              Obx(()=>HelperField(
                controller: passwordController,
                hintText: "Enter your password",
                prefixIcon: Icons.lock,
                obscureText: loginController.isPasswordVisible.value,
                suffixIcon: IconButton(
                  onPressed: () {
                    loginController.isPasswordVisible.toggle();
                  },
                  icon: Icon(loginController.isPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                ),

              )),

              Gap(10),

              // Forgot Password Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                  },
                  child: const Text("Forgot Password?"),
                ),
              ),
              Gap(20),

              // Login Button
              Obx(() => UiButton(
                message: "Login",
                onTap: loginController.isLoading.value
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    String name = nameController.text;
                    String password = passwordController.text;
                    loginController.login(name, password);
                    nameController.clear();
                    passwordController.clear();
                  }
                },
              )),

              Gap(15),

              // Sign Up Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  Gap(5),
                  TextButton(
                    onPressed: () {
                      Get.to(() => SignUpView(),
                          transition: Transition.upToDown,
                          duration: const Duration(seconds: 1));
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
              Gap(15),

              // Google Login Button
              GestureDetector(
                onTap: () {
                  //  firebaseServices.signInWithGoogle();
                },
                child: Image.asset(
                  "assets/google_image.png",
                  height: 50,
                  width: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
