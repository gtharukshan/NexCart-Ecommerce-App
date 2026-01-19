// import 'package:ecommerce_app/containers/additional_confirm.dart';
// import 'package:ecommerce_app/controllers/db_service.dart';
// import 'package:ecommerce_app/models/orders_model.dart';
// import 'package:flutter/material.dart';
//
// class OrdersPage extends StatefulWidget {
//   const OrdersPage({super.key});
//
//   @override
//   State<OrdersPage> createState() => _OrdersPageState();
// }
//
// class _OrdersPageState extends State<OrdersPage> {
//   totalQuantityCalculator(List<OrderProductModel> products) {
//     int qty = 0;
//     products.map((e) => qty += e.quantity).toList();
//     return qty;
//   }
//
//   Widget statusIcon(String status) {
//     if (status == "PAID") {
//       return statusContainer(
//           text: "PAID", bgColor: Colors.lightGreen, textColor: Colors.white);
//     }
//     if (status == "ON_THE_WAY") {
//       return statusContainer(
//           text: "ON THE WAY", bgColor: Colors.yellow, textColor: Colors.black);
//     } else if (status == "DELIVERED") {
//       return statusContainer(
//           text: "DELIVERED",
//           bgColor: Colors.green.shade700,
//           textColor: Colors.white);
//     } else {
//       return statusContainer(
//           text: "CANCELED", bgColor: Colors.red, textColor: Colors.white);
//     }
//   }
//
//   Widget statusContainer(
//       {required String text,
//       required Color bgColor,
//       required Color textColor}) {
//     return Container(
//       child: Text(
//         text,
//         style: TextStyle(color: textColor),
//       ),
//       color: bgColor,
//       padding: EdgeInsets.all(8),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Orders",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//         ),
//         scrolledUnderElevation: 0,
//         forceMaterialTransparency: true,
//       ),
//       body: StreamBuilder(
//         stream: DbService().readOrders(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text("Error: ${snapshot.error}"),
//             );
//           }
//           if (snapshot.hasData) {
//             List<OrdersModel> orders =
//                 OrdersModel.fromJsonList(snapshot.data!.docs)
//                     as List<OrdersModel>;
//             if (orders.isEmpty) {
//               return Center(
//                 child: Text("No orders found"),
//               );
//             } else {
//               return ListView.builder(
//                 itemCount: orders.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     onTap: () {
//                       Navigator.pushNamed(context, "/view_order",
//                           arguments: orders[index]);
//                     },
//                     title: Text(
//                         "${totalQuantityCalculator(orders[index].products)} Items Worth LKR ${orders[index].total}"),
//                     subtitle: Text(
//                         "Ordered on ${DateTime.fromMillisecondsSinceEpoch(orders[index].created_at).toString()}"),
//                     trailing: statusIcon(orders[index].status),
//                   );
//                 },
//               );
//             }
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
//
// class ViewOrder extends StatefulWidget {
//   const ViewOrder({super.key});
//
//   @override
//   State<ViewOrder> createState() => _ViewOrderState();
// }
//
// class _ViewOrderState extends State<ViewOrder> {
//   @override
//   Widget build(BuildContext context) {
//     final args = ModalRoute.of(context)!.settings.arguments as OrdersModel;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Order Summary"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Text(
//                   "Delivery Details",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(8),
//                 color: Colors.grey.shade100,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Order Id : ${args.id}"),
//                     Text(
//                         "Order On : ${DateTime.fromMillisecondsSinceEpoch(args.created_at).toString()}"),
//                     Text("Order by : ${args.name}"),
//                     Text("Phone no : ${args.phone}"),
//                     Text("Delivery Address : ${args.address}"),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: args.products
//                     .map((e) => Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.all(10),
//                           margin: EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade200,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Row(
//                                 children: [
//                                   Container(
//                                     height: 50,
//                                     width: 50,
//                                     child: Image.network(e.image),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Expanded(child: Text(e.name)),
//                                 ],
//                               ),
//                               Text(
//                                 "LKR${e.single_price.toString()} x ${e.quantity.toString()} quantity",
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 "LKR${e.total_price.toString()}",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 20),
//                               ),
//                             ],
//                           ),
//                         ))
//                     .toList(),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Discount : LKR${args.discount}",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                     ),
//                     Text(
//                       "Total : LKR${args.total}",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                     ),
//                     Text(
//                       "Status : ${args.status}",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 8,
//               ),
//           args.status=="PAID" || args.status=="ON_THE_WAY" ?
//               SizedBox(
//                 height: 60,
//                 width: MediaQuery.of(context).size.width * .9,
//                 child: ElevatedButton(
//                   child: Text("Modify Order"),
//                   onPressed: () {
//                     showDialog(
//                         context: context,
//                         builder: (context) => ModifyOrder(
//                               order: args,
//                             ));
//                   },
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white),
//                 ),
//               ):
//               SizedBox(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ModifyOrder extends StatefulWidget {
//   final OrdersModel order;
//   const ModifyOrder({super.key, required this.order});
//
//   @override
//   State<ModifyOrder> createState() => _ModifyOrderState();
// }
//
// class _ModifyOrderState extends State<ModifyOrder> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text("Modify this order"),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Chosse want you want to do"),
//           TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 showDialog(
//                     context: context,
//                     builder: (context) => AdditionalConfirm(
//                         contentText:
//                             "After canceling this cannot be changed you need to order again.",
//                         onYes: () async {
//                           await DbService().updateOrderStatus(
//                               docId: widget.order.id,
//                               data: {"status": "CANCELLED"});
//                           ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text("Order Updated")));
//                           Navigator.pop(context);
//                           Navigator.pop(context);
//                         },
//                         onNo: () {
//                           Navigator.pop(context);
//                         }));
//               },
//               child: Text("Cancel Order"))
//         ],
//       ),
//     );
//   }
// }

