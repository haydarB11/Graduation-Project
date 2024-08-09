import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shamseenfactory/Features/driver/data/models/driver_model.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class AddDriverDialog extends StatefulWidget {
  final Function(Driver) onDriverAdded;

  AddDriverDialog({required this.onDriverAdded});

  @override
  State<AddDriverDialog> createState() => _AddDriverDialogState();
}

class _AddDriverDialogState extends State<AddDriverDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController nameArController = TextEditingController();
    final TextEditingController nameEnController = TextEditingController();
    final TextEditingController userController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text(
        S.of(context).addNewDriver,
        style: Styles.titleDialog,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: isLoading
              ? const Center(
                  child: SpinKitSpinningLines(
                    size: 35,
                    color: hBackgroundColor,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: nameArController,
                      decoration: InputDecoration(
                        labelText: S.of(context).nameArabic,
                        labelStyle: Styles.textStyle14
                            .copyWith(fontWeight: FontWeight.bold),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: hBackgroundColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "inset value";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: nameEnController,
                      decoration: InputDecoration(
                        labelText: S.of(context).nameEnglish,
                        labelStyle: Styles.textStyle14
                            .copyWith(fontWeight: FontWeight.bold),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: hBackgroundColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "inset value";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: userController,
                      decoration: InputDecoration(
                        labelText: S.of(context).username,
                        labelStyle: Styles.textStyle14
                            .copyWith(fontWeight: FontWeight.bold),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: hBackgroundColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "inset value";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: S.of(context).Password,
                        labelStyle: Styles.textStyle14
                            .copyWith(fontWeight: FontWeight.bold),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: hBackgroundColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "inset value";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: S.of(context).Phone,
                        labelStyle: Styles.textStyle14
                            .copyWith(fontWeight: FontWeight.bold),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: hBackgroundColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "inset value";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
        ),
      ),
      actions: [
        if (!isLoading)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              S.of(context).cancel,
              style: Styles.textStyle16.copyWith(
                  fontWeight: FontWeight.bold, color: kBlueLightColor),
            ),
          ),
        if (!isLoading)
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final newDriver = Driver(
                  sellPoints: [],
                  nameAr: nameArController.text,
                  nameEn: nameEnController.text,
                  user: userController.text,
                  password: passwordController.text,
                  phone: phoneController.text,
                );
                setState(() {
                  isLoading = true;
                });
                await widget.onDriverAdded(newDriver);

                // Navigator.of(context).pop();
              }
            },
            child: Text(
              S.of(context).add,
              style: Styles.textStyle16.copyWith(
                  fontWeight: FontWeight.bold, color: Styles.addIconColor),
            ),
          ),
      ],
    );
  }
}
