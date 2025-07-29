import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/pages/scanner/widgets/scanner_widget.dart';
import 'package:vc_taskcontrol/src/providers/app/scanner/scan_history.dart';
import 'package:vc_taskcontrol/src/utils/barcode/dialogs.dart';

// Importa aquí ScanItem y ScannerWidget según tu estructura

class TestScanPage extends StatelessWidget {
  const TestScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scans = context.watch<ScanHistoryProvider>().items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Lecturas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Lista de lecturas (historial)
          Expanded(
            child:
                scans.isEmpty
                    ? const Center(child: Text('No hay lecturas registradas'))
                    : ListView.builder(
                      itemCount: scans.length,
                      itemBuilder: (context, index) {
                        final item = scans[index];
                        return ListTile(
                          leading: Icon(
                            item.sent ? Icons.cloud_done : Icons.cloud_upload,
                            color: item.sent ? Colors.green : Colors.orange,
                          ),
                          title: Text(item.code),
                          subtitle: Text(
                            '${item.dateTime}\n${item.deviceAlias} (${item.deviceModel})',
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing:
                              item.sent
                                  ? const Text(
                                    'Enviado',
                                    style: TextStyle(color: Colors.green),
                                  )
                                  : const Text(
                                    'Pendiente',
                                    style: TextStyle(color: Colors.orange),
                                  ),
                          isThreeLine: true,
                        );
                      },
                    ),
          ),
          // Botón para abrir el escáner en un modal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Leer código'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  final code = await showQrScannerDialog(context);
                  if (code != null && code.isNotEmpty) {
                    // Aquí debes pasar los datos de tu dispositivo según lo tengas disponible
                    context.read<ScanHistoryProvider>().addScan(
                      code: code,
                      deviceId:
                          "tuDeviceId", // reemplaza por tu variable/config real
                      timestamp: DateTime.now(),
                      deviceModel: "tuModelo",
                      deviceAlias: "tuAlias",
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Código "$code" registrado'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
