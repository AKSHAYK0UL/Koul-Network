import 'dart:async';
import 'package:flutter/material.dart';

class CounterTimer extends StatefulWidget {
  const CounterTimer({super.key});

  @override
  State<CounterTimer> createState() => _CounterTimerState();
}

class _CounterTimerState extends State<CounterTimer> {
  int timeValue = 120;
  Timer? timer;
  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  void counterValue() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (timeValue >= 1) {
          timeValue -= 1;
        } else {
          timer!.cancel();
          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    counterValue();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "verification code will expire in ",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          TextSpan(
            text: "$timeValue",
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    );
  }
}
