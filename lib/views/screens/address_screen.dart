import 'package:darleyexpress/controller/auth_controller.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/models/user_model.dart';
import 'package:darleyexpress/views/screens/address_details.dart';
import 'package:darleyexpress/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  var auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'address'.tr,
        action: {
          'icon': Icons.add,
          'function': () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressDetails(
                    address: AddressModel(name: 'newAddress'.tr),
                    index: 0,
                  ),
                ));
            setState(() {});
          }
        },
      ),
      body: RefreshIndicator(
        color: appConstant.primaryColor,
        onRefresh: () async {
          await auth.getUserData();
          setState(() {});
        },
        child: auth.userData.address!.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty_data.png',
                      height: 150,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'noAddress'.tr,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            : ListView.builder(
                itemCount: auth.userData.address!.length,
                itemBuilder: (context, index) {
                  var e = auth.userData.address![index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddressDetails(
                              address: e,
                              index: index,
                            ),
                          ));
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: appConstant.primaryColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(e.label == 'home' ? Icons.home : Icons.work),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(e.name),
                              const SizedBox(
                                width: 10,
                              ),
                              if (index == 0)
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: appConstant.primaryColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(
                                      'default'.tr,
                                      style: const TextStyle(fontSize: 10),
                                    ))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(e.phone),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('address'.tr),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  e.address,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
