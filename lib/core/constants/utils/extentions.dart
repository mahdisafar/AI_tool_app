import 'package:flutter/material.dart';

extension Short on String {
  String get shortdes {
    final words = this.trim().split(RegExp(r'[\s\u200c]+'));
    if (words.length > 20) {
      return "${words.take(20).join(' ')}...";
    } else {
      return this.trim();
    }
  }
}

extension Validator on String {
  bool get isclean {
    return !RegExp(r'\s+').hasMatch(this);
  }

  String get clean {
    
    
    
    return this.trim().replaceAll(RegExp(r'\s+'), '').toLowerCase();
  }

  String get finalword {
    return this.trim().toLowerCase();
  }
}

extension MediaQueries on BuildContext {
  
  double get width => MediaQuery.of(this).size.width;

  
  double get height => MediaQuery.of(this).size.height;

  
  double widthPct(double percent) => MediaQuery.of(this).size.width * percent;

  
  double heightPct(double percent) => MediaQuery.of(this).size.height * percent;

  
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
}


extension BoxConstraintsExtensions on BoxConstraints {
  
  double get widthRatio =>
      maxWidth; 
  
  double get heightRatio =>
      maxHeight; 

  
  double getWidthWithPercentage(double percentage) {
    return maxWidth * percentage;
  }

  double getHeightWithPercentage(double percentage) {
    return maxHeight * percentage;
  }
}


extension FarsiNumberExtension on String {
  String get farsiNumber1 {
    String text = this;

    
    
    if (text.endsWith('.0')) {
      text = text.substring(0, text.length - 2);
    }

    
    
    text = text.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    for (int i = 0; i < english.length; i++) {
      text = text.replaceAll(english[i], farsi[i]);
    }

    return text;
  }
}

extension StringLimit on String {
  
  Widget toText({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    int maxLines = 1,
    TextAlign textAlign = TextAlign.right,
    TextOverflow? overflow,
  }) {
    return Text(
      this,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis, 
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: "IranYekan", 
      ),
    );
  }
}
