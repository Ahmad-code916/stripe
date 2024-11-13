import 'dart:developer';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:stripe_method/models/user_model.dart';
import 'package:stripe_method/screens/card_settings/card_settings.dart';
import 'package:stripe_method/services/stripe_services.dart';
import 'package:stripe_method/utilities/admin_base_controller.dart';

import '../../utilities/base_controller.dart';

class HomeScreenController extends GetxController {
  final _baseController = BaseController(Get.context, () {});

  void goBack() {
    Get.back();
  }

  void goToSettingsScreen() {
    Get.to(() => CardSettings());
  }

  void check() async {
    try {
      var email = AdminBaseController.adminData.email ?? '';
      var uid = AdminBaseController.adminData.uid ?? '';
      final stripeCustomer = StripeCustomer(uid, email);
      // _baseController.showProgress();
      var myModel = AdminBaseController.adminData;
      log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Admin Id : ${myModel.name}');
      log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Admin Id : ${myModel.customerId}');
      var cusId = myModel.customerId ?? '';
      log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CustomerID^^^^^^^^^^^^ : $cusId');

      if (cusId.isEmpty) {
        var customer = await stripeCustomer.getCustomer();
        cusId = customer['id'];
        log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CustomerID : $cusId');
        myModel.customerId = cusId;
        AdminBaseController.updateAdmin(myModel);
        await FirebaseFirestore.instance
            .collection(UserModel.tableName)
            .doc(myModel.uid)
            .update({'customerId': cusId});
      }
      var card = StripeCard(cusId);
      var list = await card.getMyCards();
      _baseController.hideProgress();
      log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^${list['data']}');
      if (list['data']?.isEmpty ?? true) {
        var stripePayment = StripeSetupIntent(cusId);
        stripePayment.makeDefaultCard();
      }
    } catch (e) {
      _baseController.hideProgress();
      showOkAlertDialog(
          context: Get.context!, message: e.toString(), title: "Error");
    }
  }
}
