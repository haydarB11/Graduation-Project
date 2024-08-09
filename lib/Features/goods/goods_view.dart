// ignore_for_file: non_constant_identifier_names

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shamseenfactory/Features/goods/search_field.dart';
import 'package:shamseenfactory/constants.dart';
import 'dart:convert';

import 'package:shamseenfactory/core/utils/styles.dart';

import '../../generated/l10n.dart';
import 'category_card.dart';

class Category {
  final int id;
  String nameAr;
  String nameEn;
  double price;
  String type;
  String schoolType;
  String source;
  bool visibility;
  String photo;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
    required this.type,
    required this.schoolType,
    required this.source,
    required this.visibility,
    required this.photo,
  });
}

class GoodsView extends StatefulWidget {
  const GoodsView({Key? key}) : super(key: key);

  @override
  _GoodsViewState createState() => _GoodsViewState();
}

class _GoodsViewState extends State<GoodsView> {
  final TextEditingController _searchController = TextEditingController();
  List<Category> categories = [];
  List<Category> originalCategories = [];
  XFile? pickedImage;
  bool visibilityValue = true; // Default value

  bool isImagePicked = false;

  bool isLoading = true; // Add this line
  bool catLoding = false; // this loading for category loading
  Future<void> fetchCategories() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/managers/category/get-all'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> categoryData = jsonResponse['data'];

