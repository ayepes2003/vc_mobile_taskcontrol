import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/storage/preferences/general_preferences.dart';

class ApiRestConfigCard extends StatefulWidget {
  const ApiRestConfigCard({Key? key}) : super(key: key);

  @override
  State<ApiRestConfigCard> createState() => _ApiRestConfigCardState();
}

class _ApiRestConfigCardState extends State<ApiRestConfigCard> {
  bool useHttps = false;
  late TextEditingController ipController;
  late TextEditingController portController;
  late TextEditingController pathController;

  @override
  void initState() {
    super.initState();

    // final uri = Uri.tryParse(GeneralPreferences.urlApiRest);
    // useHttps = uri?.scheme == 'http';
    ipController = TextEditingController(text: GeneralPreferences.apiBase);
    portController = TextEditingController(text: GeneralPreferences.apiPort);
    pathController = TextEditingController(
      text: GeneralPreferences.apiEndpoint,
    );

    // ipController = TextEditingController(
    //   text: (uri?.host.isNotEmpty ?? false) ? uri!.host : '172.16.100.10',
    // );
    // portController = TextEditingController(
    //   text:
    //       uri?.hasPort == true
    //           ? uri!.port.toString()
    //           : (useHttps ? '443' : '80'),
    // );
    // pathController = TextEditingController(
    //   text: (uri?.path.isNotEmpty ?? false) ? uri!.path : '/api/v3',
    // );
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
    final protocol = useHttps ? 'https' : 'http';
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
            Row(
              children: [
                const Text('Protocolo:'),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('http'),
                  selected: !useHttps,
                  onSelected: (v) => setState(() => useHttps = false),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('https'),
                  selected: useHttps,
                  onSelected: (v) => setState(() => useHttps = true),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: 'Servidor/IP',
                icon: Icon(Icons.dns),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Puerto',
                icon: Icon(Icons.confirmation_num),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: pathController,
              decoration: const InputDecoration(
                labelText: 'Ruta endpoint',
                icon: Icon(Icons.alt_route),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            const Text(
              'URL generada:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              urlPreview,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Guardar ApiRest'),
              onPressed: () {
                GeneralPreferences.apiBase = ipController.text;
                GeneralPreferences.apiPort = portController.text;
                GeneralPreferences.apiEndpoint = pathController.text;
                // Si tienes protocolo editable:
                // GeneralPreferences.apiProtocol = useHttps ? 'https' : 'http';
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Parámetros API guardados!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
