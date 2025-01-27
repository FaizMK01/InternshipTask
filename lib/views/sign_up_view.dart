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
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              HelperField(
                controller: nameController,
                hintText: "Enter Your Name",
                prefixIcon: Icons.person, // Pass IconData, not an Icon widget
              ),

              Gap(20),
              HelperField(
                controller: emailController,
                hintText: "Enter Your Email",
                prefixIcon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email.";
                  }
                  // Regex for validating email format
                  final emailRegex = RegExp(
                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return "Please enter a valid email address.";
                  }
                  return null;
                },
              ),


              Gap(20),
              Obx(()=>HelperField(
                controller: passwordController,
                hintText: "Enter your password",
                prefixIcon: Icons.lock,
                obscureText: signUpController.isPasswordVisible.value,
                suffixIcon: IconButton(
                  onPressed: () {
                    signUpController.isPasswordVisible.toggle();
                  },
                  icon: Icon(signUpController.isPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                ),

              )),

              Gap(50),
              UiButton(
                message: "Sign Up",
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    String name = nameController.text;
                    String email = emailController.text;
                    String password = passwordController.text;
                    signUpController.signup(name,email, password);
                    nameController.clear();
                    emailController.clear();
                    passwordController.clear();



                  }


                },
              ),
              Gap(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  Gap(5),
                  TextButton(
                    onPressed: () {
                      Get.to(() => LoginView(),transition:Transition.upToDown,duration: Duration(seconds: 2));
                    },
                    child: Text("Login"),
                  ),
                ],
              ),

              GestureDetector(
                onTap: () {

                  //    firebaseServices.signInWithGoogle();

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