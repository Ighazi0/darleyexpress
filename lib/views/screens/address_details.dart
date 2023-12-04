// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/models/user_model.dart';
import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:darleyexpress/views/widgets/app_bar.dart';
import 'package:darleyexpress/views/widgets/edit_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddressDetails extends StatefulWidget {
  const AddressDetails({super.key, required this.address, required this.index});
  final AddressModel address;
  final int index;
  @override
  State<AddressDetails> createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  String label = 'home';
  bool loading = false;
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController name = TextEditingController(),
      phone = TextEditingController(),
      address = TextEditingController();

  submit(delete) async {
    if (!key.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });

    if (delete) {
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'address': FieldValue.arrayRemove([
          {
            'name': widget.address.name,
            'phone': widget.address.phone,
            'address': widget.address.address,
            'label': widget.address.label
          }
        ])
      });
    } else {
      var e = auth.userData.address;
      if (widget.address.label.isNotEmpty) {
        e!.removeAt(widget.index);
        e.insert(
            widget.index,
            AddressModel(
                name: name.text,
                address: address.text,
                label: label,
                phone: phone.text));

        await firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'address': e.map((e) => {
                'name': e.name,
                'address': e.address,
                'label': e.label,
                'phone': e.phone,
              })
        });
      } else {
        await firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'address': FieldValue.arrayUnion([
            {
              'name': name.text,
              'address': address.text,
              'label': label,
              'phone': widget.address.phone,
            }
          ])
        });
      }
    }
    await auth.getUserData();
    setState(() {
      loading = false;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    if (widget.address.label.isNotEmpty) {
      label = widget.address.label;
      address.text = widget.address.address;
      phone.text = widget.address.phone;
      name.text = widget.address.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
          title: widget.address.name,
          action: {
            'icon': widget.address.label.isNotEmpty ? Icons.edit : Icons.add,
            'function': () {
              submit(false);
            },
          },
          loading: loading),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: key,
          child: Column(children: [
            const Text('Address label'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      label = 'home';
                    });
                  },
                  child: Chip(
                    side: const BorderSide(color: Colors.grey),
                    label: const Text(
                      'home',
                    ),
                    backgroundColor:
                        label == 'home' ? Colors.amber.shade200 : Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      label = 'work';
                    });
                  },
                  child: Chip(
                    side: const BorderSide(color: Colors.grey),
                    label: const Text('work'),
                    backgroundColor:
                        label == 'work' ? Colors.amber.shade200 : Colors.white,
                  ),
                ),
              ],
            ),
            EditText(
                function: () {},
                controller: name,
                validator: (p) {
                  if (p!.isEmpty) {
                    return 'Please enter address name';
                  }
                  return null;
                },
                hint: 'My home',
                title: 'Address name'),
            EditText(
                function: () {},
                controller: address,
                validator: (p) {
                  if (p!.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                hint: '',
                title: 'Address'),
            EditText(
                function: () {},
                number: true,
                controller: phone,
                validator: (p) {
                  if (p!.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                hint: '009',
                title: 'Phone'),
            if (widget.address.label.isNotEmpty && !loading)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.index != 0)
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          var e = auth.userData.address;

                          e!.removeAt(widget.index);
                          e.insert(
                              0,
                              AddressModel(
                                  name: widget.address.name,
                                  address: widget.address.address,
                                  label: widget.address.label,
                                  phone: widget.address.phone));

                          await firestore
                              .collection('users')
                              .doc(firebaseAuth.currentUser!.uid)
                              .update({
                            'address': e.map((e) => {
                                  'name': e.name,
                                  'address': e.address,
                                  'label': e.label,
                                  'phone': e.phone,
                                })
                          });
                          await auth.getUserData();

                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Make it default',
                          style: TextStyle(color: Colors.black),
                        )),
                  TextButton(
                      onPressed: () {
                        submit(true);
                      },
                      child: const Text(
                        'Delete Address',
                        style: TextStyle(color: Colors.red),
                      )),
                ],
              ),
          ]),
        ),
      ),
    );
  }
}
