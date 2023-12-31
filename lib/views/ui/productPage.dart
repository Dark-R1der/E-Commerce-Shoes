import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/controllers/favoriteProvider.dart';
import 'package:ecommerce/controllers/productProvider.dart';
import 'package:ecommerce/models/constants.dart';
import 'package:ecommerce/models/sneakersModel.dart';
import 'package:ecommerce/service/helper.dart';
import 'package:ecommerce/views/shared/appStyle.dart';
import 'package:ecommerce/views/shared/checkOutBtn.dart';
import 'package:ecommerce/views/ui/favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.id, required this.category});
  final String id;
  final String category;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _cartBox = Hive.box('cart_box');
  final _favBox = Hive.box('fav_box');
  final PageController _pageController = PageController();
  late Future<Sneakers> _sneaker;

  void getShoes() {
    if (widget.category == "Men's Running") {
      _sneaker = Helper().getMaleSneakersById(widget.id);
    } else if (widget.category == "Women's Running") {
      _sneaker = Helper().getFemaleSneakersById(widget.id);
    } else {
      _sneaker = Helper().getKidSneakersById(widget.id);
    }
  }

  Future<void> _createCart(Map<String, dynamic> newCart) async {
    await _cartBox.add(newCart);
  }

  Future<void> _createfav(Map<String, dynamic> addFav) async {
    await _favBox.add(addFav);
    getFavorite();
  }

  getFavorite() {
    final favData = _favBox.keys.map((key) {
      final item = _favBox.get(key);
      return {
        "key": key,
        "id": item['id'],
      };
    }).toList();
    favor = favData.toList();
    ids = favor.map((item) => item['id']).toList();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Sneakers>(
        future: _sneaker,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error ${snapshot.error}");
          } else {
            final sneaker = snapshot.data;
            return Consumer<ProductNotifier>(
              builder: (context, productNotifier, child) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      leadingWidth: 0,
                      title: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                productNotifier.shoeSize.clear();
                              },
                              child: Icon(
                                AntDesign.close,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: null,
                              child: Icon(
                                Ionicons.ellipsis_horizontal,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pinned: true,
                      snap: false,
                      floating: true,
                      backgroundColor: Colors.transparent,
                      expandedHeight: MediaQuery.of(context).size.height,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width,
                              child: PageView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: sneaker!.imageUrl.length,
                                controller: _pageController,
                                onPageChanged: (page) {
                                  productNotifier.activePage = page;
                                },
                                itemBuilder: ((context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.39,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.grey.shade300,
                                        child: CachedNetworkImage(
                                          imageUrl: sneaker.imageUrl[index],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Positioned(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          right: 20,
                                          child: Consumer<FavoritesNotifier>(
                                            builder: (context,
                                                favoritesNotifier, child) {
                                              return GestureDetector(
                                                onTap: () {
                                                  if (ids.contains(widget.id)) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Favorite()));
                                                  } else {
                                                    _createfav({
                                                      "id": sneaker.id,
                                                      "name": sneaker.name,
                                                      "category":
                                                          sneaker.category,
                                                      "price": sneaker.price,
                                                      "imageUrl":
                                                          sneaker.imageUrl[0],
                                                    });
                                                  }
                                                },
                                                child: ids.contains(sneaker.id)
                                                    ? Icon(AntDesign.heart)
                                                    : Icon(AntDesign.hearto),
                                              );
                                            },
                                          )),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        left: 0,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List<Widget>.generate(
                                            sneaker.imageUrl.length,
                                            (index) => Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              child: CircleAvatar(
                                                radius: 5,
                                                backgroundColor: productNotifier
                                                            .activePage !=
                                                        index
                                                    ? Colors.grey
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.645,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sneaker.name,
                                          style: appStyle(40, Colors.black,
                                              FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              sneaker.category,
                                              style: appStyle(20, Colors.grey,
                                                  FontWeight.w500),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            RatingBar.builder(
                                              initialRating: 4,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 22,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 1),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                size: 18,
                                                color: Colors.black,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              sneaker.price,
                                              style: appStyle(26, Colors.black,
                                                  FontWeight.w600),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Color",
                                                  style: appStyle(
                                                      18,
                                                      Colors.black,
                                                      FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                CircleAvatar(
                                                  radius: 7,
                                                  backgroundColor: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                CircleAvatar(
                                                  radius: 7,
                                                  backgroundColor: Colors.red,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Select Size',
                                                  style: appStyle(
                                                      20,
                                                      Colors.black,
                                                      FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text("View Size Guide",
                                                    style: appStyle(
                                                        20,
                                                        Colors.grey,
                                                        FontWeight.w600))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 40,
                                              child: ListView.builder(
                                                itemCount: productNotifier
                                                    .shoeSize.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                padding: EdgeInsets.zero,
                                                itemBuilder: ((context, index) {
                                                  final sizes = productNotifier
                                                      .shoeSize[index];
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: ChoiceChip(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60),
                                                        side: BorderSide(
                                                          color: Colors.black,
                                                          width: 1,
                                                          style:
                                                              BorderStyle.solid,
                                                        ),
                                                      ),
                                                      disabledColor:
                                                          Colors.white,
                                                      label: Text(
                                                        sizes['size'],
                                                        style: appStyle(
                                                            18,
                                                            sizes["isSelected"]
                                                                ? Colors.white
                                                                : Colors.black,
                                                            FontWeight.w500),
                                                      ),
                                                      selected:
                                                          sizes["isSelected"],
                                                      onSelected: (newState) {
                                                        if (productNotifier
                                                            .sizes
                                                            .contains(sizes[
                                                                'size'])) {
                                                          productNotifier.sizes
                                                              .remove(sizes[
                                                                  'size']);
                                                        } else {
                                                          productNotifier.sizes
                                                              .add(sizes[
                                                                  'size']);
                                                        }
                                                        print(productNotifier
                                                            .sizes);
                                                        productNotifier
                                                            .toggleCheck(index);
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          indent: 10,
                                          endIndent: 10,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Text(
                                            sneaker.title,
                                            style: appStyle(26, Colors.black,
                                                FontWeight.w700),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          textAlign: TextAlign.justify,
                                          maxLines: 4,
                                          sneaker.description,
                                          style: appStyle(14, Colors.black,
                                              FontWeight.normal),
                                        ),
                                        // SizedBox(
                                        //   height: ,
                                        // ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 12),
                                            child: CheckOutButton(
                                              label: "Add to Cart",
                                              onTap: () async {
                                                _createCart({
                                                  "id": sneaker.id,
                                                  "name": sneaker.name,
                                                  "category": sneaker.category,
                                                  "size": productNotifier.sizes,
                                                  "imageUrl":
                                                      sneaker.imageUrl[0],
                                                  "price": sneaker.price,
                                                  "qty": 1,
                                                });
                                                productNotifier.sizes.clear();
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
