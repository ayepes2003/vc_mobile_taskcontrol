import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/services/connection_provider.dart';
import 'package:vc_taskcontrol/src/widgets/custom_app_bar.dart';

class NoConnectionPage extends StatelessWidget {
  const NoConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isConnected = Provider.of<ConnectionProvider>(context).isConnected;
    return Scaffold(
      appBar: CustomAppBar(
        empresa: 'Milestone Muebles SAS',
        usuario: 'Usuario: ayepes2003@yahoo.es',
        fechaHora: '26/03/2025 20:00',
        isConnected: isConnected ?? false,
        title_app: 'Production Time Control(HorApp)',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'Sin conexión al Servidor',
              style: TextStyle(fontSize: 22, color: theme.colorScheme.primary),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<ConnectionProvider>().checkApiConnection();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
