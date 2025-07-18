import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/section.dart';

class SectionGridWidget extends StatelessWidget {
  final List<Section> sections;
  final Section? selectedSection;
  final ValueChanged<Section> onSelected;

  const SectionGridWidget({
    Key? key,
    required this.sections,
    required this.selectedSection,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                // CAMBIO: Colores adaptados al theme y branding
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
