import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card_read.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/actions_buttons/action_pieces_buttons.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/kpi_count_card.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/routecard/route_card_tablet.dart';
import 'package:vc_taskcontrol/src/providers/router_card_provider.dart';
import 'package:vc_taskcontrol/src/widgets/search_field.dart';

class PiecesStepWidget extends StatefulWidget {
  final VoidCallback onCameraPressed;

  const PiecesStepWidget({super.key, required this.onCameraPressed});

  @override
  State<PiecesStepWidget> createState() => _PiecesStepWidgetState();
}

class _PiecesStepWidgetState extends State<PiecesStepWidget> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  RouteCard? _resultado;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String code) {
    final provider = Provider.of<RouteCardProvider>(context, listen: false);
    final resultado = provider.findByCodeProces(code.trim());
    print(
      'Buscando: $code, Encontrado: ${resultado != null ? resultado.codeProces : 'null'}',
    );
    setState(() {
      _resultado = resultado;
    });

    if (resultado != null) {
      // Aquí agregas la lectura a la lista principal
      provider.addRead(
        resultado,
        12,
      ); // Usa una cantidad de prueba o la real (ver nota abajo)
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RouteCardProvider>(context);
    final columns =
        provider.columnsTabletVisibles; // Columnas con configuración
    final rows = provider.recentReadsLimited; // Los últimos 50 registros leídos
    final screenHeight = MediaQuery.of(context).size.height;
    final usableHeight =
        screenHeight *
        0.85; // por ejemplo, 60% del alto disponible central content
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: Column(
            children: [
              searchWidget(context),
              Container(
                margin: const EdgeInsets.all(5),
                width: double.infinity,
                height: usableHeight - 150,
                // color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                color: Theme.of(context).colorScheme.surfaceBright,
                child: Column(
                  children: [
                    // Widget para KPIs totales (siempre arriba o debajo según prefieras)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child:
                          KPICountsWidget(), // Define tu propio widget de KPIs totales
                    ),

                    // Tabla con scroll vertical y horizontal
                    PrintTableRoute(columns, rows),

                    Row(
                      children: [
                        const SizedBox(height: 5),
                        // Título/etiqueta siempre al fondo (bajo la tabla)
                        Column(
                          children: [
                            Text('Tarjetas de Ruta Leídas'),
                            Text(
                              _resultado != null
                                  ? 'Código: ${_resultado!.codeProces} - Mueble: ${_resultado!.item}'
                                  : 'No se encontró la tarjeta de ruta.',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Expanded PrintTableRoute(
    List<Map<String, dynamic>> columns,
    List<RouteCardRead> rows,
  ) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: RouteCardTablet(columns: columns, rows: rows),
            ),
          ),
        ),
      ),
    );
  }

  double _getTableWidth(List<Map<String, dynamic>> columns) {
    return columns
        .where((col) => col['visible'] != false)
        .fold<double>(0, (total, col) => total + (col['ancho'] ?? 70.0));
  }

  Container searchWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Escanea o ingresa # Tarjeta de Ruta [F1]',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (value) {
                _onSearchSubmitted(value);
                _searchController.clear();
                _searchFocusNode
                    .requestFocus(); // Mantener el foco tras limpiar
              },
            ),
          ),
          const SizedBox(width: 8),
          ActionButtonsPieces(oncamarePressed: widget.onCameraPressed),
        ],
      ),
    );
  }
}
