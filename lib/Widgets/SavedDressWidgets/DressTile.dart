import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Utils/Provider/DressProvider.dart';
import 'package:tailor_app/Utils/Snackbar/Snackbar.dart';
import 'package:tailor_app/View/Pages/Data/Dress/DressDetail.dart';

class DressAvatar extends StatelessWidget {
  final dynamic dress;

  const DressAvatar({super.key, required this.dress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor:
              dress.isCompleted ? Colors.grey.shade300 : Colors.blue.shade100,
          child: Text(
            dress.name[0].toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: dress.isCompleted ? Colors.grey : Colors.blue,
              decoration:
                  dress.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
            ),
          ),
        ),
        if (dress.isCompleted)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

class DressTitle extends StatelessWidget {
  final dynamic dress;

  const DressTitle({super.key, required this.dress});

  @override
  Widget build(BuildContext context) {
    return Text(
      dress.name,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        decoration:
            dress.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
        color: dress.isCompleted ? Colors.grey : Colors.black,
      ),
    );
  }
}

class DressSubtitle extends StatelessWidget {
  final dynamic dress;

  const DressSubtitle({super.key, required this.dress});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Color: ${dress.dressColor}  ${dress.bookDate.toLocal().toString().split(" ")[0]}",
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: dress.isCompleted ? Colors.grey : Colors.grey.shade700,
        decoration:
            dress.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
      ),
    );
  }
}

class DressTrailing extends StatelessWidget {
  final dynamic dress;
  final int index;
  final WidgetRef ref;

  const DressTrailing({
    super.key,
    required this.dress,
    required this.index,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: dress.isCompleted,
          onChanged: (bool? newValue) {
            ref
                .read(dressProvider.notifier)
                .toggleCompletion(dress.number, newValue ?? false);
            if (newValue == true) {
              showSnackBar("Dress Status", "Dress Completed");
            } else {
              showSnackBar("Dress Status", "Dress Incomplete");
            }
          },
          activeColor: Colors.green,
        ),
        IconButton(
          icon: Icon(
            Icons.edit,
            color: dress.isCompleted ? Colors.grey : Colors.blue,
          ),
          onPressed: () {
            Get.to(DressDetail(dress: dress));
          },
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: dress.isCompleted ? Colors.grey : Colors.red,
          ),
          onPressed:
              dress.isCompleted
                  ? null
                  : () => _showDeleteConfirmation(context, ref, dress.number),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    String number,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Dress"),
            content: const Text("Are you sure you want to delete this dress?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  ref.read(dressProvider.notifier).removeDress(number);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
