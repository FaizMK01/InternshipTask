import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interni_task/firebase_services/firebase_services.dart';
import 'package:interni_task/helper/custom_snackbar.dart';
import 'package:interni_task/helper/dialogbutton.dart';
import '../constants/app_colors.dart';
import '../controllers/homeController.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final FirebaseServices services = FirebaseServices();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenWidth < 400 ? 18 : 22;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Home View",
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.05, right: 10),
        child: FloatingActionButton(
          onPressed: () {

            services.logout();

          },
          backgroundColor: AppColors.primaryColor,
          child: Icon(Icons.logout, color: AppColors.whiteColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: screenHeight * 0.12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Obx(
                      () => Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.25,
                        backgroundColor: Colors.grey[300],
                        child: homeController.profileImage.value.isEmpty
                            ? const Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.grey,
                        )
                            : ClipOval(
                          child: Image.file(
                            File(homeController.profileImage.value),
                            fit: BoxFit.cover,
                            width: screenWidth * 0.5,
                            height: screenWidth * 0.5,
                          ),
                        ),
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
              SizedBox(height: screenHeight * 0.07),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Obx(
                      () => Text(
                    "Email: ${homeController.email.value}",
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              ListTile(
                title: Obx(
                      () => Text(
                    homeController.name.value,
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    TextEditingController nameController = TextEditingController(text: homeController.name.value);

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
                              onTap: () {
                                Get.back();
                              },
                            ),
                            DialogHelperButton(
                              text: "Update",
                              textColor: AppColors.whiteColor,
                              backColor: Colors.green,
                              onTap: () {
                                String updatedName = nameController.text; // Getting text directly from the controller

                                homeController.updateName(updatedName);
                                Get.back();
                                CustomSnackBar.successMessage("Name Updated");

                              },
                            ),
                          ],
                        ),
                      ],
                      content: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(hintText: "Enter new name"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
