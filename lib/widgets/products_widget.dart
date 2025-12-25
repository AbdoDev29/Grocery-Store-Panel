import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_network/image_network.dart';

import '../inner_screens/edit_prod.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import 'text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  String title = '';
  String productCat = '';
  String? imageUrl;
  String price = '0.0';
  double salePrice = 0.0;
  bool isOnSale = false;
  bool isPiece = false;

  @override
  void initState() {
    getProductsData();
    super.initState();
  }

  Future<void> getProductsData() async {
    try {
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();
      if (productsDoc == null) {
        return;
      } else {
        setState(() {
          final data = productsDoc.data() as Map<String, dynamic>? ?? {};

          title = data['title'] ?? '';
          productCat = data['productCategoryName'] ?? '';
          imageUrl = data['imageUrl'];
          price = (data['price'] ?? '0').toString();
          salePrice = (data['salePrice'] ?? 0).toDouble();
          isOnSale = data['isOnSale'] ?? false;
          isPiece = data['isPiece'] ?? false;
          // title = productsDoc.get('title');
          // productCat = productsDoc.get('productCategoryName');
          // imageUrl = productsDoc.get('imageUrl');
          // price = productsDoc.get('price');
          // salePrice = productsDoc.get('salePrice');
          // isOnSale = productsDoc.get('isOnSale');
          // isPiece = productsDoc.get('isPiece');
        });
      }
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    final color = Utils(context).color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withValues(alpha: 0.6),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditProductScreen(
                  id: widget.id,
                  title: title,
                  price: price,
                  salePrice: salePrice,
                  productCat: productCat,
                  imageUrl: imageUrl == null
                      ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                      : imageUrl!,
                  isOnSale: isOnSale,
                  isPiece: isPiece,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: ImageNetwork(
                        image: imageUrl!,
                        height: size.width * 0.12,
                        width: size.width * 0.12,
                        fitWeb: BoxFitWeb.cover,
                      ),
                      // Image.network(
                      //   imageUrl == null
                      //       ? 'https://firebasestorage.googleapis.com/v0/b/shop-96036.firebasestorage.app/o/userImages%2F43239a5f-7bc5-4f26-941a-61e769987638.jpg?alt=media&token=b869ded2-6910-4cc9-ae74-e50a44233065'
                      //       : imageUrl!,
                      //   fit: BoxFit.fill,
                      //   // width: screenWidth * 0.12,
                      //   height: size.width * 0.12,
                      // ),
                    ),
                    const Spacer(),
                    PopupMenuButton(
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {},
                                child: const Text('Edit'),
                                value: 1,
                              ),
                              PopupMenuItem(
                                onTap: () {},
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                value: 2,
                              ),
                            ])
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    TextWidget(
                      text: isOnSale
                          ? '\$${salePrice.toStringAsFixed(2)}'
                          : '\$$price',
                      color: color,
                      textSize: 18,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Visibility(
                      visible: isOnSale,
                      child: Text(
                        '\$$price',
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: color),
                      ),
                    ),
                    const Spacer(),
                    TextWidget(
                      text: isPiece ? 'Piece' : '1Kg',
                      color: color,
                      textSize: 18,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                TextWidget(
                  text: title,
                  color: color,
                  textSize: 20,
                  isTitle: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
