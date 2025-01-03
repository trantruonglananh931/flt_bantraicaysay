import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import '../providers/auth_provider.dart';

class AdmProductScreen extends StatefulWidget {
  const AdmProductScreen({Key? key}) : super(key: key);

  @override
  State<AdmProductScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdmProductScreen> {
  final ProductService _productService = ProductService();
  List<dynamic> _products = [];
  bool _isLoading = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      if (token != null) {
        final products = await _productService.getProducts();
        setState(() {
          _products = products;
        });
      } else {
        _showSnackBar('Không tìm thấy token! Vui lòng đăng nhập lại.');
      }
    } catch (e) {
      _showSnackBar('Không thể tải danh sách sản phẩm: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> createProduct(Map<String, dynamic> productData) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      if (token != null) {
        if (_selectedImage != null) {
          productData['thumbnail'] = _selectedImage;
        }
        await _productService.createProduct(token, productData);
        _showSnackBar('Tạo sản phẩm thành công!');
        fetchProducts();
      } else {
        _showSnackBar('Không tìm thấy token! Vui lòng đăng nhập lại.');
      }
    } catch (e) {
      _showSnackBar('Không thể tạo sản phẩm: $e');
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> productData) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      if (token != null) {
        await _productService.updateProduct(token, id, productData);
        _showSnackBar('Cập nhật sản phẩm thành công!');
        fetchProducts();
      } else {
        _showSnackBar('Không tìm thấy token! Vui lòng đăng nhập lại.');
      }
    } catch (e) {
      _showSnackBar('Không thể cập nhật sản phẩm: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      if (token != null) {
        await _productService.deleteProduct(token, id);
        _showSnackBar('Xóa sản phẩm thành công!');
        fetchProducts();
      } else {
        _showSnackBar('Không tìm thấy token! Vui lòng đăng nhập lại.');
      }
    } catch (e) {
      _showSnackBar('Không thể xóa sản phẩm: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Danh sách sản phẩm', style: TextStyle(color: const Color(0xFF8C5A3A))),
        backgroundColor: const Color(0xFFFCB465),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchProducts,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                child: product['thumbnail'] != null
                    ? Image.network(
                  product['thumbnail'],
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.image),
              ),
              title: Text(
                product['name'],
                style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFF995F26)),
              ),
              subtitle: Text('Giá: ${product['price']} VND'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      showProductDialog(product: product);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteProduct(product['id'].toString());
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showProductDialog();
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFFCB465),
      ),
    );
  }

  void showProductDialog({Map<String, dynamic>? product}) {
    final nameController = TextEditingController(text: product?['name'] ?? '');
    final priceController = TextEditingController(text: product?['price']?.toString() ?? '');
    final weightController = TextEditingController(text: product?['weight']?.toString() ?? '');
    final descriptionController = TextEditingController(text: product?['description'] ?? '');

    final categories = {'Xoài': 1, 'Chuối': 2};
    String selectedCategoryName = product?['category_name'] ?? 'Xoài';
    int selectedCategoryId = categories[selectedCategoryName]!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Tạo sản phẩm' : 'Cập nhật sản phẩm'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Giá'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: weightController,
                  decoration: const InputDecoration(labelText: 'Trọng lượng'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Mô tả'),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: selectedCategoryName,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategoryName = newValue!;
                      selectedCategoryId = categories[selectedCategoryName]!;
                    });
                  },
                  items: categories.keys.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text('Chọn ảnh'),
                ),
                if (_selectedImage != null)
                  Image.file(
                    _selectedImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final productData = {
                  'name': nameController.text,
                  'price': double.tryParse(priceController.text) ?? 0,
                  'weight': double.tryParse(weightController.text) ?? 0,
                  'description': descriptionController.text,
                  'category_id': selectedCategoryId,
                  'image': _selectedImage,
                };

                if (product == null) {
                  createProduct(productData);
                } else {
                  updateProduct(product['id'].toString(), productData);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}
