import 'package:ecommerce/controllers/mainScreenProvider.dart';
import 'package:ecommerce/views/shared/appStyle.dart';
import 'package:ecommerce/views/shared/bottomNav.dart';
import 'package:ecommerce/views/shared/bottomNavWidget.dart';
import 'package:ecommerce/views/ui/cartPage.dart';
import 'package:ecommerce/views/ui/homePage.dart';
import 'package:ecommerce/views/ui/productByCard.dart';
import 'package:ecommerce/views/ui/profile.dart';
import 'package:ecommerce/views/ui/searchPage.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  List<Widget> pageList = [
    HomePage(),
    SearchPage(),
    ProductByCard(),
    CartPage(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    // int pageIndex = 1;
    return Consumer<MainScreenNotifer>(
      builder: (context, mainScreenNotifier, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE2E2E2),
          body: pageList[mainScreenNotifier.pageIndex],
          bottomNavigationBar: BottomNavButton(),
        );
      },
    );
  }
}
