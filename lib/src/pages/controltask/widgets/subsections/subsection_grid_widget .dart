import 'package:flutter/material.dart';

class SubsectionGridWidget extends StatelessWidget {
  final List<String> subsections;
  final String? selectedSubsection;
  final ValueChanged<String> onSelected;

  const SubsectionGridWidget({
    Key? key,
    required this.subsections,
    required this.selectedSubsection,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
