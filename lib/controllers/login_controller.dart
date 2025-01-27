
import 'package:get/get.dart';
import '../firebase_services/firebase_services.dart';

class LoginController extends GetxController {
  final FirebaseServices firebaseServices = FirebaseServices();

  RxBool isPasswordVisible = true.obs;
  RxBool isLoading = false.obs;


  Future<void> login(String name, String password) async {
    isLoading.value = true;
    try {
      await firebaseServices.login(name, password);
    } finally {
      isLoading.value = false;
    }
  }


}
