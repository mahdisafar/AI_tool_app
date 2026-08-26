import 'package:ai_app/core/constants/constant.dart';
import 'package:ai_app/core/widgets/custom_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class TaskDetailBox extends StatefulWidget {
  final void Function(DismissDirection)? onDismissed;
  final Key keydismis;
  final String title;
  final String description;

  const TaskDetailBox({
    super.key,
    required this.onDismissed,
    required this.keydismis,
    required this.title,
    required this.description,
  });

  @override
  State<TaskDetailBox> createState() => _TaskDetailBoxState();
}

bool isdelete = false;

class _TaskDetailBoxState extends State<TaskDetailBox> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: widget.keydismis,
      onDismissed: widget.onDismissed,
      direction: DismissDirection.startToEnd,
      resizeDuration: const Duration(milliseconds: 300),
      movementDuration: const Duration(milliseconds: 200),

      // ظاهر پشت کارت هنگام کشیدن به سمت راست برای حذف
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.redAccent.shade400,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 25),
        child: const Icon(Icons.delete_sweep, color: Colors.white, size: 35),
      ),

      confirmDismiss: (direction) async {
        // اینجا می‌توانید در آینده دیالوگ تایید حذف بگذارید
        return true;
      },

      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Constants.blackColor,
                      fontSize: 20,
                      fontFamily: "Lalezar",
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _showTaskDetails(
                      context, widget.title, widget.description),
                  child: Row(
                    children: [
                      Text(
                        "جزئیات",
                        style: TextStyle(
                          color: Constants.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.chevron_right,
                          color: Constants.primaryColor, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// تابع نمایش دیالوگ جزئیات
void _showTaskDetails(BuildContext context, String title, String description) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Colors.white,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                  color: Constants.primaryColor.withOpacity(0.2), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Constants.primaryColor,
                    fontSize: 24,
                    fontFamily: "Lalezar",
                  ),
                ),
                const Divider(height: 30),
                Text(
                  description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Constants.blackColor.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("متوجه شدم",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class MicOnhold extends StatelessWidget {
  final VoidCallback? onAddPressed;
  final VoidCallback? onMicPressed;
  final GlobalKey<ExpandableFabState> fabKey;

  const MicOnhold({
    super.key,
    this.onAddPressed,
    this.onMicPressed,
    required this.fabKey,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      key: fabKey, // از کلیدی که از خارج می آید استفاده می کنیم
      distance: 100,
      type: ExpandableFabType.up,
      overlayStyle: ExpandableFabOverlayStyle(blur: 5),

      openButtonBuilder: FloatingActionButtonBuilder(
        size: 70,
        builder: (context, onPressed, progress) => customFAB(
          onPressed: onPressed,
          icon: Icons.add,
          iconSize: 35,
          size: 70,
        ),
      ),

      closeButtonBuilder: FloatingActionButtonBuilder(
        size: 70,
        builder: (context, onPressed, progress) => customFAB(
          onPressed: onPressed,
          icon: Icons.close,
          iconSize: 30,
          size: 70,
        ),
      ),

      children: [
        customFAB(
          onPressed: () {
            final state = fabKey.currentState;
            if (state != null && state.isOpen) {
              state.toggle();
            }
            onAddPressed?.call();
          },
          icon: Icons.edit_note,
          iconSize: 30,
          size: 60,
        ),
        customFAB(
          onPressed: onMicPressed,
          icon: Icons.mic,
          iconSize: 30,
          size: 60,
          hasShadow: false,
        ),
      ],
    );
  }
}
