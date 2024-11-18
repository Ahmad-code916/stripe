import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stripe_method/services/stripe_services.dart';
import '../stripe_keys/stripe_keys.dart';
import '../utilities/admin_base_controller.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<dynamic> getCardList() async {
    // var myCustomerId = AdminBaseController.adminData.customerId;
    var customerId = AdminBaseController.adminData.customerId;
    try {
      log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CAlled');
      var response = await GetConnect().get(
        '$baseUrl/v1/customers/$customerId/payment_methods',
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        // query: {'customerId': myCustomerId},
      );
      log("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ${response.body.toString()}");
      if (response.isOk) {
        return (response.body ?? []);
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  static Future<bool> setCardAsDefault(String paymentId) async {
    try {
      final customerId = AdminBaseController.adminData.customerId;
      var response = await http.post(
        Uri.parse('$baseUrl/v1/customers/$customerId'),
        body: {'invoice_settings[default_payment_method]': paymentId},
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      if (response.statusCode == 200) {
        log('^^^^^^^^^^^^^^^^^^^^ Update Successfully ${response.body}');
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Error Occurred ${e.toString()}');
        return false;
      }
    }
    return false;
  }

  static Future<bool> deleteCard(String paymentId) async {
    try {
      var response = await http.post(
        Uri.parse(
          '$baseUrl/v1/payment_methods/$paymentId/detach',
        ),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      if (response.statusCode == 200) {
        log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Dispatched Card successfully ');
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception occurred : ${e.toString()}');
        return false;
      }
    }
    return false;
  }
}
