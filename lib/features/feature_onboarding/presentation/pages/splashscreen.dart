import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استفاده از Container برای ایجاد پس‌زمینه حرفه‌ای‌تر
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // ایجاد یک گرادینت دایره‌ای که مرکز آن کمی روشن‌تر است
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [
              Color(0xFF1A2A4D), // آبی کمی روشن‌تر در مرکز (پشت لوگو)
              Color(0xFF050B18), // آبی خیلی تیره در لبه‌ها
            ],
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 1200),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: 0.8 + (value * 0.2), // از سایز 0.8 به 1.0 می‌رسد
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // نمایش لوگوی شفاف شما
                Image.asset(
                  'assets/images/logo.png',
                  width: 220, // سایز لوگو را اینجا تنظیم کنید
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                // نمایش یک لودینگ ظریف زیر لوگو (اختیاری)
                const SizedBox(
                  width: 40,
                  height: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white10,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
