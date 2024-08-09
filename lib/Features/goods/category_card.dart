import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:http/http.dart' as http;
import 'package:shamseenfactory/generated/l10n.dart';
import 'goods_view.dart';

class CategoryWidget extends StatefulWidget {
  final Category category;
  final Function(int) onDelete;

  const CategoryWidget({required this.category, required this.onDelete});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool isNewPhotoSelected = false;
  List<Category> categories = [];
  Future<void> updateCategory(
    int categoryId,
    String nameAr,
    String nameEn,
    double price,
    String type,
    String schoolType,
    String source,
    bool visibility,
    String? imagePath,
    String oldPhotoPath,
  ) async {
    final url = Uri.parse('$baseUrl/managers/category/update/$categoryId');
    final request = http.MultipartRequest('PUT', url);
    print("this iddd $categoryId");
    request.fields.addAll({
      'name_ar': nameAr,
      'name_en': nameEn,
      'price': price.toString(),
      'type': type,
      'school_type': schoolType,
      'source': source,
      'visibility': visibility.toString(),
    });

    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', imagePath));
    }

    print('type n ${schoolType}');
    print("update 2 ${request.fields}");
    final response = await request.send();
    print("update ${response.statusCode}");

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  void showEditCategoryDialog(BuildContext context) {
    // Initialize controllers with existing category data
    TextEditingController nameArController =
        TextEditingController(text: widget.category.nameAr);
    TextEditingController nameEnController =
        TextEditingController(text: widget.category.nameEn);
    TextEditingController priceController =
        TextEditingController(text: widget.category.price.toString());

    TextEditingController typeController =
        TextEditingController(text: widget.category.type);
    TextEditingController schoolTypeController =
        TextEditingController(text: widget.category.schoolType);
    TextEditingController sourceController =
        TextEditingController(text: widget.category.source);
    bool visibilityValue = widget.category.visibility;
    XFile? pickedImage;
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        String oldPhotoPath = widget.category.photo;
        XFile? pickedImage;
        String? imagePath;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(S.of(context).editCategory),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameArController,
                    decoration: InputDecoration(
                      labelText: S.of(context).categoryNameArabic,
                    ),
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
                      labelText: S.of(context).categoryNameEnglish,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).pleaseEnterValidName;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: S.of(context).price),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).pleaseEnterValidPrice;
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    // Set initial value
                    value: typeController.text,
                    onChanged: (newValue) {
                      setState(() {
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
                    decoration: InputDecoration(labelText: S.of(context).type),
                  ),
                  DropdownButtonFormField<String>(
                    // Set initial value
                    value: schoolTypeController.text,
                    onChanged: (newValue) {
                      setState(() {
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
                    decoration:
                        InputDecoration(labelText: S.of(context).schoolType),
                  ),
                  DropdownButtonFormField<String>(
                    // Set initial value
                    value: sourceController.text,
                    onChanged: (newValue) {
                      setState(() {
                        sourceController.text = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'internal',
                        child: Text('Internal'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'external',
                        child: Text('External'),
                      ),
                    ],
                    decoration:
                        InputDecoration(labelText: S.of(context).source),
                  ),
                  DropdownButtonFormField<bool>(
                    // Set initial value
                    value: visibilityValue,
                    onChanged: (newValue) {
                      setState(() {
                        visibilityValue = newValue!;
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
                    decoration:
                        InputDecoration(labelText: S.of(context).visibility),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      XFile? pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      print(pickedFile);
                      if (pickedFile != null) {
                        print(pickedFile);
                        setState(() {
                          pickedImage = pickedFile;
                          isNewPhotoSelected = true;
                          imagePath = pickedFile.path;
                          print(pickedImage?.path);
                        });
                        print(imagePath);
                      }
                    },
                    child: Text(S.of(context).pickImage),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                S.of(context).cancel,
                style: Styles.styleCanselButton,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                oldPhotoPath = widget.category.photo;
                // Validate the form
                if (_formKey.currentState!.validate()) {
                  // Update the category with new data
                  await updateCategory(
                      widget.category.id,
                      nameArController.text,
                      nameEnController.text,
                      double.parse(priceController.text),
                      typeController.text,
                      schoolTypeController.text,
                      sourceController.text,
                      visibilityValue,
                      pickedImage?.path,
                      oldPhotoPath // Pass the image path here
                      );
                  setState(() {
                    widget.category.nameAr = nameArController.text;
                    widget.category.nameEn = nameEnController.text;
                    widget.category.price = double.parse(priceController.text);
                    widget.category.type = typeController.text;
                    widget.category.schoolType = schoolTypeController.text;
                    widget.category.source = sourceController.text;
                    widget.category.visibility = visibilityValue;
                    if (pickedImage?.path != null) {
                      widget.category.photo = pickedImage!.path;
                    }
                  });
                  Navigator.of(dialogContext).pop(); // Close the dialog
                }
              },
              child: Text(S.of(context).update),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCategory(int categoryId) async {
    final url = Uri.parse('$baseUrl/managers/category/delete/$categoryId');
    final response = await http.delete(url);
    print('this id :  $categoryId');
    if (response.statusCode == 200) {
      print('Category deleted successfully');
      setState(() {
        widget.onDelete(categoryId);
      });
      // Show a success dialog
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).deletionSuccessful),
            content: const Text('The category has been successfully deleted.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).ok),
              ),
            ],
          );
        },
      );
    } else {
      print('Error deleting category: ${response.reasonPhrase}');
      // Show an error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Deletion Failed'),
            content: const Text('Failed to delete the category.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).ok),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> updateVisibility(bool newVisibility) async {
    final uri = Uri.parse(
        '$baseUrl/category/update/${widget.category.id}/?active=${newVisibility ? 1 : 0}');
    final response = await http.put(uri);
    print("${widget.category.id}");
    print("from update visabily category${response.statusCode}");
    if (response.statusCode == 200) {
      // Update the local visibility status
      // You might have to update your data model accordingly
      // For instance: category.visibility = newVisibility;
    } else {
      // Handle API error
      print('Error updating visibility: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    imageWidget =
        // Load network images using Image.network
        imageWidget = CachedNetworkImage(
      height: 180,
      width: 180,
      fit: BoxFit.cover,
      imageUrl:
          "$baseUrl/${widget.category.photo}",
      //     // "https://th.bing.com/th/id/R.d4905e2994199198de6f39df0ba25947?rik=psb0ZLiS3%2bPSQA&riu=http%3a%2f%2fthewowstyle.com%2fwp-content%2fuploads%2f2015%2f01%2fLionel-Messi-Photos.jpg&ehk=6MvbpO2DO8866ptJbXJ4I0Nod4NMXTksoZORo4G1iVk%3d&risl=&pid=ImgRaw&r=0",
      //     "https://s.yimg.com/uu/api/res/1.2/nj6w8mbFrQFBm_tQiX_F0w--~B/aD0yNjQ3O3c9MzczNztzbT0xO2FwcGlkPXl0YWNoeW9u/https://img.huffingtonpost.com/asset/5cb62e40230000c2006db3ac.jpeg",
      // // "https://i1.wp.com/www.thesun.co.uk/wp-content/uploads/2017/02/nintchdbpict000301894696.jpg?ssl=1",
      placeholder: (context, url) => const SpinKitSpinningLines(
        size: 140,
        color: Colors.black, //AppColors.green1,
      ),
      errorWidget: (context, url, error) => Image.asset(
        "assets/images/logo.png", // Assuming category.photo is a relative asset path
        height: 180,
        width: 180,
        fit: BoxFit.cover,
      ),
    );
    print(widget.category.photo);
    // CachedNetworkImage(
    //   height: 150,
    //   width: 150,
    //   imageUrl: "https://timeengcom.com/shamseen/${widget.category.photo}",
    //   progressIndicatorBuilder: (context, url, downloadProgress) =>
    //       CircularProgressIndicator(value: downloadProgress.progress),
    //   errorWidget: (context, url, error) => Icon(Icons.error),
    // );
    // }

    return Padding(
      padding: const EdgeInsetsDirectional.only(
          start: 40, end: 40, bottom: 10, top: 10),
      child: Card(
        // decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(24), color: hBackgroundColor),
        // Your existing category UI elements here
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display the category photo here
                // CachedNetworkImage(
                //   height: 150,
                //   width: 150,
                //   imageUrl:
                //       "https://th.bing.com/th/id/OIP.8S7khZ-BbVNwYTQlIOCKJAHaLI?pid=ImgDet&rs=1",
                //   // "https://timeengcom.com/shamseen/public/images/image_picker2991849253887294291.jpg",
                //   // "https://timeengcom.com/shamseen/${widget.category.photo}",
                //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                //       CircularProgressIndicator(
                //           value: downloadProgress.progress),
                //   errorWidget: (context, url, error) => Icon(Icons.error),
                // ),
                imageWidget,
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(widget.category.nameAr,
                            style: Styles.textStyle16.copyWith(
                                color: widget.category.visibility
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Transform.rotate(
                      angle: 3.14 / 2,
                      child: CupertinoSwitch(
                        value: widget.category.visibility,
                        onChanged: (value) async {
                          try {
                            // Call the updateVisibility method in a try-catch block
                            await updateVisibility(value);
                            setState(() {
                              widget.category.visibility = value;
                            });
                          } catch (e) {
                            // Handle exceptions
                            print('Exception while updating visibility: $e');
                            // You can show an error message to the user here
                          }
                        },
                      ),
                    ),
                  ],
                ),

                // Display additional category information here
                const SizedBox(height: 10),
                Column(
                  children: [
                    Text(widget.category.nameEn,
                        style:
                            Styles.textStyle16.copyWith(color: Colors.black54)),
                    const Divider(endIndent: 50, indent: 50),
                    Text("${S.of(context).price}: ${widget.category.price}",
                        style:
                            Styles.textStyle16.copyWith(color: Colors.black54)),
                    Divider(endIndent: 50, indent: 50),
                    Text(
                        (widget.category.source != null &&
                                widget.category.source.isNotEmpty)
                            ? "${S.of(context).source}: ${widget.category.source}"
                            : S.of(context).unknownSource,
                        style:
                            Styles.textStyle16.copyWith(color: Colors.black54)),
                    // Divider(endIndent: 50, indent: 50),
                    Text('${S.of(context).type}: ${widget.category.type}',
                        style:
                            Styles.textStyle16.copyWith(color: Colors.black54)),
                    // Divider(endIndent: 50, indent: 50),
                    Text(
                        '${S.of(context).schoolType}: ${widget.category.schoolType}',
                        style:
                            Styles.textStyle16.copyWith(color: Colors.black54)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              showEditCategoryDialog(context);
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 40,
                            )),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          onPressed: () async {
                            // Show a confirmation dialog before deleting
                            bool confirm = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  title: Text(
                                    S.of(context).confirmDelete,
                                    style: Styles.titleDialog,
                                  ),
                                  content:
                                      Text(S.of(context).confirmDeleteCategory),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            false); // Return false to indicate cancel
                                      },
                                      child: Text(S.of(context).cancel,
                                          style: Styles.styleCanselButton),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            true); // Return true to indicate confirmation
                                      },
                                      child: Text(S.of(context).delete,
                                          style: Styles.styledeleteButton),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              await deleteCategory(widget.category.id);
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 40,
                            color: kBlueColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
