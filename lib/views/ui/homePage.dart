import 'package:ecommerce/views/shared/appStyle.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text("This is home",
          style: appStyle(40, Colors.black, FontWeight.bold)),
    ));
  }
}
