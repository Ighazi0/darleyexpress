import 'package:darleyexpress/get_initial.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  String locale = 'ar';

  String getSavedLanguage() {
    final cachedLanguageCode = getStorage.read('locale');

    if (cachedLanguageCode != null) {
      return cachedLanguageCode;
    } else {
      return 'ar';
    }
  }

  void changeLanguage(String languageCode) {
    getStorage.write('locale', languageCode);
    Get.updateLocale(Locale(languageCode));
    locale = languageCode;

    update();
  }
}
