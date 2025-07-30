import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/providers/app/hour_ranges_provider.dart';
import 'package:vc_taskcontrol/src/providers/mock_data_provider.dart';
import 'package:vc_taskcontrol/src/providers/route_data_provider.dart';

class HourRangeGridWidget extends StatelessWidget {
  final ValueChanged<String> onSelected;

  const HourRangeGridWidget({Key? key, required this.onSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final hourRanges = context.watch<MockDataProvider>().hourRanges;
    final hourRangesProvider = context.watch<HourRangesProvider>();
    final hourRanges = hourRangesProvider.hourRanges;
    final currentShift = hourRangesProvider.currentShift;

    final selectedHour = context.watch<RouteDataProvider>().selectedHourRange;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (hourRanges.isEmpty) {
      return const Center(
        child: Text(
          'No hay Horarios disponibles para la sección actual.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return GridView.extent(
      maxCrossAxisExtent: 160,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      padding: const EdgeInsets.all(16),
      children:
          hourRanges.map((range) {
            final isSelected = range == selectedHour;

            return GestureDetector(
              onTap: () => onSelected(range),
              child: Card(
                color:
                    isSelected
                        ? colorScheme.primary.withOpacity(0.13)
                        : colorScheme.surface,
                elevation: isSelected ? 6 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color:
                        isSelected
                            ? colorScheme.primary
                            : colorScheme.secondary.withOpacity(0.5),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    range,
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
