import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stripe_method/models/user_model.dart';
import 'package:stripe_method/services/api_services.dart';
import 'package:stripe_method/services/stripe_services.dart';
import 'package:stripe_method/utilities/admin_base_controller.dart';

class CardSettingsController extends GetxController {
  List<dynamic> cardsList = [];
  String defaultPaymentMethodId = '';
  bool isLoading = false;

  loadList() async {
    isLoading = true;
    update();
    try {
      var list = await ApiServices.getCardList();
      cardsList = list;
      defaultPaymentMethodId =
          cardsList.where((e) => e['isDefault']).toList().firstOrNull?['id'] ??
              '';
      isLoading = false;
      update();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    isLoading = false;
    update();
  }

  void addNewCard() async {
    var myModel = AdminBaseController.adminData;
    var cusId = myModel.customerId ?? "";
    if (cusId.isEmpty) {
      var email = AdminBaseController.adminData.email ?? "";
      var uid = AdminBaseController.adminData.uid ?? "";
      final stripeCustomer = StripeCustomer(uid, email);
      var customer = await stripeCustomer.getCustomer();
      var cusId = customer['id'];
      myModel.customerId = cusId;
      await FirebaseFirestore.instance
          .collection(UserModel.tableName)
          .doc(myModel.uid)
          .update({'customerId': cusId});
    }
    var stripePayment = StripeSetupIntent(cusId);
    await stripePayment.makeDefaultCard();
    Get.back();
  }

  @override
  void onInit() {
    loadList();
    super.onInit();
  }
}
