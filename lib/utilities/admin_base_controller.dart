import 'package:get/get.dart';

import '../models/user_model.dart';

class AdminBaseController extends GetxController {
  var userModel = UserModel();

  static void updateAdmin(UserModel adminModel) {
    var adminController = Get.put(AdminBaseController(), permanent: true);
    adminController.userModel = adminModel;
    adminController.update();
  }

  static UserModel get adminData {
    return Get.put(AdminBaseController(), permanent: true).userModel;
  }
}
