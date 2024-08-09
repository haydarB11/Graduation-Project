import 'package:flutter/material.dart';
import 'package:shamseenfactory/constants.dart';
import 'package:shamseenfactory/core/utils/styles.dart';

class CustomBillCard extends StatelessWidget {
  final String pngSrc;
  final String title;
  final VoidCallback press;

  const CustomBillCard({
    required this.pngSrc,
    required this.title,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        decoration: BoxDecoration(
          color: hBackgroundColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            const BoxShadow(
              offset: Offset(0, 17),
              blurRadius: 17,
              spreadRadius: -23,
              color: kShadowColor,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    pngSrc,
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  const Spacer(),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Styles.textStyle14.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
