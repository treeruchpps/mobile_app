import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewProducts extends StatefulWidget {
  final dynamic? product;
  const NewProducts({super.key, this.product});

  @override
  State<NewProducts> createState() => _RestApiProductFromState();
}

class _RestApiProductFromState extends State<NewProducts> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      nameController.text = widget.product!['name'];
      descController.text = widget.product!['description'];
      priceController.text = widget.product!['price'].toString();
    }
  }

  Future<void> saveProduct() async {
    var url = widget.product == null
        ? 'http://10.0.2.2:8001/products'
        : 'http://10.0.2.2:8001/products/${widget.product!['id']}';

    var response = await (widget.product == null
        ? http.post(Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "name": nameController.text,
              "description": descController.text,
              "price": double.tryParse(priceController.text) ?? 0.0,
            }))
        : http.put(Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "name": nameController.text,
              "description": descController.text,
              "price": double.tryParse(priceController.text) ?? 0.0,
            })));

    if (response.statusCode == 201 || response.statusCode == 200) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.product == null
              ? 'Product added successfully!'
              : 'Product updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('เกิดข้อผิดพลาด!'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> deleteProduct(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                var response = await http
                    .delete(Uri.parse('http://10.0.2.2:8001/products/$id'));
                if (response.statusCode == 200) {
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Error occurred while deleting product'),
                        backgroundColor: Colors.red),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Failed to delete product'),
                      backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Add Product' : 'Edit Product',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                if (widget.product != null)
                  SizedBox(
                    width: double.infinity, // ให้ปุ่ม Delete กว้างเต็ม
                    child: ElevatedButton(
                      onPressed: () => deleteProduct(widget.product!['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12), // ให้ความสูงเท่ากัน
                        elevation: 4, // เพิ่มเงาให้ดูโดดเด่น
                      ),
                      child: const Text('Delete',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Save',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
