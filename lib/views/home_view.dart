import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interni_task/controllers/signup_controller.dart';
import 'package:interni_task/helper/dialogbutton.dart';
import '../constants/app_colors.dart';
import '../controllers/homeController.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final SignupController signupController = Get.put(SignupController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Home View",
          style: TextStyle(
            fontSize: 25,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 10),
        child: FloatingActionButton(
          onPressed: () {

            signupController.signOut();

          },
          backgroundColor: AppColors.primaryColor,

          child: const Icon(Icons.logout,color: AppColors.whiteColor,),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Obx(
                    () => Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: homeController.profileImage.value.isEmpty
                          ? const AssetImage("assets/google_image.png")
                      as ImageProvider
                          : FileImage(File(homeController.profileImage.value)),
                      child: homeController.profileImage.value.isEmpty
                          ? const Icon(Icons.person, size: 100)
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt, size: 30),
                      onPressed: () {
                        homeController.showImagePickerDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(
                    () => Text(
                  "Email: ${homeController.email.value}",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 30),


            ListTile(
              title: Obx(
                    () => Text(
                  homeController.name.value,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Get.defaultDialog(
                    title: "Edit Name",
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          DialogHelperButton(
                              text: "Cancel",
                              textColor: AppColors.whiteColor,
                              backColor: Colors.red,
                              onTap: (){
                                Get.back();
                              }),

                          DialogHelperButton(
                              text: "Update",
                              textColor: AppColors.whiteColor,
                              backColor: Colors.green,
                              onTap: (){

                              }),

                        ],
                      ),
                    ],
                    content: TextField(
                      decoration: const InputDecoration(hintText: "Enter new name"),
                      onSubmitted: (newName) {
                        homeController.updateName(newName); // Update the name in the controller
                        Get.back(); // Close the dialog after update
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
