import 'dart:convert';

import 'package:dio/dio.dart';

class StaticFunctions {
  Future<String> generateLink(String id, String route) async {
    const apiUrl =
        'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyCX3DS4w1tdKUKlDaya86rwqhwbb7cDPcA';

    final dynamicLinkData = {
      'dynamicLinkInfo': {
        'domainUriPrefix': 'https://darleyexpress.page.link',
        'link': 'https://www.darleyexpress.com?screen=/$route/$id',
        'androidInfo': {
          'androidPackageName': 'com.comma.darleyexpress',
        },
        'iosInfo': {
          'iosBundleId': 'com.comma.darleyexpress',
        },
      },
      'suffix': {
        'option': 'SHORT',
      },
    };
    var shortUrl = '';

    final respo = await Dio().post(
      apiUrl,
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: json.encode(dynamicLinkData),
    );

    shortUrl = respo.data['shortLink'];

    return shortUrl;
  }
}
