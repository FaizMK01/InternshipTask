import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../helper/custom_snackbar.dart';

class HomeController extends GetxController {
  var profileImage = ''.obs; // Stores image path
  var name = "Faiz Muhammad Khan".obs; // Stores user name
  var email = "faiz@example.com".obs; // Stores user email

  void showImagePickerDialog() {
    Get.defaultDialog(
      title: "Select Image",
      middleText: "Choose an option to select an image.",
      actions: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text("Camera"),
          onTap: () {
            pickImage(ImageSource.camera);  // For camera
            Get.back();
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text("Gallery"),
          onTap: () {
            pickImage(ImageSource.gallery);  // For gallery
            Get.back();
          },
        ),
      ],
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        profileImage.value = pickedFile.path; // Update image path
      }
    } catch (e) {
      CustomSnackBar.errorMessage("Error, Failed to pick an image: $e");
    }
  }

  void updateName(String newName) {
    name.value = newName; // Update name dynamically
  }
}
