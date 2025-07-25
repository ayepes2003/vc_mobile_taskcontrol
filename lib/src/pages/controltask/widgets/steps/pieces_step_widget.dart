import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card_read.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/actions_buttons/action_pieces_buttons.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/calculator_widget%20.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/kpi_count_card.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/routecard/route_card_tablet.dart';
import 'package:vc_taskcontrol/src/providers/route_data_provider.dart';
import 'package:vc_taskcontrol/src/providers/router_card_provider.dart';
import 'package:vc_taskcontrol/src/storage/preferences/app_preferences.dart';
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

  Future<void> _onSearchSubmitted(String code) async {
    final provider = Provider.of<RouteCardProvider>(context, listen: false);
    final resultado = provider.findByCodeProces(code.trim());

    //   'Buscando: $code, Encontrado: ${resultado != null ? resultado.codeProces : 'null'}',
    // );
    setState(() {
      _resultado = resultado;
    });

    if (resultado != null) {
      final int estimated = int.tryParse(resultado.totalPiece ?? '0') ?? 0;
      const int tolerance = 5; // pon el valor que necesitas
      String? cantidadStr = await showQuantityDialog(
        context,
        estimated,
        tolerance,
      );

      if (cantidadStr != null && cantidadStr.isNotEmpty) {
        int cantidad = int.tryParse(cantidadStr) ?? 0;
        await AppPreferences.setProject(resultado.projectName);

        Provider.of<RouteDataProvider>(context, listen: false).setFromRoute(
          project: resultado.projectName,
          itemCode: resultado.item,
          totalPiece: int.tryParse(resultado.totalPiece ?? '0') ?? 0,
        );
        Provider.of<RouteDataProvider>(
          context,
          listen: false,
        ).setRealQuantity(cantidad);
        // print(
        //   "DEBUG: Supervisor tras búsqueda de ruta NO debería cambiar: ${Provider.of<RouteStaticDataProvider>(context, listen: false).supervisor}",
        // );
        provider.addRead(resultado, cantidad);
      }
    }
  }

  Future<String?> showQuantityDialog(
    BuildContext context,
    int estimated,
    int tolerance,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    String? errorText;

    void onValidate() {
      final val = controller.text.trim();
      final parsed = int.tryParse(val);
      if (val.isEmpty || parsed == null || parsed == 0) {
        errorText = "Ingrese un número válido mayor que cero";
        controller.clear();
        focusNode.requestFocus();
      } else if (parsed > estimated + tolerance) {
        errorText =
            "La cantidad reportada es superior a la inicial, hay un tope de unidades de tolerancia.\n\n";
        // "No puede exceder ${estimated + tolerance} (Estimada + $tolerance)";
        controller.clear();
        focusNode.requestFocus();
      } else {
        Navigator.of(context).pop(val);
        return;
      }
      // Llama setState solo una vez aquí
      (context as Element).markNeedsBuild();
    }

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        Future.microtask(() {
          if (focusNode.canRequestFocus) focusNode.requestFocus();
        });
        return StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                title: const Text('Ingrese cantidad'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Cantidad',
                        border: const OutlineInputBorder(),
                        errorText: errorText,
                      ),
                      onFieldSubmitted: (_) {
                        setState(onValidate);
                      },
                    ),
                    if (errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    child: const Text('CANCELAR'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(onValidate),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      },
    );
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
        0.95; // por ejemplo, 60% del alto disponible central content
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
          padding: const EdgeInsets.all(1.0),
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
