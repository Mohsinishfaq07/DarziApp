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
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
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

Widget ProfileFields(
  TextEditingController controller,
  String label,
  IconData icon, {
  bool readOnly = false,
  int maxLines = 1,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label :",
          style: TextStyle(
            color: Colors.indigo.shade700,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          validator:
              (value) => value == null || value.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.indigo),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildInputField(String label, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    ),
  );
}

Widget buildDateField(
  BuildContext context,
  GestureTapCallback onTap,
  String label,
) {
  return GestureDetector(
    onTap: onTap,
    // onTap: () => _selectDate(context),
    child: AbsorbPointer(
      child: TextField(
        controller: TextEditingController(
          text: label,
          // text: _bookDate.toLocal().toString().split(' ')[0],
        ),
        decoration: const InputDecoration(
          labelText: "Booking Date",
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
      ),
    ),
  );
}
