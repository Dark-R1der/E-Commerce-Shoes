import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/views/shared/appStyle.dart';
import 'package:ecommerce/views/shared/checkOutBtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartPageProduct extends StatelessWidget {
  CartPageProduct({super.key});
  final _cartBox = Hive.box('cart_box');
  @override
  Widget build(BuildContext context) {
    List<dynamic> cart = [];
    final cartData = _cartBox.keys.map((key) {
      final item = _cartBox.get(key);
      return {
        "key": key,
        "id": item['id'],
        "category": item["category"],
        "name": item["name"],
        "imageUrl": item["imageUrl"],
        "price": item["price"],
        "qty": item["qty"],
        "sizes": item["size"],
      };
    }).toList();

    cart = cartData.reversed.toList();
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    AntDesign.close,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "My Cart",
                  style: appStyle(36, Colors.black, FontWeight.bold),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: ListView.builder(
                      itemCount: cart.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: ((context, index) {
                        final data = cart[index];
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Slidable(
                                key: const ValueKey(0),
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      flex: 1,
                                      onPressed: null,
                                      backgroundColor: Color(0xFF0000000),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    )
                                  ],
                                ),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.11,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade500,
                                        spreadRadius: 5,
                                        blurRadius: 0.3,
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(12),
                                            child: CachedNetworkImage(
                                              imageUrl: data['imageUrl'],
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 12, left: 20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data["name"],
                                                  style: appStyle(
                                                      16,
                                                      Colors.black,
                                                      FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data["category"],
                                                  style: appStyle(
                                                    14,
                                                    Colors.grey,
                                                    FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      data["price"],
                                                      style: appStyle(
                                                          18,
                                                          Colors.black,
                                                          FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      width: 40,
                                                    ),
                                                    Text(
                                                      "Size",
                                                      style: appStyle(
                                                          18,
                                                          Colors.black,
                                                          FontWeight.w600),
                                                    ),
                                                    Text(
                                                      "${data["sizes"]}",
                                                      style: appStyle(
                                                          18,
                                                          Colors.black,
                                                          FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16)),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {},
                                                    child: const Icon(
                                                      AntDesign.minussquare,
                                                      size: 20,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(
                                                    data['qty'].toString(),
                                                    style: appStyle(
                                                      16,
                                                      Colors.black,
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                  InkWell(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        AntDesign.plussquare,
                                                        size: 20,
                                                        color: Colors.black,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        );
                      })),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CheckOutButton(label: "Proceed to Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}
