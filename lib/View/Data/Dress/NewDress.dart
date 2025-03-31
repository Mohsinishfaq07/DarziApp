import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Utils/Provider/DressProvider.dart';
import 'package:tailor_app/Utils/Provider/MeasurementsProvider.dart';
import 'package:tailor_app/Utils/Snackbar/Snackbar.dart';
import 'package:tailor_app/Utils/models/DressModel.dart';
import 'package:tailor_app/Utils/models/measurmentmodel.dart';
import 'package:tailor_app/View/Home/HomeScreen.dart';
import 'package:tailor_app/Widgets/Bottomsheet/Bottomsheet.dart';

import 'package:tailor_app/Widgets/Genderwidget/GenderWidget.dart';
import 'package:tailor_app/Widgets/Inpufield/Inputfield.dart';


class NewDress extends ConsumerStatefulWidget {
  const NewDress({super.key});

  @override
  ConsumerState<NewDress> createState() => _NewDressState();
}

class _NewDressState extends ConsumerState<NewDress> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _colorController = TextEditingController();
  DateTime? _selectedDate;
  Measurement? _selectedMeasurement;

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _saveDress() async {
    if (_nameController.text.isEmpty || _numberController.text.isEmpty) {
      showSnackBar("Error", "Name & Number required");
      return;
    }

    if (_selectedMeasurement == null) {
      showSnackBar("Error", "Please select measurements");
      return;
    }

    final dress = DressModel(
      isCompleted: false,
      name: _nameController.text,
      number: _numberController.text,
      dressColor: _colorController.text,
      dressPic: '',
      bookDate: _selectedDate ?? DateTime.now(),
      measurements: _selectedMeasurement!,
    );

    try {
      await ref.read(dressProvider.notifier).addOrUpdateDress(dress);
      showSnackBar("Success", "Dress details saved!");
      if (mounted) Get.back();
    } catch (e) {
      showSnackBar("Error", "Failed to save dress: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final measurementStream = ref.watch(measurementProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "New Dress",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              controller: _nameController,
              label: "Client Name",
              hintText: "Enter client name",
            ),
            const Gap(16),
            CustomInputField(
              controller: _numberController,
              label: "Client Number",
              hintText: "Enter client number",
              keyboardType: TextInputType.phone,
            ),
            const Gap(16),
            CustomInputField(
              controller: _colorController,
              label: "Dress Color",
              hintText: "Enter dress color",
            ),
            const Gap(16),
            _buildDateSelector(context),
            const Gap(20),
            _buildMeasurementSection(measurementStream),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.blueAccent),
            const Gap(12),
            Text(
              _selectedDate == null
                  ? "Select Booking Date"
                  : "Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementSection(AsyncValue<List<Measurement>> measurementStream) {
    return Column(
      children: [
        Text(
          _selectedMeasurement == null
              ? "No Measurement Linked"
              : "Linked: ${_selectedMeasurement!.name} - ${_selectedMeasurement!.number}",
          style: const TextStyle(fontSize: 16),
        ),
        const Gap(20),
        Row(
          children: [
            Expanded(
              child: CustomButton2(
          () {
                   measurementStream.whenData((measurements) {
                    MeasurementSelectorSheet.show(
                      context: context,
                      measurements: measurements,
                      onMeasurementSelected: (measurement) {
                        setState(() {
                          _selectedMeasurement = measurement;
                          _nameController.text = measurement.name;
                          _numberController.text = measurement.number;
                        });
                      },
                      onAddNew: () => Get.to( Homescreen()),
                    );
                  });
          },"Add Measures",
               
              ),
            ),
            const Gap(16),
   CustomButton2(() {
    _saveDress();
    Navigator.pop(context);
   }, "Save Dress")
          ],
        ),
      ],
    );
  }
}