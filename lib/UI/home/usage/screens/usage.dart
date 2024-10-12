import 'package:flutter/material.dart';

class UsageScreen extends StatelessWidget {
  static const routeName = "usagescreen";
  const UsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Usage",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 320,
            width: double.infinity,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
