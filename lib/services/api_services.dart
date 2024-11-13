import 'package:get/get.dart';
import 'package:stripe_method/services/stripe_services.dart';

import '../utilities/admin_base_controller.dart';

class ApiServices {
  static Future<List<dynamic>> getCardList() async {
    var myCustomerId = AdminBaseController.adminData.customerId;
    try {
      var response = await GetConnect()
          .get('$baseUrl/customer-cards', query: {'customerId': myCustomerId});
      if (response.isOk) {
        return (response.body ?? []) as List<dynamic>;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}
