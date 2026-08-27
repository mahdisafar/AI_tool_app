import 'dart:ui';
import 'package:flutter/material.dart';

import '../constants/constant.dart' show Constants;

class CustomSnackBar {
  static void show(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.transparent, 
      content: ClipRRect(
        borderRadius: BorderRadius.circular(15), 
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), 
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isError
                  ? Colors.redAccent.withOpacity(0.2)
                  : Colors.white.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.2), 
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: isError ? Colors.redAccent : Constants.blackColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Constants.blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Lalezar', 
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
