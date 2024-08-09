// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shamseenfactory/Features/driver/data/models/driver_model.dart';
// import 'package:shamseenfactory/core/utils/styles.dart';
// import 'package:shamseenfactory/generated/l10n.dart';

// class AddDriverDialog extends StatefulWidget {
//   final Function(Driver) onDriverAdded;

//   const AddDriverDialog({required this.onDriverAdded});

//   @override
//   _AddDriverDialogState createState() => _AddDriverDialogState();
// }

// class _AddDriverDialogState extends State<AddDriverDialog> {
//   late TextEditingController _nameArController;
//   late TextEditingController _nameEnController;
//   late TextEditingController _userController;
//   late TextEditingController _passwordController;
//   late TextEditingController _phoneController;

//   @override
//   void initState() {
//     super.initState();
//     _nameArController = TextEditingController();
//     _nameEnController = TextEditingController();
//     _userController = TextEditingController();
//     _passwordController = TextEditingController();
//     _phoneController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _nameArController.dispose();
//     _nameEnController.dispose();
//     _userController.dispose();
//     _passwordController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   void _addDriver() {
//     final nameAr = _nameArController.text.trim();
//     final nameEn = _nameEnController.text.trim();
//     final user = _userController.text.trim();
//     final password = _passwordController.text.trim();
//     final phone = _phoneController.text.trim();

//     if (nameAr.isNotEmpty &&
//         nameEn.isNotEmpty &&
//         user.isNotEmpty &&
//         password.isNotEmpty &&
//         phone.isNotEmpty) {
//       final newDriver = Driver(
//         nameAr: nameAr,
//         nameEn: nameEn,
//         user: user,
//         password: password,
//         phone: phone,
//         sellPoints: [], // Initialize an empty list of sell points
//       );

//       widget.onDriverAdded(newDriver); // Notify the callback
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           TextField(
//             controller: _nameArController,
//             decoration: InputDecoration(labelText: S.of(context).nameArabic),
//           ),
//           TextField(
//               controller: _nameEnController,
//               decoration:
//                   InputDecoration(labelText: S.of(context).nameEnglish)),
//           TextField(
//             controller: _userController,
//             decoration: InputDecoration(labelText: S.of(context).username),
//           ),
//           TextField(
//             controller: _passwordController,
//             decoration: InputDecoration(labelText: S.of(context).Password),
//           ),
//           TextFormField(
//             controller: _phoneController,
//             decoration: InputDecoration(labelText: S.of(context).Phone),
//             keyboardType: TextInputType.number,
//             inputFormatters: [
//               FilteringTextInputFormatter.digitsOnly,
//             ],
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: _addDriver,
//                 child: Text(S.of(context).add),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Styles.addIconColor,
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Close the dialog
//                 },
//                 child: Text(S.of(context).cancel),
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
