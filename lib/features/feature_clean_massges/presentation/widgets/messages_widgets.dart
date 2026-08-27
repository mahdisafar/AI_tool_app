import 'package:ai_app/core/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/widgets/customsnackbar.dart'; 

Widget squareMessages(
  BuildContext context, {
  required String title,
  required String description,
  required void Function()? onPressed,
}) {
  return InkWell(
    onTap: () => _showTaskDetails(context, title, description),
    borderRadius: BorderRadius.circular(24),
    child: Container(
      width: 170,
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF0F7FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: Constants.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Constants.blackColor,
              fontSize: 18,
              fontFamily: "Lalezar",
            ),
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 0.5),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Constants.blackColor.withOpacity(0.6),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: description));
                  CustomSnackBar.show(context, "متن کپی شد");
                },
                icon: Icon(
                  Icons.copy_rounded,
                  color: Constants.primaryColor,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void _showTaskDetails(BuildContext context, String title, String description) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Constants.primaryColor,
                    fontSize: 22,
                    fontFamily: "Lalezar",
                  ),
                ),
                const SizedBox(height: 15),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: description));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("متن با موفقیت کپی شد"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text("کپی متن"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Constants.primaryColor,
                        side: BorderSide(color: Constants.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "متوجه شدم",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget chatboxWithStyle(
  BuildContext context, {
  required VoidCallback onTap,
  required TextEditingController controller,
  required String selectedStyle,
  required Function(String) onStyleChanged,
}) {
  final List<Map<String, String>> styles = [
    {'name': 'رسمی', 'value': 'FORMAL'},
    {'name': 'دوستانه', 'value': 'FRIENDLY'},
    {'name': 'محترمانه', 'value': 'POLITE'},
    {'name': 'عاشقانه', 'value': 'ROMANTIC'},
    {'name': 'عذرخواهی', 'value': 'APOLOGETIC'},
  ];

  return SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: styles.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final style = styles[index];
              bool isSelected = selectedStyle == style['value'];
              return ChoiceChip(
                label: Text(
                  style['name']!,
                  style: TextStyle(
                    fontFamily: "Lalezar",
                    color: isSelected ? Colors.white : Constants.primaryColor,
                  ),
                ),
                selected: isSelected,
                selectedColor: Constants.primaryColor,
                backgroundColor: Colors.white,
                onSelected: (selected) {
                  if (selected) onStyleChanged(style['value']!);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: 320,
          constraints: const BoxConstraints(
            minHeight: 100,
            maxHeight: 250,
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
          child: Material(
            color: Colors.transparent,
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: controller,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "پیام خود را اینجا بنویسید...",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "تمیز کردن پیام",
              style: TextStyle(color: Colors.white, fontFamily: "Lalezar"),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget customFAB({
  required void Function()? onPressed,
  double size = 70.0,
  double iconSize = 30.0,
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
      heroTag: null,
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
                    blurRadius: 10,
                    offset: const Offset(0, 5),
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

Widget buildError({
  required String error,
  required void Function()? onPressed,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 50),
        Text(error, textAlign: TextAlign.center),
        ElevatedButton(onPressed: onPressed, child: const Text("تلاش مجدد")),
      ],
    ),
  );
}
