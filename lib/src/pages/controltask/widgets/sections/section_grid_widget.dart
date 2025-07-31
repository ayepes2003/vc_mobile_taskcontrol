import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/models/section.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/route_data_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/sections_provider.dart';

class SectionGridWidget extends StatelessWidget {
  final ValueChanged<Section> onSelected;

  const SectionGridWidget({Key? key, required this.onSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // final sections = context.watch<MockDataProvider>().sections;
    final sections = context.watch<SectionsProvider>().sections;

    final selectedSection = context.watch<RouteDataProvider>().selectedSection;

    if (sections.isEmpty) {
      return const Center(
        child: Text(
          'No hay secciones disponibles para la sección actual.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return GridView.extent(
      maxCrossAxisExtent: 180,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      padding: const EdgeInsets.all(16),
      children:
          sections.map((section) {
            final isSelected = selectedSection?.id == section.id;

            return GestureDetector(
              onTap: () => onSelected(section),
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
                    section.sectionName,
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
