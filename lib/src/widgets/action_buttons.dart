import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onPaymentPressed;
  final VoidCallback onLastPressed;
  final VoidCallback onPrintPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onImportPressed;

  const ActionButtons({
    super.key,
    required this.onCancelPressed,
    required this.onPaymentPressed,
    required this.onLastPressed,
    required this.onPrintPressed,
    required this.onDeletePressed,
    required this.onImportPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.cancel),
          label: const Text('Cancelar'),
          onPressed: onCancelPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.payment),
          label: const Text('Abonos'),
          onPressed: onPaymentPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.history),
          label: const Text('Última'),
          onPressed: onLastPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.print),
          label: const Text('Imprimir'),
          onPressed: onPrintPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.delete),
          label: const Text('Elimninar'),
          onPressed: onDeletePressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.file_upload),
          label: const Text('Importar CSV'),
          onPressed: onImportPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ],
    );
  }
}
