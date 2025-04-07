import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Utils/Provider/Profileprovider.dart';
import 'package:tailor_app/Utils/models/Profilemodel.dart';
import 'package:tailor_app/Widgets/Appbar/Customappbar.dart';
import 'package:tailor_app/Widgets/Button/CustomButton.dart';
import 'package:tailor_app/Widgets/Inpufield/Inputfield.dart';
import 'package:tailor_app/Widgets/Progressbar/progressbar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController shopNameController;
  late TextEditingController shopAddressController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    nameController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    shopNameController = TextEditingController();
    shopAddressController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar("Tailor Profile"),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF74ebd5), Color(0xFFACB6E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: profileState.when(
            loading: () => const Center(child: Circleloading()),
            error:
                (e, _) => Center(
                  child: Text(
                    "Error: $e",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ),
            data: (profile) {
              // Only update the controllers if the profile data is available
              if (profile != null) {
                nameController.text = profile.name;
                emailController.text = profile.email;
                mobileController.text = profile.mobile;
                shopNameController.text = profile.shopName;
                shopAddressController.text = profile.shopAddress;
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                      top: 16,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.3),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CircleAvatar(
                                        radius: 40,
                                        backgroundImage: AssetImage(
                                          "assets/user.webp",
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Your Profile",
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.indigo.shade800,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ProfileFields(
                                        nameController,
                                        "Name",
                                        Icons.person,
                                      ),
                                      ProfileFields(
                                        emailController,
                                        "Email",
                                        Icons.email,
                                        readOnly: true,
                                      ),
                                      ProfileFields(
                                        mobileController,
                                        "Mobile",
                                        Icons.phone,
                                      ),
                                      ProfileFields(
                                        shopNameController,
                                        "Shop Name",
                                        Icons.store,
                                      ),
                                      ProfileFields(
                                        shopAddressController,
                                        "Shop Address",
                                        Icons.location_city,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 20),
                                      ActionButton(
                                        label: 'Save',
                                        isLoading:
                                            ref
                                                .watch(profileProvider.notifier)
                                                .isSaving, // Set the loading flag
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final profile = ProfileModel(
                                              name: nameController.text.trim(),
                                              email:
                                                  emailController.text.trim(),
                                              mobile:
                                                  mobileController.text.trim(),
                                              shopName:
                                                  shopNameController.text
                                                      .trim(),
                                              shopAddress:
                                                  shopAddressController.text
                                                      .trim(),
                                            );
                                            ref
                                                .read(profileProvider.notifier)
                                                .saveProfile(profile);
                                          }
                                        },
                                      ),
                                      Gap(Get.height * 0.04),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
