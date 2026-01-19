//
// import 'package:ecommerce_app/contants/discount.dart';
// import 'package:ecommerce_app/models/cart_model.dart';
// import 'package:ecommerce_app/models/products_model.dart';
// import 'package:ecommerce_app/providers/cart_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class ViewProduct extends StatefulWidget {
//   const ViewProduct({super.key});
//
//   @override
//   State<ViewProduct> createState() => _ViewProductState();
// }
//
// class _ViewProductState extends State<ViewProduct> {
//   @override
//   Widget build(BuildContext context) {
//     final arguments =
//         ModalRoute.of(context)!.settings.arguments as ProductsModel;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Product Details"),
//   scrolledUnderElevation: 0,
//   forceMaterialTransparency: true,
//
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Image.network(
//               arguments.image,
//               height: 300,
//               width: double.infinity,
//               fit: BoxFit.contain,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     arguments.name,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     children: [
//
//                       Text(
//                         "LKR ${arguments.old_price}",
//                         style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey.shade700,
//                             decoration: TextDecoration.lineThrough),
//                       ),
//                       SizedBox(width: 10,),
//                       Text(
//                         "LKR ${arguments.new_price}",
//                         style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w800,
//                             ),
//                       ),
//                       SizedBox(width: 10,),
//                       Icon(Icons.arrow_downward, color: Colors.green,
//                           size: 20,),
//                       Text("${discountPercent(arguments.old_price, arguments.new_price)} %",
//                        style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green),)
//                     ],
//                   ),
//
//                   SizedBox(
//                     height: 10,
//                   ),
//                   arguments.maxQuantity == 0
//                         ? Text(
//                             "Out of Stock",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.red),
//                           )
//                         : Text(
//                             "Only ${arguments.maxQuantity} left in stock",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.green),
//                           ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(arguments.description,
//                    style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.grey.shade700),)
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar:
//       arguments.maxQuantity!=0?
//         Row(children: [
//
// SizedBox(
//   height: 60,width: MediaQuery.of(context).size.width*.5,
//   child: ElevatedButton(
//                     onPressed: () {
//                       Provider.of<CartProvider>(context,listen: false).addToCart(CartModel(productId: arguments.id, quantity: 1));
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added to cart")));
//                     },
//                     child: Text("Add to Cart"),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue.shade600,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder()),
//                   ),
// ),
// SizedBox(
//   height: 60,width: MediaQuery.of(context).size.width*.5,
//   child: ElevatedButton(
//                     onPressed: () {
//                        Provider.of<CartProvider>(context,listen: false).addToCart(CartModel(productId: arguments.id, quantity: 1));
//                        Navigator.pushNamed(context,"/checkout");
//                     },
//                     child: Text("Buy Now"),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor:  Colors.blue.shade600,
//                         shape: RoundedRectangleBorder()),
//                   ),
// ),
//       ],): SizedBox(),
//     );
//   }
// }

import 'package:ecommerce_app/contants/discount.dart';
import 'package:ecommerce_app/models/cart_model.dart';
import 'package:ecommerce_app/models/products_model.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as ProductsModel;
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 350,
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Center(
                child: Image.network(
                  arguments.image,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    arguments.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "LKR ${arguments.old_price}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                            decoration: TextDecoration.lineThrough),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "LKR ${arguments.new_price}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_downward, color: Colors.green, size: 20),
                      Text(
                        "${discountPercent(arguments.old_price, arguments.new_price)} %",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  arguments.maxQuantity == 0
                      ? Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red, size: 16),
                        SizedBox(width: 8),
                        Text(
                          "Out of Stock",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  )
                      : Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: Colors.green, size: 16),
                        SizedBox(width: 8),
                        Text(
                          "Only ${arguments.maxQuantity} left in stock",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Description",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ),
                  SizedBox(height: 8),
                  Text(
                    arguments.description,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                        height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: arguments.maxQuantity != 0
          ? Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart(CartModel(
                        productId: arguments.id, quantity: 1));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Added to cart"),
                        backgroundColor: Colors.green.shade600));
                  },
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart(CartModel(
                        productId: arguments.id, quantity: 1));
                    Navigator.pushNamed(context, "/checkout");
                  },
                  child: Text(
                    "Buy Now",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: Colors.blue.shade600, width: 1.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : null,
    );
  }
}