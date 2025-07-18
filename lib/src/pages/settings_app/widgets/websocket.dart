import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/storage/preferences/general_preferences.dart';

class WebSocketConfigCard extends StatefulWidget {
  const WebSocketConfigCard({Key? key}) : super(key: key);

  @override
  State<WebSocketConfigCard> createState() => _WebSocketConfigCardState();
}

class _WebSocketConfigCardState extends State<WebSocketConfigCard> {
  bool useWss = false;
  late TextEditingController ipController;
  late TextEditingController portController;
  late TextEditingController pathController;

  @override
  void initState() {
    super.initState();
    final uri = Uri.tryParse(GeneralPreferences.urlWebSocket);
    useWss = uri?.scheme == 'wss';
    ipController = TextEditingController(
      text: uri?.host.isNotEmpty == true ? uri!.host : '172.16.100.10',
    );
    portController = TextEditingController(
      text:
          uri?.hasPort == true ? uri!.port.toString() : (useWss ? '443' : '80'),
    );
    pathController = TextEditingController(
      text: uri?.path.isNotEmpty == true ? uri!.path : '/',
    );
  }

  @override
  void dispose() {
    ipController.dispose();
    portController.dispose();
    pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final protocol = useWss ? 'wss' : 'ws';
    final port =
        portController.text.isNotEmpty ? ':${portController.text}' : '';
    final path =
        pathController.text.startsWith('/')
            ? pathController.text
            : '/${pathController.text}';
    final urlPreview = '$protocol://${ipController.text}$port$path';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de protocolo
            Row(
              children: [
                const Text('Protocolo:'),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('ws'),
                  selected: !useWss,
                  onSelected: (v) => setState(() => useWss = false),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('wss'),
                  selected: useWss,
                  onSelected: (v) => setState(() => useWss = true),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: 'Servidor/IP WebSocket',
                icon: Icon(Icons.dns),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Puerto WebSocket',
                icon: Icon(Icons.confirmation_num),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: pathController,
              decoration: const InputDecoration(
                labelText: 'Ruta WebSocket',
                icon: Icon(Icons.alt_route),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            const Text(
              'URL WebSocket generada:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              urlPreview,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Guardar WebSocket'),
              onPressed: () {
                GeneralPreferences.urlWebSocket = urlPreview;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Dirección WebSocket guardada!'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// // WebSocket (si tienes un formulario/editor separado)
    // wsIpController.text = GeneralPreferences.wsBase;
    // wsPortController.text = GeneralPreferences.wsPort;
    // wsPathController.text = GeneralPreferences.wsEndpoint;
    // Si tienes wsProtocol/ssl, asigna wsUseWss igual según preferencias.