import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/providers/route_data_provider.dart';

class SubsectionGridWidget extends StatelessWidget {
  final ValueChanged<String> onSelected;

  const SubsectionGridWidget({Key? key, required this.onSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final selectedSection = context.watch<RouteDataProvider>().selectedSection;
    final selectedSubsection =
        context.watch<RouteDataProvider>().selectedSubsection;

    final subsections = selectedSection?.subsections ?? [];

    return GridView.extent(
      maxCrossAxisExtent: 150,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      padding: const EdgeInsets.all(16),
      children:
          subsections.map((subsection) {
            final isSelected = subsection == selectedSubsection;

            return GestureDetector(
              onTap: () => onSelected(subsection),
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
                    subsection,
                    style: textTheme.titleMedium!.copyWith(
                      color:
                          isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
