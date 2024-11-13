import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stripe_method/models/user_model.dart';
import 'package:stripe_method/utilities/admin_base_controller.dart';

import '../login_screen/login_screen.dart';

class SignupScreenController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  bool isLoading = false;

  void LodinScreen() {
    Get.to(() => LoginScreen());
  }

  void signUP() async {
    if (emailController.text.isEmpty) {
      showOkAlertDialog(
          context: Get.context!, title: 'Error', message: 'Enter your email');
    } else if (passwordController.text.isEmpty) {
      showOkAlertDialog(
          context: Get.context!,
          title: 'Error',
          message: 'Enter your password');
    } else if (nameController.text.isEmpty) {
      showOkAlertDialog(
          context: Get.context!, title: 'Error', message: 'Enter your name');
    } else {
      try {
        isLoading = true;
        update();
        UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        UserModel userModel = UserModel(
            uid: userCredential.user?.uid,
            email: emailController.text,
            password: passwordController.text,
            name: nameController.text);
        await fireStore
            .collection(UserModel.tableName)
            .doc(userModel.uid)
            .set(userModel.toMap());
        Get.snackbar('Congratulations', 'Account created successfully');
        Get.to(() => LoginScreen());
        emailController.clear();
        passwordController.clear();
        nameController.clear();
        isLoading = false;
        update();
      } catch (e) {
        isLoading = false;
        update();
        showOkAlertDialog(
            context: Get.context!, title: 'Error', message: e.toString());
      }
    }
  }
}
