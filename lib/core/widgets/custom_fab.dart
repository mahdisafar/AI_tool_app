import 'package:flutter/material.dart';
import '../constants/constant.dart';

Widget customFAB({
  required void Function()? onPressed,
  double size = 80.0, // ابعاد کل دکمه (پیش‌فرض را کم کردیم)
  double iconSize = 35.0,
  Color? iconColor,
  bool hasShadow = true,
  IconData icon = Icons.add,
}) {
  return SizedBox(
    height: size,
    width: size,
    child: FloatingActionButton(
      onPressed: onPressed,
      elevation: 0,
      backgroundColor: Colors.transparent,
      heroTag:
          null, // بسیار مهم: برای دکمه‌های داخل لیست نباید تگ Hero تکراری باشد
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Constants.boxColor,
              Constants.solidGlassColor
            ],
          ),
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: Constants.primaryColor.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? Constants.accentColor,
        ),
      ),
    ),
  );
}
