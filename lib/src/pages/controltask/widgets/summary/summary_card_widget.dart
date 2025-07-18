import 'package:flutter/material.dart';

class SummaryCardWidget extends StatelessWidget {
  final String? project;
  final int? estimatedQuantity;
  final int? realQuantity;
  final Widget? lastEntry;
  final String supervisor;

  final String operatorName;
  final String section;
  final String subsection;

  const SummaryCardWidget({
    super.key,
    this.project,
    this.estimatedQuantity,
    this.realQuantity,
    this.lastEntry,
    required this.supervisor,
    required this.operatorName,
    required this.section,
    required this.subsection,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final int difference = (estimatedQuantity ?? 0) - (realQuantity ?? 0);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Proyecto arriba
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(
                0.13,
              ), // Fondo suave corporativo
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.assignment, size: 32, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    project ?? 'Sin proyecto',
                    style: textTheme.titleLarge!.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),

          // Cantidades en el centro
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("CANTIDAD", style: textTheme.titleMedium),
                  _buildSummaryRow(
                    context,
                    "Estimada",
                    estimatedQuantity?.toString() ?? "-",
                  ),
                  _buildSummaryRow(
                    context,
                    "Real",
                    realQuantity?.toString() ?? "-",
                  ),
                  _buildSummaryRow(
                    context,
                    "Faltante",
                    difference.toString(),
                    highlight: difference > 0,
                  ),
                ],
              ),
            ),
          ),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _buildSummaryRow(context, "Supervisor", supervisor),
                  _buildSummaryRow(context, "Operario", operatorName),
                  _buildSummaryRow(context, "Sección", section),
                  _buildSummaryRow(context, "SubSección", subsection),
                ],
              ),
            ),
          ),
          // Último dato abajo (corregido)
          if (lastEntry != null)
            lastEntry!
          else
            Container(
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
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool highlight = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.3),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium!.copyWith(
                color:
                    highlight
                        ? Colors
                            .red // Puedes usar colorScheme.error si prefieres
                        : colorScheme.onSurface,
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
