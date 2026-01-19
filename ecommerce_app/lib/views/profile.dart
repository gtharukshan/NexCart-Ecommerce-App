// import 'package:ecommerce_app/controllers/auth_service.dart';
// import 'package:ecommerce_app/providers/cart_provider.dart';
// import 'package:ecommerce_app/providers/user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: AppBar(title: Text("Profile",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
//       scrolledUnderElevation: 0,
//   forceMaterialTransparency: true,),
//     body:  Column(children: [
//       Consumer<UserProvider>(
//         builder: (context, value, child) =>
//         Card(
//           child: ListTile(
//             title: Text(value.name),
//           subtitle:  Text(value.email),
//           onTap: (){
//             Navigator.pushNamed(context,"/update_profile");
//           },
//           trailing: Icon(Icons.edit_outlined),
//           ),
//         ),
//       ),
//       SizedBox(height: 20,),
//       ListTile(title: Text("Orders"), leading: Icon(Icons.local_shipping_outlined), onTap: (){
//         Navigator.pushNamed(context, "/orders");
//
//       },),
//       Divider( thickness: 1,  endIndent:  10, indent: 10,),
//       ListTile(title: Text("Discount & Offers"), leading: Icon(Icons.discount_outlined), onTap: (){
//        Navigator.pushNamed(context, "/discount");
//       },),
//       Divider( thickness: 1,  endIndent:  10, indent: 10,),
//       ListTile(title: Text("Help & Support"), leading: Icon(Icons.support_agent), onTap: (){
//        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mail us at ecommerce@shop.com")));
//       },),
//       Divider( thickness: 1,  endIndent:  10, indent: 10,),
//       ListTile(title: Text("Logout"), leading: Icon(Icons.logout_outlined), onTap: ()async{
//         Provider.of<UserProvider>(context,listen: false).cancelProvider();
//         Provider.of<CartProvider>(context,listen: false).cancelProvider();
//        await AuthService().logout();
//        Navigator.pushNamedAndRemoveUntil(context,"/login", (route)=> true);
//       },),
//     ],),
//     );
//   }
// }

import 'package:ecommerce_app/controllers/auth_service.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Force refresh user data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _forceRefreshUserData();
    });
  }

  void _forceRefreshUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Cancel and restart the subscription to force a refresh
    userProvider.cancelProvider();
    userProvider.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Profile",
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
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Debug output to see current values
          print("=== Profile Page Consumer Rebuilt ===");
          print("Name: ${userProvider.name}");
          print("Email: ${userProvider.email}");

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                // Profile Header
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 40,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userProvider.name.isEmpty ? "User Name" : userProvider.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              userProvider.email.isEmpty ? "user@email.com" : userProvider.email,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (userProvider.address.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  userProvider.address,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          // Navigate to update profile
                          final result = await Navigator.pushNamed(
                              context,
                              "/update_profile"
                          );

                          // Check if we should refresh
                          if (result == true) {
                            // Force a refresh of user data
                            _forceRefreshUserData();
                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Profile updated successfully"),
                                backgroundColor: Colors.green.shade600,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Menu Items
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _buildMenuTile(
                        icon: Icons.shopping_bag_outlined,
                        title: "My Orders",
                        subtitle: "View your order history",
                        onTap: () {
                          Navigator.pushNamed(context, "/orders");
                        },
                      ),
                      _buildDivider(),
                      _buildMenuTile(
                        icon: Icons.discount_outlined,
                        title: "Discount & Offers",
                        subtitle: "View available coupons",
                        onTap: () {
                          Navigator.pushNamed(context, "/discount");
                        },
                      ),
                      _buildDivider(),
                      _buildMenuTile(
                        icon: Icons.help_outline,
                        title: "Help & Support",
                        subtitle: "Get help with your orders",
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Mail us at support@ecommerce.com"),
                              backgroundColor: Colors.blue.shade600,
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Logout Button
                Container(
                  color: Colors.white,
                  child: _buildMenuTile(
                    icon: Icons.logout_outlined,
                    title: "Logout",
                    subtitle: "Sign out from your account",
                    color: Colors.red.shade600,
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Logout",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          content: Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await _performLogout();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600,
                                foregroundColor: Colors.white,
                              ),
                              child: Text("Logout"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Debug/Refresh Section
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Debug Info",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _forceRefreshUserData();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Force refreshed user data"),
                                    backgroundColor: Colors.blue.shade600,
                                  ),
                                );
                              },
                              icon: Icon(Icons.refresh, size: 18),
                              label: Text("Force Refresh"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade50,
                                foregroundColor: Colors.blue.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                print("=== Current User Data ===");
                                print("Name: ${userProvider.name}");
                                print("Email: ${userProvider.email}");
                                print("Address: ${userProvider.address}");
                                print("Phone: ${userProvider.phone}");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Data printed to console"),
                                    backgroundColor: Colors.green.shade600,
                                  ),
                                );
                              },
                              icon: Icon(Icons.bug_report, size: 18),
                              label: Text("Print Data"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade50,
                                foregroundColor: Colors.green.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _performLogout() async {
    try {
      // Clear all providers
      Provider.of<UserProvider>(context, listen: false).cancelProvider();
      Provider.of<CartProvider>(context, listen: false).cancelProvider();

      // Logout from auth service
      await AuthService().logout();

      // Navigate to login page
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/login",
            (route) => false,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logged out successfully"),
          backgroundColor: Colors.green.shade600,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error logging out: $e"),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: (color ?? Colors.blue.shade600).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color ?? Colors.blue.shade600,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }
}