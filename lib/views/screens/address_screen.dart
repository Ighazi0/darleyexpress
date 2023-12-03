import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:darleyexpress/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Address',
        action: {'icon': Icons.add, 'function': () {}},
      ),
      body: ListView.builder(
          itemCount: auth.userData.address!.length,
          itemBuilder: (context, index) {
            var e = auth.userData.address![index];
            return Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(e['label']),
                      if (index == 0) Text('Default')
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('name'),
                      Text(e['name']),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Address'),
                      Text(e['address']),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
