import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stripe_method/screens/home_screen/home_screen_controller.dart';
import 'package:stripe_method/services/stripe_services.dart';
import 'package:stripe_method/utilities/admin_base_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: Get.width,
          child: GetBuilder<HomeScreenController>(builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              controller.goBack();
                            },
                            child: const Icon(Icons.arrow_back_ios)),
                        GestureDetector(
                            onTap: () {
                              controller.goToSettingsScreen();
                            },
                            child: const Icon(Icons.settings)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    child: Text.rich(
                      TextSpan(
                          text: 'Name : ',
                          children: [
                            TextSpan(
                                text: AdminBaseController.adminData.name,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400))
                          ],
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Align(
                      alignment: Alignment.center, child: Text('Home Screen')),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.green)),
                        onPressed: () {
                          // StripeServices.instance.makePayment('50');
                          controller.check();
                        },
                        child: const Text(
                          'Payment',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
