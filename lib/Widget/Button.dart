import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui'; // Add this import

class ButtonCustom extends StatelessWidget {
  final VoidCallback onPressed;
  final String? btnName;
  final IconData? icon;

  const ButtonCustom({
    Key? key,
    required this.onPressed,
    required this.btnName,
    this.icon, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0EBE7E), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        minimumSize: const Size(double.infinity, 50), 
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, color: Colors.white), 
            if (icon != null) const SizedBox(width: 8), 
            Text(
              btnName ?? "Button",
              style: GoogleFonts.rubik(
                textStyle: const TextStyle(color: Colors.white,fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
