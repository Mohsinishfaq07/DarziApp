import 'package:flutter/material.dart';
import 'package:tailor_app/Utils/models/clientmodel.dart';

class MeasurementSelectorBottomSheet extends StatelessWidget {
  final List<Measurement> measurements;
  final void Function(Measurement) onMeasurementSelected;
  final VoidCallback onNewMeasurement;

  const MeasurementSelectorBottomSheet({
    Key? key,
    required this.measurements,
    required this.onMeasurementSelected,
    required this.onNewMeasurement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjusts height to fit content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Measurement",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: measurements.length,
              itemBuilder: (context, index) {
                final measure = measurements[index];
                return ListTile(
                  title: Text("${measure.name} - ${measure.number}"),
                  subtitle: Text("Chest: ${measure.chest}, Waist: ${measure.waist}"),
                  onTap: () {
                    onMeasurementSelected(measure);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("New Measurement", style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              onNewMeasurement();
            },
          ),
        ],
      ),
    );
  }
}
