import 'dart:convert';
import 'dart:developer';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_method/stripe_keys/stripe_keys.dart';
import 'package:stripe_method/utilities/base_controller.dart';

const baseUrl = 'https://api.stripe.com';

class StripeServices {
  StripeServices._();

  Map<String, dynamic>? paymentIntent;
  static final StripeServices instance = StripeServices._();

  makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'usd');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              merchantDisplayName: 'E-Commerce'));
      await displayPaymentSheet();
    } catch (e) {
      showOkAlertDialog(
          context: Get.context!, title: 'Error', message: e.toString());
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      final Map<String, dynamic> body = {
        'amount': calculatedAmount(amount),
        'currency': currency
      };
      final response = await http
          .post(Uri.parse("$baseUrl/v1/payment_intents"), body: body, headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': "application/x-www-form-urlencoded"
      });
      var data = jsonDecode(response.body);
      return data;
    } catch (e) {
      showOkAlertDialog(
          context: Get.context!, title: 'Error', message: e.toString());
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then(
        (value) {
          showDialog(
              context: Get.context!,
              builder: (_) => const AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 100.0,
                        ),
                        SizedBox(height: 10.0),
                        Text("Payment Successful!"),
                      ],
                    ),
                  ));
        },
      ).onError(
        (error, stackTrace) {
          print('Error ------> $error');
          throw Exception('Transaction failed');
        },
      );
    } on StripeException catch (e) {
      print('Error ----> $e');
      const AlertDialog(
        content: Column(
          children: [
            Icon(
              Icons.cancel,
              size: 100,
            ),
            SizedBox(height: 10),
            Text('Transaction failed!')
          ],
        ),
      );
    }
  }

  String calculatedAmount(String amount) {
    var calculatedAmount = int.parse(amount) * 100;
    return calculatedAmount.toString();
  }
}

class StripeSetupIntent extends GetConnect implements GetxService {
  Map<String, dynamic>? _setupIntent;
  final String _customerId;

  StripeSetupIntent(this._customerId);

  final BaseController _baseController = BaseController(Get.context!, () {});

  Future<void> makeDefaultCard() async {
    try {
      //STEP 1: Create Payment Intent
      _baseController.showProgress();
      _setupIntent = await createSetupIntent(_customerId);
      _baseController.hideProgress();
      log('PaymentIntent>>>$_setupIntent');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Stripe',
          setupIntentClientSecret: _setupIntent!['client_secret'],
          customerId: _setupIntent!['customer'],
          style: ThemeMode.light,
          billingDetailsCollectionConfiguration:
              const BillingDetailsCollectionConfiguration(
                  attachDefaultsToPaymentMethod: true),
        ),
      );
      await Stripe.instance.presentPaymentSheet();
    } catch (err) {
      _baseController.hideProgress();
      throw Exception(err);
    }
  }

  createSetupIntent(String customerId) async {
    try {
      final body = {'customer': customerId, 'usage': 'off_session'}
          .entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');

      var response = await post(
        '$baseUrl/v1/setup_intents',
        body,
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      return _checkResult(response);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> displaySetupSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: Get.context!,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }
}

class StripeCustomer extends GetConnect implements GetxService {
  final String _uid;
  final String _email;

  StripeCustomer(this._uid, this._email);

  Future<dynamic> getCustomer() async {
    List<dynamic>? existing = await _existingCustomer();
    if (existing?.isNotEmpty ?? false) {
      return existing?.first;
    }

    dynamic newCus = await _createCustomer();

    return newCus;
  }

  Future<dynamic> _existingCustomer() async {
    final queryParameter = {'query': "email\"$_email\""};

    // Make the payment request
    final response = await get(
      '$baseUrl/v1/customers/search',
      query: queryParameter,
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );
    if (response.isOk) {
      return _checkResult(response)['data'] as List<dynamic>;
    }
    return null;
  }

  Future<dynamic> _createCustomer() async {
    var requestBody = {'email': _email};
    var metaData = {'uid': _uid};

    try {
      final response = await post(
        '$baseUrl/v1/customers',
        _encodeData(requestBody, metaData),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );

      return _checkResult(response);
    } catch (e) {
      rethrow;
    }
  }
}

class StripeCard extends GetConnect implements GetxService {
  final String customerId;

  StripeCard(this.customerId);

  Future<dynamic> getMyCards() async {
    var response = await get(
      '$baseUrl/v1/customers/$customerId/payment_methods',
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$secretKey:'))}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );
    return _checkResult(response);
  }
}

dynamic _checkResult(dynamic response) {
  switch (response.statusCode) {
    case 200:
      {
        var data = response.body;
        if (kDebugMode) {
          print(data);
        }
        return data;
      }
    case 400:
      throw 'Bad Request \n The request was unacceptable, often due to missing a required parameter.>>${response.body}';
    case 401:
      throw 'Unauthorized \nNo valid API key provided.';
    case 402:
      throw 'Request Failed\nThe parameters were valid but the request failed.>>${response.body}';
    case 403:
      throw 'Forbidden\nThe API key doesn’t have permissions to perform the request.>>>>${response.body}';
    case 404:
      throw 'Not Found\nThe requested resource doesn’t exist.>>>${response.body}';
    case 409:
      throw 'Conflict\nThe request conflicts with another request (perhaps due to using the same idempotent key).';
    case 429:
      throw 'Too Many Requests\nToo many requests hit the API too quickly. We recommend an exponential backoff of your requests.';
    case 500 || 502 || 503 || 504:
      throw 'Server Errors\nSomething went wrong on Stripe’s end. (These are rare.)';
    default:
      throw 'Status Code:${response.statusCode}\n${response.body}';
  }
}

dynamic _encodeData(Map<String, dynamic> data, Map<String, dynamic> metadata,
    {String? keyValue}) {
  var encodedBody = data.entries.map((entry) {
    return '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value.toString())}';
  }).join('&');
  metadata.forEach((key, value) {
    encodedBody +=
        '&${keyValue ?? 'metadata'}[${Uri.encodeQueryComponent(key)}]=${Uri.encodeQueryComponent(value)}';
  });

  return encodedBody;
}
