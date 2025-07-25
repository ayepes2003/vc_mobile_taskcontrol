import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/models/supervisor.dart';
import 'package:vc_taskcontrol/src/providers/app/supervisors_provider.dart';
import 'package:vc_taskcontrol/src/providers/route_data_provider.dart';

class SupervisorGridWidget extends StatelessWidget {
  final ValueChanged<Supervisor> onSelected;

  const SupervisorGridWidget({Key? key, required this.onSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final supervisors = context.watch<MockDataProvider>().supervisors;
    final supervisors = context.watch<SupervisorsProvider>().supervisors;

    final selectedSupervisorId =
        context.watch<RouteDataProvider>().selectedSupervisorId;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GridView.extent(
      maxCrossAxisExtent: 180,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      padding: const EdgeInsets.all(16),
      children:
          supervisors.map((supervisor) {
            final isSelected = supervisor.id == selectedSupervisorId;

            return GestureDetector(
              onTap: () => onSelected(supervisor),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        supervisor.name,
                        style: textTheme.titleLarge!.copyWith(
                          color:
                              isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        supervisor.turno,
                        style: textTheme.bodyMedium!.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        supervisor.documentNum,
                        style: textTheme.bodySmall!.copyWith(
                          color: colorScheme.secondary.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
