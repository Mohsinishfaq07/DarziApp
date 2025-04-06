import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tailor_app/Utils/Provider/AdProviders/BannerAdProvider.dart';
import 'package:tailor_app/Utils/Provider/DressProvider.dart';
import 'package:tailor_app/Utils/Snackbar/Snackbar.dart';
import 'package:tailor_app/Utils/models/DressModel.dart';
import 'package:tailor_app/View/Pages/Data/SavedMeasures/Details.dart';
import 'package:tailor_app/Widgets/Appbar/Customappbar.dart';
import 'package:tailor_app/Widgets/Button/CustomButton.dart';
import 'package:tailor_app/Widgets/Genderwidget/GenderWidget.dart';
import 'package:tailor_app/Widgets/Inpufield/Inputfield.dart';

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
      appBar: CustomAppbar("Dress Details"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildInputField("Name", _nameController),
                    const Gap(16),
                    buildInputField("Number", _numberController),
                    const Gap(16),
                    buildInputField("Color", _colorController),
                    const Gap(16),
                    buildDateField(context, () {
                      _selectDate(context);
                    }, _bookDate.toLocal().toString().split(' ')[0]),
                    const Gap(24),
                    CustomButton2(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DetailScreen(
                                measurement: widget.dress.measurements,
                              ),
                        ),
                      );
                    }, "VIEW MEASUREMENTS"),
                    Gap(30),
                    ActionButton(
                      label: "Save Changes",
                      isLoading: _isSaving,
                      onPressed: () {
                        if (_isSaving) return;
                        _saveChanges();
                      },
                    ),
                    const Gap(30),
                    Consumer(
                      builder: (context, ref, child) {
                        final bannerAd = ref.watch(bannerAdProvider);
                        return SizedBox(
                          width: bannerAd.size.width.toDouble(),
                          height: bannerAd.size.height.toDouble(),
                          child: AdWidget(ad: bannerAd),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
