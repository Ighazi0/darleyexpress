import 'dart:convert';
import 'package:darleyexpress/controller/auth_controller.dart';
import 'package:darleyexpress/controller/user_controller.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/models/order_model.dart';
import 'package:darleyexpress/models/payment_model.dart';
import 'package:darleyexpress/views/screens/order_details.dart';
import 'package:darleyexpress/views/widgets/web_viewer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darleyexpress/models/cart_model.dart';
import 'package:darleyexpress/models/coupon_model.dart';
import 'package:darleyexpress/views/screens/product_details.dart';
import 'package:darleyexpress/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool makeOrder = false, loading = false;
  CouponModel couponData = CouponModel();
  TextEditingController code = TextEditingController();
  String invoiceID = '';
  var auth = Get.find<AuthController>(),
      userController = Get.find<UserController>();

  makePayment() async {
    try {
      var response = await http.post(
          Uri.parse('https://uae.paymob.com/api/auth/tokens'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"username": "522820783", "password": "Dara@1991"}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = PaymentModel.fromMap(jsonDecode(response.body));
        try {
          var request = await http.post(
              Uri.parse('https://uae.paymob.com/api/ecommerce/payment-links'),
              headers: {
                'Accept': 'application/json',
                'Accept-Language': 'en-US,en;q=0.9',
                'Authorization': 'Bearer ${data.token}',
                'Connection': 'keep-alive',
                'Cookie':
                    'AMP_MKTG_af23be78b2=JTdCJTdE; _gid=GA1.2.2131766413.1721143897; _fbp=fb.1.1721143900133.95550378118316238; _clck=yntgz3%7C2%7Cfni%7C0%7C1658; _ga_01BZKJP1C9=GS1.1.1721144088.1.1.1721145052.0.0.0; _clsk=x3dvbe%7C1721145172079%7C2%7C1%7Cp.clarity.ms%2Fcollect; _ga_49H896WYTE=GS1.1.1721143901.1.1.1721145198.32.0.0; _gcl_au=1.1.2077339761.1721143897.1067892984.1721145323.1721145400; _ga_4KK5EDXW9S=GS1.1.1721143897.1.1.1721145405.60.0.0; _gat_gtag_UA_118965717_3=1; _gat_gtag_UA_118965717_6=1; _ga=GA1.1.1301856706.1721143897; _ga_GNFEWL2DL0=GS1.1.1721143900.1.1.1721145405.60.0.0; cto_bundle=J0grs18xNnhDJTJCVkxxcThLajBGJTJCJTJCTlE4eDhzQXBGZjN0WklzSHNibFVxNDhxVnhkUiUyQmpGMnlsNkklMkZxbXZCYVF6M1RoQko3Z0R2N3JYaUVhRlclMkYzTlQlMkZjbTlGa2ZFVWNybWRQU0dCZ01QRmFzaUQwNEdqZnp6aDl3T2xDeXByV09OaVBHRWtzMHpUQTZsS1VNRlhIN1JiNG9JbHY4U25KazR3MkJxNUxaOG85Y0RuZFklMkJta0xONUdJVmh6bHI3NGRudENDT3R1S3FkJTJCc2wxZ2dvSUZCU0JpUHVRJTNEJTNE; AMP_af23be78b2=JTdCJTIyZGV2aWNlSWQlMjIlM0ElMjJlMmFmZWM0Yi1kOTdkLTRiOWMtOGMzZS0xOTU1NjRiNzU2ZTAlMjIlMkMlMjJzZXNzaW9uSWQlMjIlM0ExNzIxMTQzODk3MTE3JTJDJTIyb3B0T3V0JTIyJTNBZmFsc2UlMkMlMjJsYXN0RXZlbnRUaW1lJTIyJTNBMTcyMTE0NTQyMjQzMSUyQyUyMmxhc3RFdmVudElkJTIyJTNBNTglMkMlMjJwYWdlQ291bnRlciUyMiUzQTIzJTdE; _ga_J0QEYYKMTC=GS1.1.1721143897.1.1.1721145422.24.0.0',
                'Origin': 'https://uae.paymob.com',
                'Referer': 'https://uae.paymob.com/portal2/en/new-payment-link',
                'Sec-Fetch-Dest': 'empty',
                'Sec-Fetch-Mode': 'cors',
                'Sec-Fetch-Site': 'same-origin',
                'User-Agent':
                    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36',
                'sec-ch-ua':
                    '"Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"',
                'sec-ch-ua-mobile': '?0',
                'sec-ch-ua-platform': '"macOS"'
              },
              body: {
                'amount_cents': '100',
                // (userCubit.totalCartPrice() * 100).toStringAsFixed(2),
                'full_name': auth.userData.name,
                'email': auth.userData.email,
                'phone_number': '+971',
                'payment_methods': '22632',
                'payment_link_image': '',
                'save_selection': 'false',
                'is_live': 'true'
              });

          if (request.statusCode == 200 || request.statusCode == 201) {
            var data2 = PaymentLink.fromJson(jsonDecode(request.body));
            await Get.to(
              () => WebViewer(
                url: data2.clientUrl,
              ),
            );
          } else {}
        } catch (e) {
          //
        }
      } else {}
    } catch (e) {
      //
    }

    // var headers = {
    //   'Accept': 'application/json, text/plain, */*',
    //   'Accept-Language': 'en-US,en;q=0.9',
    //   'Cache-Control': 'no-cache',
    //   'Connection': 'keep-alive',
    //   'Cookie': 'ASP.NET_SessionId=lzepj3eheeitu2yz5azhfcb2',
    //   'Origin': 'https://ipg.comtrust.ae',
    //   'Pragma': 'no-cache',
    //   'Referer': 'https://ipg.comtrust.ae/MerchantEx/eInvoice/Generate',
    //   'Sec-Fetch-Dest': 'empty',
    //   'Sec-Fetch-Mode': 'cors',
    //   'Sec-Fetch-Site': 'same-origin',
    // };
    // var datax = FormData.fromMap({
    //   'data':
    //       '{"Customer":"DARLEYEXPRESSCOMMERC","Store":"0000","Terminal":"0000","OrderID":"${number.toString()}","OrderName":"${auth.userData.name}","OrderInfo":"","Amount":"${userCubit.totalCartPrice()}","PartialPaymentMinAmount":0,"AllowPartialPayment":false,"Currency":"AED","EffectiveStartDateTime":${DateTime.now().toUtc().toIso8601String()},"ExpiryDateTime":"${DateTime.now().add(const Duration(hours: 1)).toUtc().toIso8601String()}","MaxNumberOfInvoices":"","InvoiceType":"Once","CardHolderName":"","CardHolderEmail":"","CardHolderMobile":"","UserName":"DARLEY_Ismail","Password":"Darahaseeb@1991","BatchUploadData":"","MerchantMessage":"","CaptureData":"Auto","RegisterForRecurrence":""}',
    //   'Uploadfile': 'undefined',
    //   'forceProcess': 'false'
    // });

    // var dio = Dio();
    // var response = await dio.request(
    //   'https://ipg.comtrust.ae/MerchantEx/eInvoice/ProcessGenerateEInvoice',
    //   options: Options(
    //     method: 'POST',
    //     headers: headers,
    //   ),
    //   data: datax,
    // );

    // if (response.statusCode == 200) {
    //   setState(() {
    //     url = response.data['InvoiceURL'];
    //     invoiceID = response.data['InvoiceNumber'];
    //   });

    //   if (url.isNotEmpty) {
    //     await Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => WebViewer(
    //             url: url,
    //           ),
    //         ));
    //     return userCubit.done;
    //   } else {
    //     return false;
    //   }
    // } else {
    //   return false;
    // }
  }

  ordering() async {
    var id = DateTime.now(), numbers = 0, done = false;

    QuerySnapshot querySnapshot = await firestore
        .collection('orders')
        .orderBy('number', descending: true)
        .limit(1)
        .get();

    numbers = querySnapshot.docs.first.get('number') + 1;

    await makePayment();

    done = userController.done;

    if (done) {
      userController.changeDone(false);
      Fluttertoast.showToast(msg: 'orderPlaced'.tr);

      for (int i = 0; i < userController.cartList.entries.length; i++) {
        await firestore
            .collection('products')
            .doc(userController.cartList.entries.toList()[i].key)
            .update({
          'stock': FieldValue.increment(
              -userController.cartList.entries.toList()[i].value.count),
          'seller': FieldValue.increment(1)
        });
      }

      var data = {
        'number': numbers + 1,
        'uid': firebaseAuth.currentUser!.uid,
        'total': userController.totalCartPrice(),
        'discount': couponData.discount,
        'delivery': 25,
        'rated': false,
        'status': 'inProgress',
        'name': auth.userData.name,
        'invoice': invoiceID,
        'timestamp': id.toIso8601String(),
        'addressData': {
          'address': auth.userData.address!.first.address,
          'phone': auth.userData.address!.first.phone,
          'label': auth.userData.address!.first.label,
          'name': auth.userData.address!.first.name,
        },
        // 'walletData': {
        //   'number': CryptLib.instance.encryptPlainTextWithRandomIV(
        //       auth.userData.wallet!.first.number, "number"),
        // },
        'orderList': userController.cartList.entries
            .map((e) => {
                  'id': e.key,
                  'titleEn': e.value.productData!.titleEn,
                  'titleAr': e.value.productData!.titleAr,
                  'price': e.value.productData!.price,
                  'discount': e.value.productData!.discount,
                  'media': [e.value.productData!.media!.first],
                  'count': e.value.count,
                })
            .toList()
      };
      firestore
          .collection('orders')
          .doc(id.millisecondsSinceEpoch.toString())
          .set(data);
      Get.off(
        () => OrderDetails(
            order: OrderModel.fromJson(
                data, id.millisecondsSinceEpoch.toString())),
      );

      userController.clearCart();
    } else {
      Fluttertoast.showToast(msg: 'Payment failed');
      setState(() {
        makeOrder = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
                    offset: const Offset(0, -2),
                  ),
                ],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${'total'.tr}: ${'AED'.tr} ${(userController.totalCartPrice()).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: couponData.id.isNotEmpty
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      if (couponData.id.isNotEmpty)
                        Text(
                          '${'AED'.tr} ${(userController.totalCartPrice() - ((userController.totalCartPrice() * (couponData.discount / 100)) > couponData.max ? couponData.max : (userController.totalCartPrice() * (couponData.discount / 100)))).toStringAsFixed(2)} ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  makeOrder
                      ? const CircularProgressIndicator()
                      : MaterialButton(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          onPressed: () async {
                            if (auth.userData.address!.isNotEmpty) {
                              // if (auth.userData.wallet!.isNotEmpty) {
                              setState(() {
                                makeOrder = true;
                              });

                              await ordering();
                              setState(() {
                                makeOrder = false;
                              });
                              // } else {
                              //   staticWidgets.showBottom(context,
                              //       const BottomSheetPayment(), 0.85, 0.9);
                              // }
                            } else {
                              Fluttertoast.showToast(msg: 'pleaseAddress'.tr);
                            }
                          },
                          height: 45,
                          minWidth: 100,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          color: appConstant.primaryColor,
                          textColor: Colors.white,
                          child: Text('placeOrder'.tr),
                        ),
                ])),
      ),
      appBar: AppBarCustom(
        title: 'CHECKOUT'.tr,
        action: const {},
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'shipping'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            auth.userData.address!.isEmpty
                ? MaterialButton(
                    minWidth: 0,
                    height: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () async {
                      await Navigator.pushNamed(context, 'address');
                      setState(() {});
                    },
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      'addNew'.tr,
                      style:
                          TextStyle(fontSize: 12, color: Colors.amber.shade700),
                    ),
                  )
                : ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.location_on,
                      color: appConstant.primaryColor,
                    ),
                    title: Text(auth.userData.address!.first.name),
                    subtitle: Text(auth.userData.address!.first.address),
                    trailing: MaterialButton(
                      minWidth: 0,
                      height: 25,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      onPressed: () async {
                        await Navigator.pushNamed(context, 'address');
                        setState(() {});
                      },
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        'change'.tr,
                        style: TextStyle(
                            fontSize: 12, color: Colors.amber.shade700),
                      ),
                    ),
                  ),
            const Divider(
              color: Colors.grey,
            ),
            Text(
              'havePromo'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  color: Colors.grey.shade200),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: code,
                      decoration: InputDecoration(
                          hintText: 'promo'.tr,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: loading
                        ? const CircularProgressIndicator()
                        : MaterialButton(
                            textColor: Colors.white,
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });

                              await firestore
                                  .collection('coupons')
                                  .where('code', whereIn: [
                                    code.text.toLowerCase(),
                                    code.text.toUpperCase()
                                  ])
                                  .get()
                                  .then((value) {
                                    if (value.size > 0) {
                                      couponData = CouponModel.fromJson(
                                          value.docs.first.data());

                                      if (couponData.endTime!
                                          .isBefore(DateTime.now())) {
                                        Fluttertoast.showToast(
                                            msg: 'expired'.tr);
                                        couponData = CouponModel();
                                      }
                                    } else {
                                      couponData = CouponModel();
                                      Fluttertoast.showToast(msg: 'noCode'.tr);
                                    }
                                  });
                              setState(() {
                                loading = false;
                              });
                            },
                            color: appConstant.primaryColor,
                            height: 40,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Text('apply'.tr),
                          ),
                  )
                ],
              ),
            ),
            if (couponData.id.isNotEmpty)
              ListTile(
                title: Text(couponData.titleEn),
                trailing: Text('${couponData.discount}%'),
                subtitle: Text(
                    '${'upTo'.tr} ${couponData.max.toStringAsFixed(2)} ${'AED'.tr}'),
              ),
            const Divider(
              color: Colors.grey,
            ),
            Text(
              'orderList'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userController.cartList.length,
                itemBuilder: (context, index) {
                  CartModel cart =
                      userController.cartList.values.toList()[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: cart.productData!.media![0],
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetails(product: cart.productData!),
                          ));
                    },
                    title: Text(
                      cart.productData!.titleEn,
                      overflow: TextOverflow.ellipsis,
                    ),
                    visualDensity: const VisualDensity(vertical: 4),
                    subtitle: Text(
                      '${'AED'.tr} ${cart.productData!.price}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