        final List<Category> fetchedCategories = categoryData.map((category) {
          print('fetchedCategories');
          return Category(
            id: category['id'],
            nameAr: category['name_ar'],
            nameEn: category['name_en'],
            price: category['price'].toDouble(),
            type: category['type'],
            schoolType: category['school_type'],
            source: category['source'],
            visibility: category['visibility'],
            photo: category['photo'],
          );
        }).toList();
        originalCategories = fetchedCategories;
        if (mounted) {
          setState(() {
            categories = fetchedCategories;
          });
        }
      } else {
        // Handle API error
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Exception while fetching categories: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> addCategory(
    String nameAr,
    String nameEn,
    double price,
    String type,
    String schoolType,
    String source,
    bool visibility,
    String? imagePath,
  ) async {
    final url = Uri.parse('$baseUrl/managers/category/add');
    final request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'name_ar': nameAr,
      'name_en': nameEn,
      'price': price.toString(),
      'type': type,
      'school_type': schoolType,
      'source': source,
      'visibility': visibility.toString(),
    });

    request.files.add(await http.MultipartFile.fromPath('photo', imagePath!));

    final response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseJson = json.decode(await response.stream.bytesToString());
      final int newCategoryId = responseJson['data']['id'];
      print("new id : $newCategoryId");
      setState(() {
        categories.add(
          Category(
            id: newCategoryId,
            nameAr: nameAr,
            nameEn: nameEn,
            price: price,
            type: type,
            schoolType: schoolType,
            source: source,
            visibility: visibility,
            photo: pickedImage!.path,
          ),
        );
      });
    } else {
      // ignore: use_build_context_synchronously

      print(response.reasonPhrase);
    }
  }

  void updateCategoriesList(int categoryId) {
    setState(() {
      categories.removeWhere((category) => category.id == categoryId);
      originalCategories.removeWhere((category) => category.id == categoryId);
    });
  }

  void showAddCategoryDialog(BuildContext context) {
    // bool catLoding = false; // this loading for category loading

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        TextEditingController nameArController = TextEditingController();
        TextEditingController nameEnController = TextEditingController();
        TextEditingController priceController = TextEditingController();
        TextEditingController typeController = TextEditingController();
        TextEditingController schoolTypeController = TextEditingController();
        TextEditingController sourceController = TextEditingController();
        TextEditingController visibilityController = TextEditingController();
        // ... other controllers for different input fields
        final _formKey = GlobalKey<FormState>();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            S.of(context).addNewCategory,
            style: Styles.titleDialog,
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameArController,
                    decoration: InputDecoration(
                        labelText: S.of(context).categoryNameArabic),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).pleaseEnterValidName;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: nameEnController,
                    decoration: InputDecoration(
                        labelText: S.of(context).categoryNameEnglish),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).pleaseEnterValidName;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    controller: priceController,
                    decoration: const InputDecoration(
                        labelText: 'Price', labelStyle: Styles.textStyle12),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).pleaseEnterValidName;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButtonFormField<String>(
                    // value: 'damage',

                    // Set initial value
                    onChanged: (newValue) {
                      setState(() {
                        // Update the selected type value
                        typeController.text = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'damage',
                        child: Text('Damage'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'store',
                        child: Text('Store'),
                      ),
                    ],
                    decoration: InputDecoration(
                        labelText: S.of(context).type,
                        labelStyle: Styles.textStyle12),
                  ),
                  DropdownButtonFormField<String>(
                    // value: 'school',
                    // Set initial value
                    onChanged: (newValue) {
                      setState(() {
                        // Update the selected school type value
                        schoolTypeController.text = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'school',
                        child: Text('School'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'kindergarten',
                        child: Text('Kindergarten'),
                      ),
                    ],
                    decoration: InputDecoration(
                        labelText: S.of(context).schoolType,
                        labelStyle: Styles.textStyle12),
                  ),

                  DropdownButtonFormField<String>(
                    // Set initial value
                    // value: "internal",
                    onChanged: (newValue) {
                      setState(() {
                        // Update the selected source value
                        sourceController.text = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: "internal",
                        child: Text('Internal'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'external',
                        child: Text('External'),
                      ),
                    ],
                    decoration: InputDecoration(
                        labelText: S.of(context).source,
                        labelStyle: Styles.textStyle12),
                  ),

                  DropdownButtonFormField<bool>(
                    // Set initial value to true
                    onChanged: (newValue) {
                      setState(() {
                        // Update the selected visibility value
                        visibilityValue = newValue!;
                        visibilityController.text = newValue.toString();
                      });
                    },
                    items: const [
                      DropdownMenuItem<bool>(
                        value: true,
                        child: Text('True'),
                      ),
                      DropdownMenuItem<bool>(
                        value: false,
                        child: Text('False'),
                      ),
                    ],
                    decoration: InputDecoration(
                        labelText: S.of(context).visibility,
                        labelStyle: Styles.textStyle12),
                  ),

                  // Add a button to pick an image from the gallery
                  SizedBox(
                    height: 14,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      XFile? pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (pickedFile != null) {
                        setState(() {
                          pickedImage = pickedFile;
                          print(pickedImage?.path);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).pleasePickImage),
                          ),
                        );
                      }
                    },
                    child: Text(
                      S.of(context).pickImage,
                      style: Styles.textStyle16,
                    ),
                  ),
                  if (catLoding) CircularProgressIndicator(),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                print(visibilityController.text);
              },
              child:
                  Text(S.of(context).cancel, style: Styles.styleCanselButton),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (pickedImage == null) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(S.of(context).pleasePickImage),
                    //   ),
                    // );
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(S.of(context).pleasePickImage),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(S.of(context).ok),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  if (typeController.text.isEmpty ||
                      schoolTypeController.text.isEmpty ||
                      sourceController.text.isEmpty ||
                      visibilityController.text.isEmpty) {
                    print(typeController.text);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text('complete your field'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(S.of(context).ok),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  setState(() {
                    catLoding = true;
                  });
                  try {
                    await addCategory(
                      nameArController.text,
                      nameEnController.text,
                      double.parse(priceController.text),
                      typeController.text,
                      schoolTypeController.text,
                      sourceController.text,
                      visibilityValue,
                      pickedImage!.path, // Pass the image path here
                    );
                    fetchCategories();
                    catLoding = false;
                    Navigator.of(dialogContext).pop(true);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(content: Text('Error')),
                    );
                  }
                }
                print(" type ${typeController.text}");
                print("stype${schoolTypeController.text}");
                print("s${sourceController.text}");
              },
              child: Text(
                S.of(context).add,
                style: Styles.textStyle16,
              ),
            ),
          ],
        );
      },
    );
  }

  void filterCategories(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      categories = originalCategories.where((category) {
        return category.nameAr.toLowerCase().contains(lowerCaseQuery) ||
            category.nameEn.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [kBlueLightColor, kBlueColor],
              begin: FractionalOffset(0.0, 0.4),
              end: Alignment.topRight),
        ),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: deafultpadding * 2,
                      left: deafultpadding,
                      right: deafultpadding),
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          GoRouter.of(context).pop();
                          print('object');
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SearchFieldGoods(
                        searchController: _searchController,
                        onchange: filterCategories,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                if (isLoading)
                  const Center(
                      child: SpinKitSpinningLines(
                    size: 35,
                    color: hBackgroundColor,
                  )),
                if (!isLoading)
                  FadeInDown(
                    delay: Duration(milliseconds: 500),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 164,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(70))),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, childAspectRatio: 2 / 3.1),
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          final category = categories[index];
                          return CategoryWidget(
                              category: category,
                              onDelete: updateCategoriesList);
                        },
                      ),
                    ),
                  ),
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddCategoryDialog(context);
        },
        backgroundColor: Colors.lightGreen,
        child: const Icon(Icons.add),
      ),
    ));
  }
}
