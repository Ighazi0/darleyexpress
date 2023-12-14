import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class StaticFunctions {
  Map<String, dynamic>? paymentIntent;

  // Future<void> makePayment(double total, ordering) async {
  //   String price = total.toStringAsFixed(2).replaceAll('.', '');

  //   paymentIntent = await createPaymentIntent(price, 'AED');

  //   await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //           paymentIntentClientSecret: paymentIntent!['client_secret'],
  //           merchantDisplayName: auth.userData.name,
  //           customerId: firebaseAuth.currentUser!.uid));

  //   displayPaymentSheet(ordering);
  // }

  // displayPaymentSheet(ordering) async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       ordering();
  //     });
  //   } catch (e) {
  //     throw 'cancel';
  //   }
  // }

  // createPaymentIntent(String amount, String currency) async {
  //   var response = await Dio().post(
  //     'https://api.stripe.com/v1/payment_intents',
  //     options: Options(
  //       headers: {
  //         'Authorization':
  //             'Bearer sk_test_51OJ2BXIgy4HITOKu0xsYZCX7TOlOicfTDA5fVNxgOQhk0178JhN10Ijw30FFQp7EpDBBPaaLyeCMIe6xqoG3bgSX00rBvQ0EVx',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //     ),
  //     data: {
  //       'amount': amount,
  //       'currency': currency,
  //     },
  //   );

  //   return response.data;
  // }

  shareData(link) {
    Share.share(link);
  }

  urlLauncher(Uri uri) async {
    await launchUrl(uri);
  }

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
