// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecommerce_app/contants/payment.dart';
// import 'package:ecommerce_app/controllers/db_service.dart';
// import 'package:ecommerce_app/controllers/mail_service.dart';
// import 'package:ecommerce_app/models/orders_model.dart';
// import 'package:ecommerce_app/providers/cart_provider.dart';
// import 'package:ecommerce_app/providers/user_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:provider/provider.dart';
//
// class CheckoutPage extends StatefulWidget {
//   const CheckoutPage({super.key});
//
//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }
//
// class _CheckoutPageState extends State<CheckoutPage> {
//   TextEditingController _couponController = TextEditingController();
//
//   int discount = 0;
//   int toPay = 0;
//   String discountText = "";
//
//   bool paymentSuccess=false;
//   Map<String,dynamic> dataOfOrder={};
//
//     discountCalculator(int disPercent, int totalCost) {
//     discount = (disPercent * totalCost) ~/ 100;
//   setState(() {});
//   }
//
//   Future<void> initPaymentSheet(int cost) async {
//     try {
//       final user = Provider.of<UserProvider>(context, listen: false);
//       // 1. create payment intent on the server
//       final data = await createPaymentIntent(name: user.name,address: user.address,
//       amount:  (cost*100).toString());
//
//       // 2. initialize the payment sheet
//      await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           // Set to true for custom flow
//           customFlow: false,
//           // Main params
//           merchantDisplayName: 'Flutter Stripe Store Demo',
//           paymentIntentClientSecret: data['client_secret'],
//           // Customer keys
//           customerEphemeralKeySecret: data['ephemeralKey'],
//           customerId: data['id'],
//           // Extra options
//
//
//           style: ThemeMode.dark,
//         ),
//       );
//
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//       rethrow;
//     }
// }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Checkout",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//         ),
//         scrolledUnderElevation: 0,
//         forceMaterialTransparency: true,
//       ),
//       body: SingleChildScrollView(
//         child: Consumer<UserProvider>(
//           builder: (context, userData, child) => Consumer<CartProvider>(
//             builder: (context, cartData, child) {
//               return Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Delivery Details",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                     ),
//                     Container(
//                        padding: EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade200,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Row(children: [
//                          SizedBox(
//                            width: MediaQuery.of(context).size.width * .65,
//                            child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                              children: [
//                                Text(userData.name,style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w500),),
//                            Text(userData.email),
//                            Text(userData.address),
//                            Text(userData.phone),
//                              ],
//                            ),
//                          ),
//                          Spacer(),
//                          IconButton(onPressed: (){
//                           Navigator.pushNamed(context,"/update_profile");
//                          }, icon: Icon(Icons.edit_outlined))
//                               ],),
//                     ),
//                        SizedBox(
//                           height: 20,
//                         ),
//                         Text("Have a coupon?"),
//                          Row(
//                           children: [
//                             SizedBox(
//                               width: 200,
//                               child: TextFormField(
//                                 textCapitalization: TextCapitalization
//                                     .characters, // capitalize first letter of each word
//                                 controller: _couponController,
//                                 decoration: InputDecoration(
//                                   labelText: "Coupon Code",
//                                   hintText: "Enter Coupon for extra discount",
//                                   border: InputBorder.none,
//                                   filled: true,
//                                   fillColor: Colors.grey.shade200,
//                                 ),
//                               ),
//                             ),
//                             TextButton(
//                                 onPressed: () async {
//                                   QuerySnapshot querySnapshot =
//                                       await DbService().verifyDiscount(
//                                           code: _couponController.text
//                                               .toUpperCase());
//
//                                   if (querySnapshot.docs.isNotEmpty) {
//                                     QueryDocumentSnapshot doc =
//                                         querySnapshot.docs.first;
//                                     String code = doc.get('code');
//                                     int percent = doc.get('discount');
//
//                                     // access other fields as needed
//                                     print('Discount code: $code');
//                                     discountText =
//                                         "a discount of $percent% has been applied.";
//                                     discountCalculator(
//                                         percent, cartData.totalCost);
//                                   } else {
//                                     print('No discount code found');
//                                     discountText = "No discount code found";
//                                   }
//                                   setState(() {});
//                                 },
//                                 child: Text("Apply"))
//                           ],
//                         ),
//                           SizedBox(
//                           height: 8,
//                         ),
//                         discountText == "" ? Container() : Text(discountText),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Divider(),
//                         SizedBox(
//                           height: 10,
//                         ),
//                           Text(
//                           "Total Quantity of Products: ${cartData.totalQuantity}",
//                           style: TextStyle(
//                             fontSize: 16,
//                           ),
//                         ),
//                         Text(
//                           "Sub Total: LKR ${cartData.totalCost}",
//                           style: TextStyle(
//                             fontSize: 16,
//                           ),
//                         ),
//                         Divider(),
//                         Text(
//                           "Extra Discount: - LKR $discount",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         Divider(),
//                         Text(
//                           "Total Payable: LKR ${cartData.totalCost - discount}",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.w500),
//                         ),
//
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//
//       ),
//       bottomNavigationBar: Container(
//          height: 60,
//         padding: const EdgeInsets.all(8.0),
//         child: ElevatedButton(child: Text("Procced to pay"), onPressed: ()async{
//           final user = Provider.of<UserProvider>(context, listen: false);
//             if (user.address == "" ||
//                 user.phone == "" ||
//                 user.name == "" ||
//                 user.email == "") {
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text("Please fill your delivery details.")));
//               return;
//             }
//
//             try {
//               if (kIsWeb) {
//                 // WEB: Simulate Payment
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text("Web Demo: Simulating Payment...")));
//                 await Future.delayed(Duration(seconds: 2));
//               } else {
//                 // MOBILE: Real Stripe Payment
//                 await initPaymentSheet(
//                     Provider.of<CartProvider>(context, listen: false)
//                             .totalCost -
//                         discount);
//                 await Stripe.instance.presentPaymentSheet();
//               }
//
//               final cart = Provider.of<CartProvider>(context, listen: false);
//
//               User? currentUser = FirebaseAuth.instance.currentUser;
//               List products = [];
//
//               for (int i = 0; i < cart.products.length; i++) {
//                 products.add({
//                   "id": cart.products[i].id,
//                   "name": cart.products[i].name,
//                   "image": cart.products[i].image,
//                   "single_price": cart.products[i].new_price,
//                   "total_price":
//                       cart.products[i].new_price * cart.carts[i].quantity,
//                   "quantity": cart.carts[i].quantity
//                 });
//               }
//
//               // ORDER STATUS
//               // PAID - paid money by user
//               // SHIPPED - item shipped
//               // CANCELLED - item cancelled
//               // DELIVERED - order delivered
//
//               Map<String, dynamic> orderData = {
//                 "user_id": currentUser!.uid,
//                 "name": user.name,
//                 "email": user.email,
//                 "address": user.address,
//                 "phone": user.phone,
//                 "discount": discount,
//                 "total": cart.totalCost - discount,
//                 "products": products,
//                 "status": "PAID",
//                 "created_at": DateTime.now().millisecondsSinceEpoch
//               };
//
//               dataOfOrder = orderData;
//
//               // creating new order
//               await DbService().createOrder(data: orderData);
//
//               //  reduce the quantity of product on firestore
//               for (int i = 0; i < cart.products.length; i++) {
//                 DbService().reduceQuantity(
//                     productId: cart.products[i].id,
//                     quantity: cart.carts[i].quantity);
//               }
//
//               // clear the cart for the user
//               await DbService().emptyCart();
//
//               paymentSuccess = true;
//
//               //  close the checkout page
//               Navigator.pop(context);
//
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: Text(
//                   "Payment Done",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 backgroundColor: Colors.green,
//               ));
//             } catch (e) {
//               print("payment sheet error : $e");
//               print("payment sheet failed");
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: Text(
//                   "Payment Failed: $e",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 backgroundColor: Colors.redAccent,
//               ));
//             }
//
//             if (paymentSuccess) {
//               if (kIsWeb) {
//                 print("Email skipped on Web");
//               } else {
//                 MailService().sendMailFromGmail(
//                     user.email, OrdersModel.fromJson(dataOfOrder, ""));
//               }
//             }
//
//
//         },style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,foregroundColor: Colors.white),),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/contants/payment.dart';
import 'package:ecommerce_app/controllers/db_service.dart';
import 'package:ecommerce_app/controllers/mail_service.dart';
import 'package:ecommerce_app/models/orders_model.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController _couponController = TextEditingController();
  int discount = 0;
  int toPay = 0;
  String discountText = "";
  bool paymentSuccess = false;
  Map<String, dynamic> dataOfOrder = {};
  bool _isApplyingCoupon = false;

  discountCalculator(int disPercent, int totalCost) {
    discount = (disPercent * totalCost) ~/ 100;
    setState(() {});
  }

  Future<void> initPaymentSheet(int cost) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false);
      final data = await createPaymentIntent(
        name: user.name,
        address: user.address,
        amount: (cost * 100).toString(),
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Ecommerce Store',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          style: ThemeMode.light,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: Colors.white,
              primary: Colors.blue.shade600,
              componentBorder: Colors.grey.shade300,
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userData, child) => Consumer<CartProvider>(
          builder: (context, cartData, child) {
            final totalPayable = cartData.totalCost - discount;

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Details Card
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.blue.shade600,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Delivery Address",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userData.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        userData.address,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        userData.phone,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/update_profile");
                                  },
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.blue.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Coupon Section
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Apply Coupon",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _couponController,
                                    decoration: InputDecoration(
                                      hintText: "Enter coupon code",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.blue.shade600,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                _isApplyingCoupon
                                    ? CircularProgressIndicator(
                                  color: Colors.blue.shade600,
                                )
                                    : ElevatedButton(
                                  onPressed: () async {
                                    setState(() => _isApplyingCoupon = true);
                                    QuerySnapshot querySnapshot =
                                    await DbService().verifyDiscount(
                                        code: _couponController.text
                                            .toUpperCase());

                                    if (querySnapshot.docs.isNotEmpty) {
                                      QueryDocumentSnapshot doc =
                                          querySnapshot.docs.first;
                                      String code = doc.get('code');
                                      int percent = doc.get('discount');

                                      discountText =
                                      "🎉 $percent% discount applied!";
                                      discountCalculator(
                                          percent, cartData.totalCost);
                                    } else {
                                      discountText = "Invalid coupon code";
                                    }
                                    setState(() => _isApplyingCoupon = false);
                                  },
                                  child: Text("Apply"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (discountText.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  discountText,
                                  style: TextStyle(
                                    color: discountText.contains("Invalid")
                                        ? Colors.red.shade600
                                        : Colors.green.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Order Summary Card
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order Summary",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 16),
                            _buildSummaryRow("Items", cartData.totalQuantity.toString()),
                            _buildSummaryRow("Subtotal", "LKR${cartData.totalCost}"),
                            if (discount > 0)
                              _buildSummaryRow("Discount", "- LKR$discount"),
                            Divider(height: 24),
                            _buildSummaryRow(
                              "Total Payable",
                              "LKR$totalPayable",
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 100),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: Container(
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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
    child: SizedBox(
    height: 56,
    child: ElevatedButton(
    onPressed: () async {
    final user = Provider.of<UserProvider>(context, listen: false);
    if (user.address.isEmpty ||
    user.phone.isEmpty ||
    user.name.isEmpty ||
    user.email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text("Please fill your delivery details."),
    backgroundColor: Colors.orange.shade600,
    behavior: SnackBarBehavior.floating,
    ),
    );
    return;
    }

    try {
    if (kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text("Processing payment..."),
    backgroundColor: Colors.blue.shade600,
    ),
    );
    await Future.delayed(Duration(seconds: 2));
    } else {
    await initPaymentSheet(
    Provider.of<CartProvider>(context, listen: false).totalCost -
    discount,
    );
    await Stripe.instance.presentPaymentSheet();
    }

    final cart = Provider.of<CartProvider>(context, listen: false);
    User? currentUser = FirebaseAuth.instance.currentUser;
    List products = [];

    for (int i = 0; i < cart.products.length; i++) {
    products.add({
    "id": cart.products[i].id,
    "name": cart.products[i].name,
    "image": cart.products[i].image,
    "single_price": cart.products[i].new_price,
    "total_price":
    cart.products[i].new_price * cart.carts[i].quantity,
    "quantity": cart.carts[i].quantity,
    });
    }

    Map<String, dynamic> orderData = {
    "user_id": currentUser!.uid,
    "name": user.name,
    "email": user.email,
    "address": user.address,
    "phone": user.phone,
    "discount": discount,
    "total": cart.totalCost - discount,
    "products": products,
    "status": "PAID",
    "created_at": DateTime.now().millisecondsSinceEpoch,
    };

    dataOfOrder = orderData;
    await DbService().createOrder(data: orderData);

    for (int i = 0; i < cart.products.length; i++) {
    DbService().reduceQuantity(
    productId: cart.products[i].id,
    quantity: cart.carts[i].quantity,
    );
    }

    await DbService().emptyCart();
    paymentSuccess = true;
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text(
    "✅ Payment Successful!",
    style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.green.shade600,
    behavior: SnackBarBehavior.floating,
    ),
    );
    } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text(
    "Payment Failed: $e",
    style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red.shade600,
    behavior: SnackBarBehavior.floating,
    ),
    );
    }

    if (paymentSuccess) {
    if (kIsWeb) {
    print("Email skipped on Web");
    } else {
    MailService().sendMailFromGmail(
    user.email,
    OrdersModel.fromJson(dataOfOrder, ""),
    );
    }
    }
    },
    child: Text(
    "Pay LKR${Provider.of<CartProvider>(context).totalCost - discount}",
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    ),
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
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.black87 : Colors.grey.shade600,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 14,
              color: isTotal ? Colors.blue.shade700 : Colors.black87,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}