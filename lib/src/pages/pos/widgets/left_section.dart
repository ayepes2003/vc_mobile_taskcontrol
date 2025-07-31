import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/pages/pos/widgets/search_pos_field.dart';
import 'package:vc_taskcontrol/src/pages/pos/widgets/search_provider.dart';
import 'package:vc_taskcontrol/src/providers/pos/table_provider.dart';
import 'package:vc_taskcontrol/src/services/api_config_service.dart';
import 'package:vc_taskcontrol/src/services/connection_provider.dart';
import 'package:vc_taskcontrol/src/services/dio_servide.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/widgets/action_buttons.dart';
import 'package:vc_taskcontrol/src/widgets/pos_table.dart';

class LeftSection extends StatelessWidget {
  const LeftSection({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    final tableProvider = Provider.of<TableProvider>(context);
    final dioService = DioService(Dio(), ApiConfigService());
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              SearchPosField(
                controller: TextEditingController(
                  text: searchProvider.searchValue,
                ),
                onSubmitted: (value) {
                  searchProvider.setSearchValue(value, context);

                  searchProvider.clearSearchValue();
                },
              ),
              const SizedBox(width: 10),
              ActionButtons(
                onCancelPressed:
                    () => {
                      print('Botón Cancelar presionado'),
                      tableProvider.addItem({
                        'codigo': 'TEST1',
                        'precioPublico': 25.00, // Fondo verde
                      }),
                    },
                onPaymentPressed: () => print('Botón Abonos presionado'),
                onLastPressed: () => print('Botón Última presionado'),
                onPrintPressed: () async {
                  print('Botón Imprimir presionado');
                  try {
                    await dioService
                        .initConfig(); // Inicializa la configuración
                    final isConnected = await dioService.checkApiConnection();
                    print('Estado de conexión: $isConnected');
                    Provider.of<ConnectionProvider>(
                      context,
                    ).updateConnectionState(isConnected);
                  } catch (e) {
                    Provider.of<ConnectionProvider>(
                      context,
                    ).checkApiConnection();
                    print('Error al verificar conexión: $e');
                  }
                },

                onDeletePressed: () {
                  tableProvider.clearItems(); // Limpia todos los items
                },
                onImportPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const PosTable(),
            ),
          ),
        ],
      ),
    );
  }
}
