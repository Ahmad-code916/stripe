import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stripe_method/screens/card_settings/card_settings_controller.dart';

class CardSettings extends StatelessWidget {
  CardSettings({super.key});

  final CardSettingsController controller = Get.put(CardSettingsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
        Scaffold(body: GetBuilder<CardSettingsController>(builder: (context) {
      return SizedBox(
        child: Column(
          children: [
            if (controller.isLoading)
              const Expanded(child: CircularProgressIndicator())
            // else
            // Expanded(
            //     child: Column(
            //   children: [
            //     if (controller.isLoading)
            //       const Expanded(child: CircularProgressIndicator())
            //     else
            //       ...List.generate(controller.cardsList.length + 1, (i) {
            //         if (controller.cardsList.length == i) {
            //           return GestureDetector(
            //             behavior: HitTestBehavior.opaque,
            //             onTap: () {
            //               // controller.addNewCard();
            //             },
            //             child: Row(
            //               children: [
            //                 Container(
            //                   padding: const EdgeInsets.symmetric(
            //                       horizontal: 4, vertical: 2),
            //                   decoration: BoxDecoration(
            //                       color: Colors.green,
            //                       borderRadius: BorderRadius.circular(5)),
            //                   child: const Icon(Icons.add),
            //                 ),
            //                 const SizedBox(width: 10),
            //                 Text(
            //                   'Add Card',
            //                   style: const TextStyle(
            //                       fontSize: 15,
            //                       fontFamily: 'inter',
            //                       fontWeight: FontWeight.w400),
            //                 )
            //               ],
            //             ),
            //           );
            //         }
            //         return Container(
            //           margin: EdgeInsets.only(bottom: 10),
            //           child: Row(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Expanded(
            //                 child: GestureDetector(
            //                   onTap: () {
            //                     controller.defaultPaymentMethodId =
            //                         controller.cardsList[i]['id'];
            //                     controller.update();
            //                   },
            //                   child: Container(
            //                     width: double.infinity,
            //                     padding: const EdgeInsets.all(10),
            //                     decoration: BoxDecoration(
            //                         color: Colors.white,
            //                         borderRadius: BorderRadius.circular(8),
            //                         border: Border.all(color: Colors.grey)),
            //                     child: Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text(
            //                             '${controller.cardsList[i]['brandName']} **** **** **** ${controller.cardsList[i]['last4digits']}',
            //                             style: const TextStyle(
            //                                 fontSize: 15,
            //                                 fontFamily: 'inter',
            //                                 fontWeight: FontWeight.w400)),
            //                         Container(
            //                           height: 20,
            //                           width: 20,
            //                           decoration: BoxDecoration(
            //                             border:
            //                                 Border.all(color: Colors.green),
            //                             borderRadius:
            //                                 BorderRadius.circular(49),
            //                           ),
            //                           child: Padding(
            //                             padding: const EdgeInsets.all(5.0),
            //                             child: Container(
            //                               decoration: BoxDecoration(
            //                                 shape: BoxShape.circle,
            //                                 color: controller.cardsList[i]
            //                                             ['id'] ==
            //                                         controller
            //                                             .defaultPaymentMethodId
            //                                     ? Colors.green
            //                                     : Colors.transparent,
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               /*GestureDetector(
            //                         behavior: HitTestBehavior.opaque,
            //                         onTap:()=> controller.deleteMethod(i),
            //                         child: Icon(Icons.delete,color: AppColors.greySecond,)),*/
            //             ],
            //           ),
            //         );
            //       })
            //   ],
            // )),
            /*Expanded(
                child: ListView.builder(
                  itemCount: controller.cardsList.length,
                  itemBuilder: (context, index) {
                    final data = controller.cardsList[index];
                    return Column(
                      children: [
                        Text('Ahggvksjc;ll'),
                        Text('Card ending in ${data['last4']}'),
                      ],
                    );
                  },
                ),
              )*/
          ],
        ),
      );
    })));
  }
}
