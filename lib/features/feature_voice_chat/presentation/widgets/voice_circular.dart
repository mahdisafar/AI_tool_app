import 'package:flutter/material.dart';


enum ChatStatus {
  pleaseTalk, 
  listening, 
  thinking, 
  responding, 
  error, 
  idle 
}

class VoiceStatusCircle extends StatelessWidget {
  final ChatStatus status;
  final bool isLoading;
  final double size;

  const VoiceStatusCircle({
    super.key,
    this.status = ChatStatus.idle,
    this.isLoading = false,
    this.size = 220, 
  });

  
  String _getStatusText() {
    switch (status) {
      case ChatStatus.pleaseTalk:
        return 'لطفاً صحبت کنید';
      case ChatStatus.listening:
        return 'در حال گوش دادن...';
      case ChatStatus.thinking:
        return 'در حال فکر کردن...';
      case ChatStatus.responding:
        return 'در حال پاسخگویی...';
      case ChatStatus.error: 
        return 'بروز خطا!\nمجدداً تلاش کنید';
      case ChatStatus.idle:
        return 'آماده به کار';
    }
  }

  
  Color _getCircleColor(BuildContext context) {
    switch (status) {
      case ChatStatus.listening:
        return Colors.blue;
      case ChatStatus.thinking:
        return Colors.purple;
      case ChatStatus.responding:
        return Colors.green;
      case ChatStatus.error: 
        return Colors.red;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _getCircleColor(context);

    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 400), 
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: activeColor.withAlpha(15),
        border: Border.all(
          color: activeColor.withAlpha(100),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: activeColor.withAlpha(20),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(activeColor),
                  strokeWidth: 3,
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _getStatusText(),
                    key: ValueKey(
                        _getStatusText()), 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: activeColor.withAlpha(230),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
