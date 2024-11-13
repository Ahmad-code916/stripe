import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//**************************************************
class BaseController //**************************************************
    {
  final BuildContext? _context;
  BuildContext? dialogContext;
  Function? onStateChange;
  static bool isAlreadyShow = false;

  //**************************************************
  BaseController(this._context, this.onStateChange);

  //**************************************************

  //**************************************************
  void dismissKeyBoard()
  //**************************************************
  {
    FocusScope.of(_context!).requestFocus(FocusNode());
  }

  //**************************************************
  void showProgress()
  //**************************************************
  {
    if (isAlreadyShow) {
      return;
    }
    isAlreadyShow = true;
    showDialog(
        barrierColor: Colors.transparent,
        context: _context!,
        barrierDismissible: false,
        builder: (context) {
          dialogContext = context;
          return const NativeProgress();
        });
  }

  //**************************************************
  void hideProgress()
  //**************************************************
  {
    try {
      if (BaseController.isAlreadyShow) {
        BaseController.isAlreadyShow = false;
        Navigator.pop(Get.context!);
      }
      //if (_dialogContext != null) Navigator.pop(_dialogContext!);
    } catch (e) {
      showOkAlertDialog(context: Get.context!,message: e.toString(),title: "Error");
    }
  }
}

class NativeProgress extends StatelessWidget {
  const NativeProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? const Center(
        child: SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              color: Colors.green,
            )))
        : Center(
      child: Theme(
          data: ThemeData(
              cupertinoOverrideTheme: const CupertinoThemeData(
                  brightness: Brightness.light,
                  primaryColor: Colors.white,
                  barBackgroundColor: Colors.white)),
          child: const CupertinoActivityIndicator()),
    );
  }
}
