import 'package:ecommerce_admin_app/containers/additional_confirm.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/products_model.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Products",
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
            onPressed: () {
              Navigator.pushNamed(context, "/add_product");
            },
            icon: Icon(Icons.add_circle_outline, color: Colors.white),
            tooltip: "Add Product",
          ),
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<ProductsModel> products =
          ProductsModel.fromJsonList(value.products) as List<ProductsModel>;

          if (value.products.isEmpty) {
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
                    "No Products Found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Add your first product to get started",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, "/add_product");
                    },
                    icon: Icon(Icons.add, size: 20),
                    label: Text("Add Product"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72, // Optimized for content
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final discountPercent =
                ((product.old_price - product.new_price) /
                    product.old_price *
                    100)
                    .round();

                return GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, "/view_product", arguments: product),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          "Product Actions",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Choose an action for this product"),
                            SizedBox(height: 16),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, "/add_product",
                                    arguments: product);
                              },
                              leading: Icon(Icons.edit_outlined,
                                  color: Colors.blue.shade600),
                              title: Text("Edit Product"),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (context) => AdditionalConfirm(
                                    contentText:
                                    "Are you sure you want to delete this product? This action cannot be undone.",
                                    onYes: () {
                                      DbService()
                                          .deleteProduct(docId: product.id);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                          Text("Product deleted successfully"),
                                          backgroundColor: Colors.green.shade600,
                                        ),
                                      );
                                    },
                                    onNo: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                              leading: Icon(Icons.delete_outline,
                                  color: Colors.red.shade600),
                              title: Text("Delete Product"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image - Fixed height
                            Container(
                              height: 100, // Reduced from 120
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: Image.network(
                                  product.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(Icons.image_not_supported_outlined,
                                          color: Colors.grey.shade400),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // Product Details - More compact layout
                            Padding(
                              padding: const EdgeInsets.all(10.0), // Reduced padding
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Name
                                  Container(
                                    height: 32, // Fixed height for name
                                    child: Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: 12, // Smaller font
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  SizedBox(height: 4), // Minimal spacing

                                  // Price and Discount - Compact layout
                                  Row(
                                    children: [
                                      Text(
                                        "₹${product.new_price}",
                                        style: TextStyle(
                                          fontSize: 14, // Slightly smaller
                                          fontWeight: FontWeight.w700,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "₹${product.old_price}",
                                        style: TextStyle(
                                          fontSize: 10, // Smaller
                                          color: Colors.grey.shade600,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      if (discountPercent > 0) // Only show if there's a discount
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Text(
                                            "$discountPercent% OFF",
                                            style: TextStyle(
                                              fontSize: 8, // Very small
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red.shade700,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  SizedBox(height: 6), // Minimal spacing

                                  // Stock Status and Edit Button - Compact
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible( // Use Flexible instead of Expanded
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2), // Reduced padding
                                          decoration: BoxDecoration(
                                            color: product.maxQuantity == 0
                                                ? Colors.red.shade50
                                                : Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            product.maxQuantity == 0
                                                ? "Out of Stock"
                                                : "${product.maxQuantity} in stock",
                                            style: TextStyle(
                                              fontSize: 8, // Very small
                                              fontWeight: FontWeight.w600,
                                              color: product.maxQuantity == 0
                                                  ? Colors.red.shade700
                                                  : Colors.green.shade700,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4), // Minimal spacing
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, "/add_product",
                                              arguments: product);
                                        },
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            Icons.edit_outlined,
                                            size: 12, // Very small icon
                                            color: Colors.blue.shade600,
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

                        // Discount badge on top of image
                        if (discountPercent > 0)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.shade600,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "$discountPercent% OFF",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, "/add_product");
        },
        icon: Icon(Icons.add),
        label: Text("Add Product"),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}