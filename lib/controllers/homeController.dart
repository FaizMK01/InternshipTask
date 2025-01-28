import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../helper/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var profileImage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }


  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          name.value = userDoc['name'];
          email.value = userDoc['email'];
        } else {
          print('User document not found');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> updateName(String newName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          await userDoc.reference.update({'name': newName});
          name.value = newName;
        } else {
          print('User document not found');
        }
      }
    } catch (e) {
      print('Error updating name: $e');
    }
  }

  void showImagePickerDialog() {
    Get.defaultDialog(
      title: "Select Image",
      middleText: "Choose an option to select an image.",
      actions: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text("Camera"),
          onTap: () {
            pickImage(ImageSource.camera); // For camera
            Get.back();
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text("Gallery"),
          onTap: () {
            pickImage(ImageSource.gallery); // For gallery
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
        profileImage.value = pickedFile.path;
      }
    } catch (e) {
    CustomSnackBar.errorMessage("Error, Failed to pick an image: $e");
    }
  }
}



