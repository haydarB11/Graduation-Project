import 'package:flutter/material.dart';

class LoadingSnackbar {
  static void show(BuildContext context, {String message = 'Generating PDF'}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16.0),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[500], // Customize the background color
        duration: const Duration(minutes: 1), // Adjust the duration as needed
      ),
    );
  }
}
