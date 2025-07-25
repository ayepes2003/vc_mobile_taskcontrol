import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/providers/route_data_provider.dart';
import 'package:vc_taskcontrol/src/providers/router_card_provider.dart';

class LastEntryWidget extends StatelessWidget {
  const LastEntryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<RouteCardProvider>();
    final routeData = context.watch<RouteDataProvider>();
    final lastRead =
        provider.recentReads.isNotEmpty ? provider.recentReads.first : null;

    if (lastRead == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: colorScheme.secondary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.history, size: 24, color: colorScheme.secondary),
            const SizedBox(width: 5),
            Text(
              'Sin datos recientes',
              style: textTheme.bodyLarge!.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    Widget buildEntryRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.secondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 1.5),
            Text(
              value,
              style: textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(top: 14),
      // color: colorScheme.secondary.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, size: 22, color: colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Tarjeta Ruta',
                  style: textTheme.titleMedium!.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // buildEntryRow('Proyecto', lastRead.card.projectName),
            // buildEntryRow('Supervisor', routeData.supervisor ?? '-'),
            // buildEntryRow('Operario', routeData.operatorName ?? '-'),
            // buildEntryRow('Sección', routeData.section ?? '-'),
            // buildEntryRow('Subsección', routeData.subsection ?? '-'),
            buildEntryRow('Producto', lastRead.card.item ?? '-'),
            buildEntryRow(
              'Descripción',
              lastRead.card.descriptionMaterial ?? '-',
            ),
            // buildEntryRow(
            //   'Cantidad digitada',
            //   lastRead.enteredQuantity.toString(),
            // ),
          ],
        ),
      ),
    );
  }
}