import 'package:ecommerce_app/containers/additional_confirm.dart';
import 'package:ecommerce_app/controllers/db_service.dart';
import 'package:ecommerce_app/models/orders_model.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  totalQuantityCalculator(List<OrderProductModel> products) {
    int qty = 0;
    products.map((e) => qty += e.quantity).toList();
    return qty;
  }

  Widget _statusChip(String status) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case "PAID":
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        icon = Icons.payment_outlined;
        break;
      case "ON_THE_WAY":
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        icon = Icons.local_shipping_outlined;
        break;
      case "DELIVERED":
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        icon = Icons.check_circle_outline;
        break;
      default:
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        icon = Icons.cancel_outlined;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          SizedBox(width: 4),
          Text(
            status.replaceAll("_", " "),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: DbService().readOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Something went wrong",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade600,
              ),
            );
          }

          if (snapshot.hasData) {
            List<OrdersModel> orders =
            OrdersModel.fromJsonList(snapshot.data!.docs) as List<OrdersModel>;

            if (orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "No orders yet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Your orders will appear here",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final date = DateTime.fromMillisecondsSinceEpoch(order.created_at);

                return Card(
                  elevation: 0,
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, "/view_order",
                          arguments: order);
                    },
                    contentPadding: EdgeInsets.all(16),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.blue.shade600,
                        size: 30,
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Order #${order.id.substring(0, 8)}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _statusChip(order.status),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          "${totalQuantityCalculator(order.products)} items • LKR${order.total}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${date.day}/${date.month}/${date.year}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey.shade400,
                    ),
                  ),
                );
              },
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}

class ViewOrder extends StatefulWidget {
  const ViewOrder({super.key});

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrdersModel;
    final date = DateTime.fromMillisecondsSinceEpoch(args.created_at);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Info Card
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
                            Icons.receipt_long_outlined,
                            color: Colors.blue.shade600,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Order Information",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildInfoRow("Order ID", args.id.substring(0, 12) + "..."),
                      _buildInfoRow("Order Date", "${date.day}/${date.month}/${date.year}"),
                      _buildInfoRow("Status", args.status.replaceAll("_", " ")),
                      Divider(height: 24),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: Colors.blue.shade600,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Delivery Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildInfoRow("Name", args.name),
                      _buildInfoRow("Phone", args.phone),
                      _buildInfoRow("Address", args.address),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Order Items
              Text(
                "Order Items (${args.products.length})",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),

              ...args.products.map((product) => Card(
                elevation: 0,
                margin: EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(product.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        "Qty: ${product.quantity} × LKR${product.single_price}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    "LKR${product.total_price}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              )).toList(),

              SizedBox(height: 16),

              // Payment Summary
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
                        "Payment Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildPaymentRow("Items Total", "LKR${args.total + args.discount}"),
                      _buildPaymentRow("Discount", "- LKR${args.discount}"),
                      Divider(height: 24),
                      _buildPaymentRow("Total Paid", "LKR${args.total}", isTotal: true),
                    ],
                  ),
                ),
              ),

              SizedBox(height: args.status == "PAID" || args.status == "ON_THE_WAY" ? 16 : 32),

              // Modify Order Button
              if (args.status == "PAID" || args.status == "ON_THE_WAY")
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ModifyOrder(order: args),
                      );
                    },
                    child: Text("Modify Order"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.blue.shade600),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
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

class ModifyOrder extends StatelessWidget {
  final OrdersModel order;
  const ModifyOrder({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Modify Order",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Choose what you want to do",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AdditionalConfirm(
                      contentText:
                      "After canceling this cannot be changed. You'll need to order again.",
                      onYes: () async {
                        await DbService().updateOrderStatus(
                          docId: order.id,
                          data: {"status": "CANCELLED"},
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Order Updated"),
                            backgroundColor: Colors.green.shade600,
                          ),
                        );
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      onNo: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
                child: Text("Cancel Order"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close"),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}