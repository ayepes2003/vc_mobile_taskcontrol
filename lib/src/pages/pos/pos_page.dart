// lib/src/pages/pos_page.dart
import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/services/connection_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_app_bar.dart';
import 'widgets/left_section.dart';
import 'widgets/right_section.dart';

class PosPage extends StatelessWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isConnected = Provider.of<ConnectionProvider>(context).isConnected;
    return Scaffold(
      appBar: CustomAppBar(
        // empresa: 'Agroonline.co (Basilm)',
        empresa: 'Milestone Muebles SAS  ',
        usuario: 'Usuario: ayepes2003@yahoo.es',
        fechaHora: '26/03/2025 20:00',
        isConnected: isConnected,
        title_app: 'Packing Control Load /Time Task Control',
        // isConnected: true,
      ),
      body: Row(
        children: [
          // Sección izquierda (Búsqueda y tabla)
          const Expanded(
            flex: 7, // Ocupa 70% del ancho
            child: LeftSection(),
          ),
          // Sección derecha (Card de resumen)
          const Expanded(
            flex: 3, // Ocupa 30% del ancho
            child: RightSection(),
          ),
        ],
      ),
    );
  }
}
