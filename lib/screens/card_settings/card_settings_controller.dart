import 'dart:convert';
import 'dart:developer';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stripe_method/models/user_model.dart';
import 'package:stripe_method/services/api_services.dart';
import 'package:stripe_method/services/stripe_services.dart';
import 'package:stripe_method/utilities/admin_base_controller.dart';
import 'package:http/http.dart' as http;

import '../../stripe_keys/stripe_keys.dart';

class CardSettingsController extends GetxController {
  List<dynamic> cardsList = [];
  String defaultPaymentMethodId = '';
  bool isLoading = false;

  loadList() async {
    isLoading = true;
    update();
    try {
      var list = await ApiServices.getCardList();
      log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ List length ${list["data"]}');
      cardsList = list["data"];
      log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Length ${cardsList.length}');
      // defaultPaymentMethodId =
      //     cardsList.isNotEmpty ? cardsList.first['id'] : '';
      // for (var card in cardsList) {
      //   var cardId = card['id'];
      //   log('Card ID: $cardId');
      // }
      //
      // log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Default Payment Method ID: $defaultPaymentMethodId');
      // defaultPaymentMethodId =
      //     cardsList.where((e) => e['isDefault']).toList().firstOrNull?['id'] ??
      //         '';
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
    getCustomerDetails();
    super.onInit();
  }

  void setSelectedCardAsDefault(String cardId) async {
    log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Function Called');
    try {
      isLoading = true;
      update();
      var success = await ApiServices.setCardAsDefault(cardId);
      if (success) {
        defaultPaymentMethodId = cardId;
        log('^^^^^^^^^^^^^^^^ Successfully updated the default payment method to: $defaultPaymentMethodId');
        Get.snackbar('Success', 'Default payment method updated successfully!');
        update();
      } else {
        log('Failed to update the default payment method');
        await showOkAlertDialog(
          context: Get.context!,
          title: 'Error',
          message: 'Failed to update the default payment method.',
        );
      }
    } catch (e) {
      log('Error updating default payment method: $e');
      await showOkAlertDialog(
        context: Get.context!,
        title: 'Error',
        message: 'An error occurred while updating the default payment method.',
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  void deleteMethod(String paymentId) async {
    log('^^^^^^^^^^^^^^^^^^^^^^^^^^ Delete Method called ');
    var result = await showOkCancelAlertDialog(
      context: Get.context!,
      title: 'Are you sure!',
      message: 'Do you really want to delete the card?',
      cancelLabel: 'Cancel',
      okLabel: 'Yes',
      isDestructiveAction: true,
    );
    if (result == OkCancelResult.cancel) return;
    try {
      isLoading = true;
      update();
      var isDeleted = await ApiServices.deleteCard(paymentId);
      if (isDeleted) {
        cardsList.removeWhere((element) => element['id'] == paymentId);
        Get.snackbar('Deleted', 'Card deleted Successfully');
        isLoading = false;
        update();
      } else {
        Get.snackbar('No Deleted', 'Card is not deleted');
      }
    } catch (e) {
      isLoading = false;
      update();
      if (kDebugMode) {
        print('Delete error occurred : ${e.toString()}');
      }
    }
  }

  void getCustomerDetails() async {
    final customerId = AdminBaseController.adminData.customerId;
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/v1/customers/$customerId'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      if (response.statusCode == 200) {
        final customerData = jsonDecode(response.body);
        defaultPaymentMethodId =
            customerData['invoice_settings']['default_payment_method'];
        log('^^^^^^^^^^^^^^^^^^^^^^^^^^ customer details $customerData');
        log('^^^^^^^^^^^^^^^^^^^^^^^^^^ customer default card Id  $defaultPaymentMethodId');
      } else {
        log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Error occurred in getting details');
      }
    } catch (e) {
      if (kDebugMode) {
        log('^^^^^^^^^^^^^^^^ Error in getting details${e.toString()}');
      }
    }
  }
}
