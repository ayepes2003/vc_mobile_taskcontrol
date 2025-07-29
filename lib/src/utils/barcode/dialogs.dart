// lib/utils/dialogs.dart
import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/pages/scanner/widgets/scanner_widget.dart';

Future<String?> showQrScannerDialog(BuildContext context) async {
  return await showDialog<String>(
    context: context,
    builder:
        (context) => Dialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 340,
            height: 420,
            child: Stack(
              children: [
                ScannerWidget(
                  onCodeRead: (code) => Navigator.of(context).pop(code),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Cancel',
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}
