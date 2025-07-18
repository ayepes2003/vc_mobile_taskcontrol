import 'package:flutter/material.dart';

class LastEntryWidget extends StatelessWidget {
  final String? supervisor;
  final String? operator;
  final String? section;
  final String? subsection;
  final int? quantity;

  const LastEntryWidget({
    Key? key,
    this.supervisor,
    this.operator,
    this.section,
    this.subsection,
    this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(
          0.12,
        ), // Fondo suave corporativo
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, size: 28, color: colorScheme.secondary),
              const SizedBox(width: 10),
              Text(
                'Registro anterior',
                style: textTheme.titleLarge!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Supervisor: ${supervisor ?? "-"}', style: textTheme.bodyMedium),
          Text('Operario: ${operator ?? "-"}', style: textTheme.bodyMedium),
          Text('Sección: ${section ?? "-"}', style: textTheme.bodyMedium),
          Text('Subsección: ${subsection ?? "-"}', style: textTheme.bodyMedium),
          Text('Cantidad: ${quantity ?? "-"}', style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
