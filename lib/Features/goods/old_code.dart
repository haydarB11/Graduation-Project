// ignore: camel_case_types
// class categories extends StatefulWidget {
//   final String name_ar;
//   final String name_en;
//   final String source;
//   final String type;
//   final String school_type;
//   final bool visibility;
//   final String photoPath;
//   final void Function(bool)? onVisibilityChanged; // Add this line

//   const categories({
//     Key? key,
//     required this.name_ar,
//     required this.name_en,
//     required this.source,
//     required this.type,
//     required this.school_type,
//     required this.photoPath,
//     required this.visibility,
//     required this.onVisibilityChanged,
//   }) : super(key: key);

//   @override
//   _categories createState() => _categories();
// }

// // ignore: camel_case_types
// class _categories extends State<categories> {
//   late bool _isOn;
//   void _handleVisibilityChange(bool newValue) {
//     setState(() {
//       _isOn = newValue;
//       widget.onVisibilityChanged?.call(newValue);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _isOn = widget.visibility;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           color: _isOn ? hBackgroundColor : kShadowColor,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 25.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Display the category photo here
//                   Image.asset(
//                   widget.photoPath,
//                   height: 40,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 25.0),
//                         child: Text(
//                           widget.name_ar,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             color: _isOn ? Colors.white : Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Transform.rotate(
//                       angle: 3.14 / 2,
//                       child: CupertinoSwitch(
//                         value: _isOn,
//                         onChanged: (value) {
//                           setState(() {
//                             _isOn = value;
//                             widget.onVisibilityChanged?.call(value);
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Display additional category information here
//                 const SizedBox(height: 10),
//                 Text(widget.name_en,
//                     style: Styles.textStyle12.copyWith(color: Colors.black54)),
//                 Text(widget.source,
//                     style: Styles.textStyle12.copyWith(color: Colors.black54)),
//                 Text('Type: ${widget.type}',
//                     style: Styles.textStyle12.copyWith(color: Colors.black54)),
//                 Text('School Type: ${widget.school_type}',
//                     style: Styles.textStyle12.copyWith(color: Colors.black54)),
//                 Text('source: ${widget.source}',
//                     style: Styles.textStyle12.copyWith(color: Colors.black54)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// OR if category.photo is a full file path:
      // imageWidget = Image.file(
      //   File(category.photo),
      //   height: 40,
      // );