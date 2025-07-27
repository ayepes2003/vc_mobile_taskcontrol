import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/providers/router_card_provider.dart';

class KPICountsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RouteCardProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final int totalLoaded = provider.routes.length;
    final int totalRead = provider.recentReads.length;
    final int totalPending = totalLoaded - totalRead;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _kpiBox(
          icon: Icons.upload_sharp,
          label: 'Cargadas',
          value: totalLoaded.toString(),
          color: colorScheme.primary,
          bgColor: colorScheme.primary.withOpacity(0.13),
          textTheme: textTheme,
        ),
        _kpiBox(
          icon: Icons.pending_actions_outlined,
          label: 'Leidas',
          value: totalRead.toString(),
          color: colorScheme.secondary,
          bgColor: colorScheme.secondary.withOpacity(0.13),
          textTheme: textTheme,
        ),
        _kpiBox(
          icon: Icons.pending_outlined,
          label: 'Pendientes',
          value: totalPending.toString(),
          color: colorScheme.error,
          bgColor: colorScheme.error.withOpacity(0.13),
          textTheme: textTheme,
        ),
      ],
    );
  }
}

Widget _kpiBox({
  required IconData icon,
  required String label,
  required String value,
  required Color color,
  required Color bgColor,
  required TextTheme textTheme,
}) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
