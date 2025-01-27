import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class HelperField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon; // Accepts IconData instead of Icon widget
  final IconButton? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;

  HelperField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200], // Optional background color
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator ?? // Use the provided validator if available
                (value) {
              if (value == null || value.isEmpty) {
                return "Please fill the field.";
              }
              return null;
            },
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: suffixIcon, // Optional suffix icon
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none, // No border by default
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey), // Border when not focused
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.primaryColor), // Border when focused
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          filled: true,
          fillColor: Colors.white, // Background color for the field
        ),
      ),
    );
  }
}
