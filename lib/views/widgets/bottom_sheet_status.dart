import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/controller/user_controller.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetStatus extends StatefulWidget {
  const BottomSheetStatus({super.key, required this.order});
  final OrderModel order;

  @override
  State<BottomSheetStatus> createState() => _BottomSheetStatusState();
}

class _BottomSheetStatusState extends State<BottomSheetStatus> {
  update(x) async {
    firestore.collection('orders').doc(widget.order.id).update({'status': x});
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserController(),
      builder: (userCubit) {
        return ListView(
          controller: staticWidgets.scrollController,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                'Update status order',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (widget.order.status == 'inProgress')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    minWidth: 100,
                    height: 40,
                    onPressed: () async {
                      update('cancel');
                    },
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    color: Colors.grey.shade400,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  MaterialButton(
                    minWidth: 100,
                    height: 40,
                    onPressed: () async {
                      update('inDelivery');
                    },
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    color: appConstant.primaryColor,
                    child: const Text(
                      'To delivery',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            if (widget.order.status == 'inDelivery')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    minWidth: 100,
                    height: 40,
                    onPressed: () async {
                      update('cancel');
                    },
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    color: Colors.grey.shade400,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  MaterialButton(
                    minWidth: 100,
                    height: 40,
                    onPressed: () async {
                      update('complete');
                    },
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    color: appConstant.primaryColor,
                    child: const Text(
                      'Complete',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            if (widget.order.status == 'cancel')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    minWidth: 100,
                    height: 40,
                    onPressed: () async {
                      update('inDelivery');
                    },
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    color: Colors.grey.shade400,
                    child: const Text(
                      'To delivery',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  MaterialButton(
                    minWidth: 100,
                    height: 40,
                    onPressed: () async {
                      update('complete');
                    },
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    color: appConstant.primaryColor,
                    child: const Text(
                      'Complete',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
