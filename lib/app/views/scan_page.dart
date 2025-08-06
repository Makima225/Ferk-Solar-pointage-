import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_routes.dart';

class ScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Admin', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(child: Text('Page de scan')),
          //
        ],
      ),
    );
  }
}
