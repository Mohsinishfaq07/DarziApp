import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/Utils/Provider/MeasurementsProvider.dart';
import 'package:tailor_app/View/Pages/Data/SavedMeasures/Details.dart';
import 'package:tailor_app/Widgets/Appbar/Customappbar.dart';
import 'package:tailor_app/Widgets/DeleteDialoge/Delete.dart';
import 'package:tailor_app/Widgets/MeasurementCard/Mcard.dart';
import 'package:tailor_app/Widgets/Progressbar/progressbar.dart';
import 'package:tailor_app/Widgets/Searchbar/Searchbar.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final measurementList = ref.watch(measurementProvider);

    return Scaffold(
      appBar: CustomAppbar("Saved Measurements"),
      body: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
            onClear: () {
              _searchController.clear();
              setState(() {
                searchQuery = '';
              });
            },
            showClear: searchQuery.isNotEmpty,
          ),
          Expanded(
            child: measurementList.when(
              data: (measurements) {
                final filteredMeasurements =
                    (searchQuery.isEmpty
                            ? measurements
                            : measurements
                                .where(
                                  (m) =>
                                      m.name.toLowerCase().contains(
                                        searchQuery,
                                      ) ||
                                      m.number.toLowerCase().contains(
                                        searchQuery,
                                      ),
                                )
                                .toList())
                        .reversed
                        .toList();

                if (measurements.isEmpty) {
                  return const EmptyStateText("No saved data");
                }

                if (filteredMeasurements.isEmpty) {
                  return const EmptyStateText("No results found");
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredMeasurements.length,
                  itemBuilder: (context, index) {
                    final measurement = filteredMeasurements[index];
                    return MeasurementCard(
                      measurement: measurement,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DetailScreen(measurement: measurement),
                          ),
                        );
                      },
                      onDelete: () {
                        showdelete(context, ref, measurement.number);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: Circleloading()),
              error: (Object error, StackTrace stackTrace) {
                return EmptyStateText("Error: $error");
              },
            ),
          ),
        ],
      ),
    );
  }
}
