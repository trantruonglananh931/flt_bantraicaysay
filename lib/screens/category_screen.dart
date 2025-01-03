import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Category.dart';
import '../providers/category_provider.dart';
import '../services/user_service.dart'; // Import UserService

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userService = UserService(); // Khởi tạo UserService

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Categories"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final token = await userService.getToken(); // Lấy token
              if (token != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoryFormScreen(token: token)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Token not found. Please log in again.")),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: userService.getToken(), // Lấy token từ UserService
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'Error: Unable to fetch token. Please log in again.',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            final token = snapshot.data as String; // Token đã được lấy thành công
            return FutureBuilder(
              future: Provider.of<CategoryProvider>(context, listen: false).fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return Consumer<CategoryProvider>(
                    builder: (context, categoryProvider, child) {
                      if (categoryProvider.categories.isEmpty) {
                        return Center(child: Text("No categories available."));
                      }
                      return ListView.builder(
                        itemCount: categoryProvider.categories.length,
                        itemBuilder: (context, index) {
                          final category = categoryProvider.categories[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(
                                category.name ?? 'No Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CategoryFormScreen(
                                            token: token,
                                            category: Category(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final confirm = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Delete Category"),
                                          content: Text("Are you sure you want to delete this category?"),
                                          actions: [
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () => Navigator.of(context).pop(false),
                                            ),
                                            TextButton(
                                              child: Text("Delete"),
                                              onPressed: () => Navigator.of(context).pop(true),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        try {
                                          await categoryProvider.deleteCategory(token, category.id!.toString());
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Category deleted successfully.")),
                                          );
                                        } catch (error) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Failed to delete category.")),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
class CategoryFormScreen extends StatefulWidget {
  final String token; // Thêm token
  final Category? category;

  CategoryFormScreen({required this.token, this.category});

  @override
  _CategoryFormScreenState createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _name = widget.category!.name;
    }
  }

  void _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final categoryData = {'name': _name};

    try {
      if (widget.category == null) {
        await Provider.of<CategoryProvider>(context, listen: false).addCategory(
          widget.token, // Truyền token
          categoryData,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Category added successfully.")),
        );
      } else {
        await Provider.of<CategoryProvider>(context, listen: false).updateCategory(
          widget.token, // Truyền token
          widget.category!.id!.toString(),
          categoryData,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Category updated successfully.")),
        );
      }
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save category.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? "Add Category" : "Edit Category"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: "Category Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a category name.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Save"),
                onPressed: _saveForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

