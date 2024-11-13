import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stripe_method/utilities/admin_base_controller.dart';

import '../../models/user_model.dart';
import '../home_screen/home_screen.dart';
import '../signup_screen/signup_screen.dart';

class LoginScreenController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  bool isLoading = false;

  void goToHomeScreen() {
    Get.to(() => HomeScreen());
  }

  void goToSignUpScreen() {
    Get.to(() => SignupScreen());
  }

  void logIn() async {
    if (emailController.text.isEmpty) {
      showOkAlertDialog(
          context: Get.context!, title: 'Error', message: 'Enter your email');
    } else if (passwordController.text.isEmpty) {
      showOkAlertDialog(
          context: Get.context!,
          title: 'Error',
          message: 'Enter your password');
    } else {
      try {
        isLoading = true;
        update();
        final user = await firebaseAuth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        final userDoc = await FirebaseFirestore.instance
            .collection(UserModel.tableName)
            .doc(user.user?.uid ?? "")
            .get();
        if (userDoc.exists) {
          final userData = userDoc.data();
          var userModel = UserModel.fromMap(userData ?? {});
          AdminBaseController.updateAdmin(userModel);
        } else {
          return;
        }
        Get.snackbar('Congratulations', 'Login successfully');
        Get.to(() => HomeScreen());
        emailController.clear();
        passwordController.clear();
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
