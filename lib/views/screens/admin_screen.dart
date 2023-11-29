import 'package:darleyexpress/views/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Drawer(child: AdminDrawer()),
        appBar: AppBar(
          title: const Text('Admin'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: const [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Users:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '0',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Orders:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '0',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

class PieChartData {
  final String category;
  final double value;

  PieChartData(this.category, this.value);
}