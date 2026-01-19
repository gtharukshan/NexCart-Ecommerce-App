// import 'package:ecommerce_admin_app/containers/dashboard_text.dart';
// import 'package:ecommerce_admin_app/containers/home_button.dart';
// import 'package:ecommerce_admin_app/controllers/auth_service.dart';
// import 'package:ecommerce_admin_app/providers/admin_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class AdminHome extends StatefulWidget {
//   const AdminHome({super.key});
//
//   @override
//   State<AdminHome> createState() => _AdminHomeState();
// }
//
// class _AdminHomeState extends State<AdminHome> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Admin Dashboard"),
//       actions: [
//         IconButton(onPressed: ()async{
//           Provider.of<AdminProvider>(context,listen: false).cancelProvider();
//          await AuthService().logout();
//           Navigator.pushNamedAndRemoveUntil(context, "/login",  (route)=> false);
//         }, icon: Icon(Icons.logout))
//       ],
//       ),
//       body:  SingleChildScrollView(
//         child: Column(children: [
//           Container(
//             height: 260,
//           padding:  EdgeInsets.all(12),
//           margin:  EdgeInsets.only(left: 10,right:  10,bottom: 10),
//           decoration:  BoxDecoration(color:  Colors.deepPurple.shade100,borderRadius:  BorderRadius.circular(10)),
//             child: Consumer<AdminProvider>(
//               builder: (context, value, child) =>
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   DashboardText(keyword: "Total Categories", value: "${value.categories.length}",),
//                   DashboardText(keyword: "Total Products", value: "${value.products.length}",),
//                   DashboardText(keyword: "Total Orders", value: "${value.totalOrders}",),
//                   DashboardText(keyword: "Order Not Shipped yet", value: "${value.orderPendingProcess}",),
//                   DashboardText(keyword: "Order Shipped", value: "${value.ordersOnTheWay}",),
//                   DashboardText(keyword: "Order Delivered", value: "${value.ordersDelivered}",),
//                   DashboardText(keyword: "Order Cancelled", value: "${value.ordersCancelled}",),
//
//                 ],
//               ),
//             )),
//
//             // Buttons for admins
//             Row(
//         children: [
//           HomeButton(onTap: (){
//             Navigator.pushNamed(context,"/orders");
//           }, name: "Orders"),
//           HomeButton(onTap: (){
//             Navigator.pushNamed(context,"/products");
//           }, name: "Products"),
//         ],
//             ),
//             Row(
//         children: [
//           HomeButton(onTap: (){
//             Navigator.pushNamed(context,"/promos",arguments: {"promo":true});
//           }, name: "Promos"),
//           HomeButton(onTap: (){
//              Navigator.pushNamed(context,"/promos",arguments: {"promo":false});
//           }, name: "Banners"),
//         ],
//             ),
//             Row(
//         children: [
//           HomeButton(onTap: (){
//             Navigator.pushNamed(context,"/category");
//           }, name: "Categories"),
//           HomeButton(onTap: (){
//             Navigator.pushNamed(context, "/coupons");
//           }, name: "Coupons"),
//         ],
//             ),
//         ],),
//       ),
//     );
//   }
// }

import 'package:ecommerce_admin_app/containers/dashboard_text.dart';
import 'package:ecommerce_admin_app/containers/home_button.dart';
import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 2,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Logout"),
                  content: Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        Provider.of<AdminProvider>(context, listen: false)
                            .cancelProvider();
                        await AuthService().logout();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "/login",
                              (route) => false,
                        );
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.logout_outlined, color: Colors.white),
            tooltip: "Logout",
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            // Stats Overview Card
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Consumer<AdminProvider>(
                builder: (context, value, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dashboard Overview",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2.2, // Increased from 2.5 to give more vertical space
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        _buildStatCard(
                          icon: Icons.category_outlined,
                          title: "Categories",
                          value: "${value.categories.length}",
                          color: Colors.blue.shade600,
                        ),
                        _buildStatCard(
                          icon: Icons.shopping_bag_outlined,
                          title: "Products",
                          value: "${value.products.length}",
                          color: Colors.green.shade600,
                        ),
                        _buildStatCard(
                          icon: Icons.receipt_long_outlined,
                          title: "Total Orders",
                          value: "${value.totalOrders}",
                          color: Colors.purple.shade600,
                        ),
                        _buildStatCard(
                          icon: Icons.pending_actions_outlined,
                          title: "Pending",
                          value: "${value.orderPendingProcess}",
                          color: Colors.orange.shade600,
                        ),
                        _buildStatCard(
                          icon: Icons.local_shipping_outlined,
                          title: "On The Way",
                          value: "${value.ordersOnTheWay}",
                          color: Colors.teal.shade600,
                        ),
                        _buildStatCard(
                          icon: Icons.check_circle_outline,
                          title: "Delivered",
                          value: "${value.ordersDelivered}",
                          color: Colors.green.shade700,
                        ),
                        _buildStatCard(
                          icon: Icons.cancel_outlined,
                          title: "Cancelled",
                          value: "${value.ordersCancelled}",
                          color: Colors.red.shade600,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Quick Actions Grid
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.3, // Adjusted for better fit
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildActionCard(
                        icon: Icons.receipt_long_outlined,
                        title: "Orders",
                        color: Colors.blue.shade600,
                        onTap: () {
                          Navigator.pushNamed(context, "/orders");
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.shopping_bag_outlined,
                        title: "Products",
                        color: Colors.green.shade600,
                        onTap: () {
                          Navigator.pushNamed(context, "/products");
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.campaign_outlined,
                        title: "Promos",
                        color: Colors.orange.shade600,
                        onTap: () {
                          Navigator.pushNamed(context, "/promos",
                              arguments: {"promo": true});
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.image_outlined,
                        title: "Banners",
                        color: Colors.purple.shade600,
                        onTap: () {
                          Navigator.pushNamed(context, "/promos",
                              arguments: {"promo": false});
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.category_outlined,
                        title: "Categories",
                        color: Colors.teal.shade600,
                        onTap: () {
                          Navigator.pushNamed(context, "/category");
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.discount_outlined,
                        title: "Coupons",
                        color: Colors.red.shade600,
                        onTap: () {
                          Navigator.pushNamed(context, "/coupons");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30), // Added more space at bottom
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced vertical padding
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36, // Slightly smaller
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18), // Smaller icon
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11, // Smaller font
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2), // Reduced spacing
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16, // Smaller font
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(12), // Added padding inside
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48, // Slightly smaller
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, color: color, size: 26), // Slightly smaller
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13, // Slightly smaller
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}