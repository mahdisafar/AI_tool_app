import 'package:flutter/material.dart';

void showDeleteDialog(BuildContext context,
    {required void Function()? onPressed}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('حذف آیتم', textDirection: TextDirection.rtl),
        content: const Text('آیا از حذف این آیتم مطمئن هستید؟',
            textDirection: TextDirection.rtl),
        actions: [
          // دکمه انصراف
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // بستن دیالوگ
            child: const Text('نه'),
          ),
          // دکمه تایید
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: onPressed,
            child: const Text('آره', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
