import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.data,
    this.style = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: Constants.kCairoFont,
    ),
    this.color = const Color.fromARGB(255, 255, 255, 255),
  });
  final String data;
  final TextStyle style;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: color,
        shadowColor: const Color.fromARGB(89, 197, 191, 191),
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            data,
            style: style,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
