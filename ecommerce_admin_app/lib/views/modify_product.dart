import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:ecommerce_admin_app/controllers/cloudinary_service.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/products_model.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ModifyProduct extends StatefulWidget {
  const ModifyProduct({super.key});

  @override
  State<ModifyProduct> createState() => _ModifyProductState();
}

class _ModifyProductState extends State<ModifyProduct> {
  late String productId = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPriceController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;
  Uint8List? _imageBytes;

  void _pickImageAndCloudinaryUpload() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var bytes = await image!.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });

      String? res = await uploadToCloudinary(image);
      setState(() {
        if (res != null) {
          imageController.text = res;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Image uploaded successfully"),
              backgroundColor: Colors.green.shade600,
            ),
          );
        }
      });
    }
  }

  setData(ProductsModel data) {
    productId = data.id;
    nameController.text = data.name;
    oldPriceController.text = data.old_price.toString();
    newPriceController.text = data.new_price.toString();
    quantityController.text = data.maxQuantity.toString();
    categoryController.text = data.category;
    descController.text = data.description;
    imageController.text = data.image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is ProductsModel) {
      setData(arguments);
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          productId.isNotEmpty ? "Update Product" : "Add Product",
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
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productId.isNotEmpty
                      ? "Update Product Details"
                      : "Create New Product",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 20),

                // Product Image Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Product Image",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickImageAndCloudinaryUpload,
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: _imageBytes != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            _imageBytes!,
                            fit: BoxFit.cover,
                          ),
                        )
                            : imageController.text.isNotEmpty
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_outlined,
                                        size: 48,
                                        color: Colors.grey.shade400),
                                    SizedBox(height: 8),
                                    Text(
                                      "Image Preview",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                            : Center(
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload_outlined,
                                  size: 48,
                                  color: Colors.blue.shade600),
                              SizedBox(height: 12),
                              Text(
                                "Tap to upload product image",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _pickImageAndCloudinaryUpload,
                      icon: Icon(Icons.cloud_upload_outlined, size: 18),
                      label: Text("Upload Image"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Basic Information
                Text(
                  "Basic Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 16),

                _buildTextField(
                  controller: nameController,
                  label: "Product Name",
                  hint: "Enter product name",
                  icon: Icons.shopping_bag_outlined,
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: oldPriceController,
                        label: "Original Price",
                        hint: "₹ 0",
                        icon: Icons.attach_money_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: newPriceController,
                        label: "Selling Price",
                        hint: "₹ 0",
                        icon: Icons.price_change_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                _buildTextField(
                  controller: quantityController,
                  label: "Stock Quantity",
                  hint: "Enter available quantity",
                  icon: Icons.inventory_outlined,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),

                _buildTextField(
                  controller: categoryController,
                  label: "Category",
                  hint: "Select category",
                  icon: Icons.category_outlined,
                  readOnly: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          "Select Category",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        content: Consumer<AdminProvider>(
                          builder: (context, value, child) => SizedBox(
                            width: double.maxFinite,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: value.categories.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    categoryController.text =
                                    value.categories[index]["name"];
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.shade50,
                                    child: Icon(Icons.category_outlined,
                                        size: 18, color: Colors.blue.shade600),
                                  ),
                                  title: Text(
                                    value.categories[index]["name"],
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),

                // Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: descController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Enter product description...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade600),
                        ),
                        contentPadding: EdgeInsets.all(16),
                      ),
                      validator: (v) =>
                      v!.isEmpty ? "Description is required." : null,
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Image URL Field
                _buildTextField(
                  controller: imageController,
                  label: "Image URL",
                  hint: "Paste image URL here",
                  icon: Icons.link_outlined,
                  validator: (v) => v!.isEmpty ? "Image URL is required." : null,
                ),

                SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Map<String, dynamic> data = {
                          "name": nameController.text,
                          "old_price": int.parse(oldPriceController.text),
                          "new_price": int.parse(newPriceController.text),
                          "quantity": int.parse(quantityController.text),
                          "category": categoryController.text,
                          "desc": descController.text,
                          "image": imageController.text
                        };

                        if (productId.isNotEmpty) {
                          DbService()
                              .updateProduct(docId: productId, data: data);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("✅ Product Updated Successfully"),
                              backgroundColor: Colors.green.shade600,
                            ),
                          );
                        } else {
                          DbService().createProduct(data: data);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("✅ Product Added Successfully"),
                              backgroundColor: Colors.green.shade600,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      productId.isNotEmpty
                          ? "Update Product"
                          : "Add Product",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey.shade600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade600),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: readOnly ? Colors.grey.shade50 : Colors.white,
          ),
          validator: validator ??
                  (v) => v!.isEmpty ? "$label is required." : null,
        ),
      ],
    );
  }
}