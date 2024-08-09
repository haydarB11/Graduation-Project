import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class SchoolDetailsBillScreen extends StatefulWidget {
  final int schoolId;
  final DateTime selectedDate;
  final String type;

  SchoolDetailsBillScreen(
      {required this.schoolId, required this.selectedDate, required this.type});

  @override
  _SchoolDetailsBillScreenState createState() =>
      _SchoolDetailsBillScreenState();
}

class _SchoolDetailsBillScreenState extends State<SchoolDetailsBillScreen> {
  List<Map<String, dynamic>> _billsData = [];
  bool _isLoading = true;
  String? _error;
  bool _isEditing = false;
  bool dateEditing = false;
  List<int> selectedCategoryIds = [];
  List<Category> _categories = [];
  @override
  void initState() {
    super.initState();
    _fetchSchoolDetailsAndBills();
    _fetchCategories();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true; // Show loading indicator
      _error = null; // Clear any previous errors
    });

    try {
      // Fetch data again (you can reuse your existing fetch logic here)
      await _fetchSchoolDetailsAndBills();
    } catch (error) {
      setState(() {
        _error = 'Error fetching data: $error'; // Handle error
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> _showDeleteConfirmationDialogBill(int billId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).confirmDelete),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(S.of(context).confirmDeleteBill),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(S.of(context).delete),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                // Call the deleteBill function to delete the bill
                await deleteBill(billId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteBill(int billId) async {
    final Uri uri = Uri.parse('$baseUrl/bill/delete/$billId');

    try {
      print(billId);
      final http.Response response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Bill deleted successfully
        print('Bill deleted successfully');
        await _refreshData(); // Refresh data after deletion
      } else {
        // Failed to delete bill
        print('Failed to delete bill: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error deleting bill: $error');
    }
  }

  Future<void> _updateCategoryAmount(
      int billId, Map<String, dynamic> category) async {
    try {
      final String apiUrl = '$baseUrl/bill/category/update/${category['id']}';

      final Map<String, dynamic> requestBody = {
        'amount': category['amount'],
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Category amount updated successfully');
        // Optionally, you can update the local data with the new response data.
      } else {
        print(response.reasonPhrase);
        // Handle error cases
      }
      await _refreshData();
    } catch (error) {
      print('Error updating category amount: $error');
      // Handle network or other errors
    }
  }

  Future<void> deleteCategories(List<int> categoryIds) async {
    final Uri uri = Uri.parse('$baseUrl/bill/category/delete');

    final Map<String, dynamic> requestBody = {
      'bill_category_ids': categoryIds,
    };

    try {
      final http.Response response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      print("from delte category ${response.statusCode}");
      if (response.statusCode == 200) {
        print('Categories deleted successfully');
        print(response.body); // You can print the response body if needed
      } else {
        print('Failed to delete categories: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error deleting categories: $error');
    }
  }

  Future<void> _fetchSchoolDetailsAndBills() async {
    try {
      final formattedDate =
          DateFormat('yyyy-MM-dd', 'en').format(widget.selectedDate);
// Use current date or select a date.
      print(formattedDate);
      final response = await http.post(
        Uri.parse('$baseUrl/schools/bills/${widget.schoolId}'),
        body: json.encode({'date': formattedDate, 'type': widget.type}),
        headers: {'Content-Type': 'application/json'},
      );
      print("in this details");
      print(response.body);
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['data'] is List) {
          final dataList = responseBody['data'].cast<Map<String, dynamic>>();
          if (mounted) {
            setState(() {
              _billsData = dataList;
              _isLoading = false;
            });
          }
        }
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Error: ${response.reasonPhrase}';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _error = 'Error fetching data2: $error';
      });
    }
  }

  Future<void> _fetchCategories() async {
    final Uri uri = Uri.parse('$baseUrl/category/get-all-visible');

    try {
      final http.Response response = await http.get(uri);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final List<dynamic> categoryList = json.decode(response.body)['data'];
        if (mounted) {
          setState(() {
            _categories =
                categoryList.map((json) => Category.fromJson(json)).toList();
          });
          print(_categories);
        }
      } else {
        print('Failed to fetch categories: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  Future<void> addCategoriesToBill(
      int billId, List<Map<String, dynamic>> categories) async {
    final Uri uri = Uri.parse('$baseUrl/bill/categories/add/$billId');

    try {
      final http.Response response = await http.post(
        uri,
        body: jsonEncode({'bills': categories}),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print("fromadd");
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Categories added successfully');
        print(response.body); // You can print the response body if needed
      } else {
        print('Failed to add categories to bill: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error adding categories to bill: $error');
    }
  }

  Future<void> _updateBillDate(int billId, String newDate) async {
    try {
      final url = Uri.parse('$baseUrl/bill/update-date/$billId');

      final Map<String, String> headers = {
        'Content-Type': 'application/json', // Set the content type
      };

      final body = {
        "date": newDate,
      };

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body), // Serialize the body to JSON
      );

      if (response.statusCode == 200) {
        print('Bill date updated successfully');
        print(await response.body);
      } else {
        print('Failed to update bill date: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('An error occurred while updating bill date: $e');
      // Handle the error as needed, e.g., show an error message to the user
    }
  }

  void _showDatePicker(BuildContext context, Map<String, dynamic> bill) async {
    final initialDate = DateTime.parse(bill['date']);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != initialDate) {
      final newDate = DateFormat('yyyy-MM-dd', 'en').format(pickedDate);

      try {
        // Attempt to update the bill date on the server
        await _updateBillDate(bill['id'], newDate);

        // If the server update was successful, update the UI
        setState(() {
          bill['date'] = newDate;
        });
      } catch (e) {
        // Handle any errors that occur during the server update
        print('Error updating bill date on the server: $e');
        // You can show an error message to the user if needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueLightColor,
        title: Text(
          S.of(context).schoolDetailsAndBills,
          style: Styles.textStyle20.copyWith(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _buildBillList(),
    );
  }

  Widget _buildBillList() {
    if (_billsData.isEmpty) {
      return Center(
        child: Text(S.of(context).noBillsAvailableForDate),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: _billsData.length,
        itemBuilder: (context, index) {
          final schoolData = _billsData[index];
          final schoolNameAr = schoolData['school']['name_ar'];
          final schoolNameEn = schoolData['school']['name_en'];
          final sellPointName = schoolData['sp_name'];
          final bills = schoolData['bills'];

          return _buildSchoolBillCard(
            schoolNameAr,
            schoolNameEn,
            sellPointName,
            bills,
          );
        },
      ),
    );
  }

  Widget _buildSchoolBillCard(
    String schoolNameAr,
    String schoolNameEn,
    String sellPointName,
    List<dynamic> bills,
  ) {
    double totalBillPrice = 0.0; // Initialize total price to 0.0
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bills.map((bill) {
        final billCategories = bill['bill_categories'];
        totalBillPrice = 0.0; // Reset total price for each bill

        if (billCategories != null) {
          for (final category in billCategories) {
            final totalPrice = category['total_price'];
            if (totalPrice != null) {
              totalBillPrice += totalPrice;
            }
          }
        }

        return Card(
          margin: const EdgeInsets.all(10),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schoolNameAr,
                  style: Styles.textStyle14,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _showDeleteConfirmationDialogBill(bill['id']);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red.withOpacity(0.6),
                      ),
                      label: Text(S.of(context).deleteThisBill,
                          style: Styles.textStyle14),
                      style: ElevatedButton.styleFrom(
                        // Customize the button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Adjust the border radius as needed
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Add spacing between buttons
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddCategoryDialog(
                              categories: _categories,
                              onCategoryAdded:
                                  (selectedCategory, amount) async {
                                final categoryData = {
                                  'amount': amount,
                                  'category_id': selectedCategory.id,
                                };

                                final billId = bill['id'];
                                await addCategoriesToBill(
                                    billId, [categoryData]);
                                await _refreshData();
                              },
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.green,
                      ),
                      label: Text(S.of(context).addCategory,
                          style: Styles.textStyle14),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Adjust the border radius as needed
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd', 'en')
                          .format(DateTime.parse(bill['date'])),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      // You can adjust the font size and other text styles as needed
                    ),
                    decoration: InputDecoration(
                        labelText: S.of(context).theDate,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey, // Customize the label color
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Adjust border radius as needed
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey, // Customize the border color
                          ),
                          borderRadius: BorderRadius.circular(
                              8), // Adjust border radius as needed
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color:
                                  kActiveIconColor // Customize the border color when focused
                              ),
                          borderRadius: BorderRadius.circular(
                              8), // Adjust border radius as needed
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            // Customize the icon color
                          ),
                          onPressed: () {
                            _showDatePicker(context, bill);
                          },
                        )),
                    readOnly: !dateEditing,
                    onTap: () {
                      if (dateEditing) {
                        _showDatePicker(context, bill);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${S.of(context).billF}: ${bill['id'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 16, // Adjust the font size as needed
                          fontWeight: FontWeight.normal,
                          color: Colors.black87, // Customize the color
                        ),
                      ),
                      TextSpan(
                        text: '\n${S.of(context).totalPriceForAllCategories} ',
                        style: const TextStyle(
                          fontSize: 16, // Adjust the font size as needed
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Customize the color
                        ),
                      ),
                      TextSpan(
                        text: '$totalBillPrice',
                        style: const TextStyle(
                          fontSize: 16, // Adjust the font size as needed
                          fontWeight: FontWeight.normal,
                          color: Colors.black87, // Customize the color
                        ),
                      ),
                    ],
                  ),
                ),
                Text(S.of(context).categoriesInBill, style: Styles.textStyle16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: billCategories.map<Widget>((category) {
                    final TextEditingController controller =
                        TextEditingController(
                      text: category['amount']?.toString() ?? '',
                    );
                    final categoryId = category['id'];
                    final bool isSelected =
                        selectedCategoryIds.contains(categoryId);

                    // Check if 'category' or 'category['category']' is null
                    if (category == null || category['category'] == null) {
                      // You can return a placeholder or handle this case as needed
                      return SizedBox(); // Placeholder widget (empty container)
                    }

                    final categoryNameAr =
                        category['category']['name_ar'] ?? '';

                    return Card(
                      child: ListTile(
                        title: Text(
                          '${S.of(context).categoryName}  $categoryNameAr',
                          style: Styles.textStyle14
                              .copyWith(color: kActiveIconColor),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: controller,
                                    decoration: InputDecoration(
                                      labelText: S.of(context).editAmount,
                                      labelStyle: Styles.textStyle12,
                                      enabled: _isEditing,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (newValue) {
                                      // Validate if newValue is a valid number
                                      if (newValue.isEmpty) {
                                        // Handle empty input (optional)
                                        setState(() {
                                          category['amount'] = 0;
                                        });
                                      } else {
                                        try {
                                          final int parsedValue =
                                              int.parse(newValue);
                                          category['amount'] = parsedValue;
                                        } catch (e) {
                                          // Handle invalid input (non-numeric)
                                          // You can show an error message or set to a default value
                                        }
                                      }
                                    },
                                    readOnly: !_isEditing,
                                  ),
                                ),
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      if (newValue != null) {
                                        if (newValue) {
                                          selectedCategoryIds.add(categoryId);
                                        } else {
                                          selectedCategoryIds
                                              .remove(categoryId);
                                        }
                                      }
                                    });
                                  },
                                ),
                                if (!_isEditing)
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = true;
                                      });
                                    },
                                    child: Text(S.of(context).edit),
                                  ),
                                if (_isEditing)
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Save the edited amount
                                      await _updateCategoryAmount(
                                          bill['id'], category);
                                      setState(() {
                                        _isEditing = false;
                                      });
                                    },
                                    child: Text(S.of(context).save),
                                  ),
                                if (_isEditing)
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = false;
                                      });
                                    },
                                    child: Text(S.of(context).cancel),
                                  ),
                              ],
                            ),
                            Text(
                              '${S.of(context).totalPrice} ${category['total_price'] ?? ''}',
                              style: Styles.textStyle14,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (selectedCategoryIds.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      if (selectedCategoryIds.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteConfirmationDialog(
                              onConfirm: () async {
                                // Call the deleteCategories function to delete selected categories
                                await deleteCategories(selectedCategoryIds);

                                // After deletion, refresh the data if necessary
                                await _refreshData();

                                // Clear the selection
                                setState(() {
                                  selectedCategoryIds = [];
                                });
                              },
                            );
                          },
                        );
                      } else {
                        // Show a message that no categories are selected for deletion
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('No categories selected for deletion.'),
                          ),
                        );
                      }
                    },
                    child: Text(S.of(context).deleteSelectedCategories),
                  )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  DeleteConfirmationDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).confirmDelete),
      content: Text(S.of(context).confirmDeleteCategories),
      actions: <Widget>[
        TextButton(
          child: Text(S.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: Text(S.of(context).delete),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onConfirm(); // Trigger the deletion callback
          },
        ),
      ],
    );
  }
}

class Category {
  final int id;
  final String nameAr;
  final String nameEn;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
    );
  }
}

class AddCategoryDialog extends StatefulWidget {
  final List<Category> categories;
  final Function(Category, int) onCategoryAdded;

  AddCategoryDialog({required this.categories, required this.onCategoryAdded});

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  Category? selectedCategory;
  int amount = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        S.of(context).addCategory,
        style: Styles.titleDialog,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<Category>(
            hint: Text(
              S.of(context).selectCategory,
              style: Styles.titleDialog,
            ),
            value: selectedCategory,
            items: widget.categories.map((Category category) {
              return DropdownMenuItem<Category>(
                value: category,
                child: Text(category.nameAr),
              );
            }).toList(),
            onChanged: (Category? newValue) {
              setState(() {
                selectedCategory = newValue;
              });
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(hintText: "ادخل الكمية"),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                amount = int.tryParse(value) ?? 0;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            S.of(context).cancel,
            style: Styles.textStyle14,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            S.of(context).add,
            style: Styles.textStyle14,
          ),
          onPressed: () {
            if (selectedCategory != null && amount > 0) {
              widget.onCategoryAdded(selectedCategory!, amount);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
