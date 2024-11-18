import 'dart:developer';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stripe_method/screens/card_settings/card_settings_controller.dart';

class CardListScreen extends StatelessWidget {
  final CardSettingsController controller = Get.put(CardSettingsController());

  CardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cards List"),
      ),
      body: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              controller.addNewCard();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Add Card',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ),
          GetBuilder<CardSettingsController>(
            builder: (controller) {
              if (controller.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              }
              if (controller.cardsList.isEmpty) {
                return const Center(
                  child: Text("No cards found."),
                );
              }
              return Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.cardsList.length,
                        itemBuilder: (context, index) {
                          var card = controller.cardsList[index];
                          var cardDetails = card['card'];
                          log('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ID ${card['id']}');
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.setSelectedCardAsDefault(
                                            card['id']);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: card['id'] ==
                                                  controller
                                                      .defaultPaymentMethodId
                                              ? Colors.green
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: card['id'] ==
                                                    controller
                                                        .defaultPaymentMethodId
                                                ? Colors.green
                                                : Colors.black,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${cardDetails['brand']} **** **** **** ${cardDetails['last4']}',
                                              style: TextStyle(
                                                  color: card['id'] ==
                                                          controller
                                                              .defaultPaymentMethodId
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => card['id'] !=
                                              controller.defaultPaymentMethodId
                                          ? controller.deleteMethod(card['id'])
                                          : showOkAlertDialog(
                                              context: Get.context!,
                                              title: 'Error',
                                              message:
                                                  'You cannot delete the card,which is selected as default for future payment.'),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
