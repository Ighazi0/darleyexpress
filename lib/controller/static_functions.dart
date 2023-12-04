import 'dart:convert';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/models/order_model.dart';
import 'package:darleyexpress/views/screens/order_details.dart';
import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

class StaticFunctions {
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(double total) async {
    String price = total.toStringAsFixed(2).replaceAll('.', '');

    paymentIntent = await createPaymentIntent(price, 'AED');

    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            merchantDisplayName: auth.userData.name,
            customerId: firebaseAuth.currentUser!.uid));

    displayPaymentSheet();
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        userCubit.clearCart();
        Fluttertoast.showToast(msg: 'Order placed');
        var id = DateTime.now().millisecondsSinceEpoch.toString();
        firestore.collection('orders').doc(id).set({id: '', 'timestamp': ''});
        navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
          builder: (context) => OrderDetails(order: OrderModel()),
        ));
      });
    } catch (e) {
      throw 'cancel';
    }
  }

  createPaymentIntent(String amount, String currency) async {
    var response = await Dio().post(
      'https://api.stripe.com/v1/payment_intents',
      options: Options(
        headers: {
          'Authorization':
              'Bearer sk_test_51OJ2BXIgy4HITOKu0xsYZCX7TOlOicfTDA5fVNxgOQhk0178JhN10Ijw30FFQp7EpDBBPaaLyeCMIe6xqoG3bgSX00rBvQ0EVx',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      ),
      data: {
        'amount': amount,
        'currency': currency,
      },
    );

    return response.data;
  }

  shareData(link) {
    Share.share(link);
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
