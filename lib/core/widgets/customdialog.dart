import 'dart:ui';
import 'package:flutter/material.dart';

import '../../config/routs/approuting.dart' show AppRouting;
import '../constants/constant.dart';

class Customdialog {
  static void showMessage(
    BuildContext context,
    bool status,
    String title,
    String message,
    String buttonText,
    bool toobuttom,
    final VoidCallback onPressed,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5), 
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Material(
                    
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        
                        Icon(
                          status
                              ? Icons.check_circle_outline
                              : Icons.info_outline,
                          color: status ? Colors.greenAccent : Colors.redAccent,
                          size: 50,
                        ),
                        const SizedBox(height: 20),
                        
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Lalezar',
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 15),
                        
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontFamily: 'YekanBakh',
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              
                              Expanded(
                                
                                child: ElevatedButton(
                                  onPressed: onPressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: status
                                        ? Constants.primaryColor
                                        : Colors.redAccent.withOpacity(0.8),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    buttonText,
                                    maxLines:
                                        1, 
                                    style: const TextStyle(
                                      fontFamily: 'YekanBakh',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),

                              
                              if (toobuttom) ...[
                                const SizedBox(width: 10), 
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      AppRouting.back(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.redAccent.withOpacity(0.8),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      "خیر",
                                      style: TextStyle(
                                        fontFamily: 'YekanBakh',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
