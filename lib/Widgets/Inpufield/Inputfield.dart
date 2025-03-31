import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool obscureText;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ),
      ],
    );
  }
}