import 'package:ai_app/core/constants/constant.dart' show Constants;
import 'package:flutter/material.dart';

Widget chatbox(BuildContext context,
    {required VoidCallback onTap, required TextEditingController controller}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // اضافه کردن ویجت Material در اینجا مشکل را حل می‌کند
      Material(
        color: Colors.transparent, // شفاف باشد تا استایل کانتینر خودت خراب نشود
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: const BoxConstraints(
            minHeight: 60,
            maxHeight: 200,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Constants.primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color: Constants.blackColor,
              fontSize: 24,
              fontFamily: "Lalezar",
            ),
            decoration: InputDecoration(
              hintText: "اینجا بنویسید...",
              border: InputBorder.none,
            ),
          ),
        ),
      ),

      const SizedBox(height: 20),

      // دکمه تایید هم بهتر است در Material باشد (یا از ElevatedButton استفاده شود که خودش متریال دارد)
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 50,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: const Text("تایید", style: TextStyle(color: Colors.white)),
        ),
      ),
    ],
  );
}
