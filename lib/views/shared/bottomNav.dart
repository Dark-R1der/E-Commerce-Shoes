import 'package:ecommerce/controllers/mainScreenProvider.dart';
import 'package:ecommerce/views/shared/appStyle.dart';
import 'package:ecommerce/views/shared/bottomNavWidget.dart';
import 'package:ecommerce/views/ui/cartPage.dart';
import 'package:ecommerce/views/ui/homePage.dart';
import 'package:ecommerce/views/ui/profile.dart';
import 'package:ecommerce/views/ui/searchPage.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class BottomNavButton extends StatelessWidget {
  const BottomNavButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifer>(
        builder: (context, mainScreenNotifier, child) {
      return SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BottomNavWidget(
                onTap: () {
                  mainScreenNotifier.pageIndex = 0;
                },
                icon: mainScreenNotifier.pageIndex == 0
                    ? Ionicons.home
                    : Ionicons.home_outline,
              ),
              BottomNavWidget(
                onTap: () {
                  mainScreenNotifier.pageIndex = 1;
                },
                icon: Ionicons.search,
              ),
              BottomNavWidget(
                onTap: () {
                  mainScreenNotifier.pageIndex = 2;
                },
                icon: mainScreenNotifier.pageIndex == 0
                    ? Ionicons.add
                    : Ionicons.add_circle_outline,
              ),
              BottomNavWidget(
                onTap: () {
                  mainScreenNotifier.pageIndex = 3;
                },
                icon: mainScreenNotifier.pageIndex == 0
                    ? Ionicons.cart
                    : Ionicons.cart_outline,
              ),
              BottomNavWidget(
                onTap: () {
                  mainScreenNotifier.pageIndex = 4;
                },
                icon: mainScreenNotifier.pageIndex == 0
                    ? Ionicons.person
                    : Ionicons.person_outline,
              )
            ],
          ),
        ),
      ));
    });
  }
}
