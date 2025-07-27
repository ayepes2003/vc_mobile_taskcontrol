import 'package:flutter/material.dart';

class ActionButtonsPieces extends StatelessWidget {
  // final VoidCallback onCancelPressed;
  // final VoidCallback onPaymentPressed;
  // final VoidCallback onLastPressed;
  // final VoidCallback onPrintPressed;
  // final VoidCallback onDeletePressed;
  // final VoidCallback onImportPressed;
  final VoidCallback oncamarePressed;

  const ActionButtonsPieces({
    super.key,
    // required this.onCancelPressed,
    // required this.onPaymentPressed,
    // required this.onLastPressed,
    // required this.onPrintPressed,
    // required this.onDeletePressed,
    // required this.onImportPressed,
    required this.oncamarePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          icon: Icon(
            Icons.qr_code,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          label: Text(
            'QR',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          onPressed: oncamarePressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
