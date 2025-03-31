import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Utils/Provider/DressProvider.dart';
import 'package:tailor_app/Utils/Snackbar/Snackbar.dart';
import 'package:tailor_app/Utils/models/DressModel.dart';
import 'package:tailor_app/View/Data/SavedMeasures/Details.dart';

import 'package:tailor_app/Widgets/Genderwidget/GenderWidget.dart';

class DressDetail extends ConsumerStatefulWidget {
  final DressModel dress;

  const DressDetail({super.key, required this.dress});

  @override
  ConsumerState<DressDetail> createState() => _DressDetailState();
}

class _DressDetailState extends ConsumerState<DressDetail> {
  late TextEditingController _nameController;
  late TextEditingController _numberController;
  late TextEditingController _colorController;
  late DateTime _bookDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.dress.name);
    _numberController = TextEditingController(text: widget.dress.number);
    _colorController = TextEditingController(text: widget.dress.dressColor);
    _bookDate = widget.dress.bookDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _bookDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _bookDate) {
      setState(() => _bookDate = picked);
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty || _numberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Number are required')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final updatedDress = widget.dress.copyWith(
      name: _nameController.text,
      number: _numberController.text,
      dressColor: _colorController.text,
      bookDate: _bookDate,
    );

    await ref.read(dressProvider.notifier).addOrUpdateDress(updatedDress);
    setState(() => _isSaving = false);
    
    showSnackBar("Dress Details", "Changes Saved");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dress Details",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildInputField("Name", _nameController),
                    const Gap(16),
                    _buildInputField("Number", _numberController),
                    const Gap(16),
                    _buildInputField("Color", _colorController),
                    const Gap(16),
                    _buildDateField(context),
                    const Gap(24),
                    
                    CustomButton2(
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => 
                                DetailScreen(measurement: widget.dress.measurements),
                          ),
                        );
                      },
                      "VIEW MEASUREMENTS",
                    ),
                    Gap(30),
                      _buildSaveButton(),
                  ],
                ),
              ),
            ),
            // const Gap(16),
          
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(
            text: _bookDate.toLocal().toString().split(' ')[0],
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


  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
        ),
        onPressed: _isSaving ? null : _saveChanges,
        child: _isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                "SAVE CHANGES",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}