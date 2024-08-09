import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shamseenfactory/Features/Sales_epresentative/data/models/promoter.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';
import 'package:shamseenfactory/generated/l10n.dart';

class AddPromoterDailog extends StatefulWidget {
  final Function(Promoter) onPromoterAdded;

  AddPromoterDailog({required this.onPromoterAdded});

  @override
  State<AddPromoterDailog> createState() => _AddPromoterDailogState();
}

class _AddPromoterDailogState extends State<AddPromoterDailog> {
  final TextEditingController nameArController = TextEditingController();

  final TextEditingController nameEnController = TextEditingController();

  final TextEditingController userController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text(S.of(context).addNewPromoter),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: (isLoading)
              ? const SpinKitSpinningLines(
                  size: 35,
                  color: hBackgroundColor,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).pleaseEnterValidName;
                        }
                        return null;
                      },
                      controller: nameArController,
                      decoration: InputDecoration(
                        labelText: S.of(context).nameArabic,
                        labelStyle: Styles.textStyle14
                            .copyWith(fontWeight: FontWeight.bold),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: hBackgroundColor),
                        ),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).pleaseEnterValidName;
                        }
                        return null;
                      },
                      controller: nameEnController,
                      decoration: InputDecoration(
                        labelText: S.of(context).nameEnglish,
                        labelStyle: Styles.textStyle14
                            .copyWith(fontWeight: FontWeight.bold),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: hBackgroundColor),
                        ),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).pleaseEnterValidName;
                        }
                        return null;
                      },
                      controller: userController,
                      decoration: InputDecoration(
                        labelText: S.of(context).username,
                        labelStyle: Styles.textStyle14
                            .copyWith(fontWeight: FontWeight.bold),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: hBackgroundColor),
                        ),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).pleaseEnterValidName;
                        }
                        return null;
                      },
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: S.of(context).Password,
                        labelStyle: Styles.textStyle14
                            .copyWith(fontWeight: FontWeight.bold),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: hBackgroundColor),
                        ),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).pleaseEnterValidName;
                        }
                        return null;
                      },
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: S.of(context).Phone,
                        labelStyle: Styles.textStyle14
                            .copyWith(fontWeight: FontWeight.bold),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: hBackgroundColor),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            S.of(context).cancel,
            style: Styles.textStyle16
                .copyWith(fontWeight: FontWeight.bold, color: kBlueLightColor),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final newPromoter = Promoter(
                sellPoints: [],
                nameAr: nameArController.text,
                nameEn: nameEnController.text,
                user: userController.text,
                password: passwordController.text,
                phone: phoneController.text,
              );
              try {
                setState(() {
                  isLoading = true;
                });
                await widget.onPromoterAdded(newPromoter);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              } catch (e) {}
            }
          },
          child: Text(
            S.of(context).add,
            style: Styles.textStyle16
                .copyWith(fontWeight: FontWeight.bold, color: kActiveIconColor),
          ),
        ),
      ],
    );
  }
}
