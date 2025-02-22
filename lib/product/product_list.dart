import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/product/new_products.dart';

class ProductLists extends StatefulWidget {
  const ProductLists({super.key});

  @override
  State<ProductLists> createState() => _RestApiProductListState();
}

class _RestApiProductListState extends State<ProductLists> {
  List<dynamic> products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);

    try {
      var response = await http.get(Uri.parse('http://10.0.2.2:8001/products'));
      if (response.statusCode == 200) {
        setState(() => products = jsonDecode(response.body));
      } else {
        showSnackbar('Unable to fetch data');
      }
    } catch (e) {
      showSnackbar('Connection error occurred');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteProduct(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('ลบไม่ได้ช่วยให้ลืม'),
        content: const Text('แน่ใจอ่ะป่าวที่จะลบ Product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // ปิด Dialog

              try {
                var response = await http
                    .delete(Uri.parse('http://10.0.2.2:8001/products/$id'));

                if (response.statusCode == 200) {
                  fetchData();
                  showSnackbar('Product deleted successfully!', Colors.red);
                } else {
                  showSnackbar(
                      'Error occurred while deleting product', Colors.red);
                }
              } catch (e) {
                showSnackbar('Failed to delete product', Colors.red);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void showSnackbar(String message, [Color color = Colors.black]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Widget buildProductItem(Map<String, dynamic> product) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shadowColor: Colors.black54,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey[200],
          child: Text(
            '${product['id']}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          product['name'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${product['description']}',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${product['price']}',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewProducts(product: product),
                ),
              ).then((_) => fetchData()),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteProduct(product['id']),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Product Example',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 80),
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  buildProductItem(products[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewProducts()),
        ).then((_) => fetchData()),
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
