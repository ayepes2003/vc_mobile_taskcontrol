import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card_read.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/actions_buttons/action_pieces_buttons.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/kpi_total/kpi_count_card.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/routecard/route_card_tablet.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/route_data_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/router_card_provider.dart';
// import 'package:vc_taskcontrol/src/pages/scanner/widgets/scanner_widget.dart';
import 'package:vc_taskcontrol/src/providers/app/scanner/scan_history.dart';
// import 'package:vc_taskcontrol/src/pages/controltask/widgets/utils/calculator_widget%20.dart';

import 'package:vc_taskcontrol/src/storage/preferences/app_preferences.dart';
import 'package:vc_taskcontrol/src/utils/barcode/dialogs.dart';

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
    Future.microtask(() async {
      final provider = Provider.of<RouteCardProvider>(context, listen: false);
      provider.loadRoutesFromLocal();
      await provider.loadRecentReads();
    });
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

    setState(() {
      _resultado = resultado;
    });

    if (resultado != null) {
      final int initialQuantity =
          int.tryParse(resultado.totalPiece ?? '0') ?? 0;

      final int registeredQuantity = await provider.getTotalRegisteredQuantity(
        resultado.codeProces,
      );
      final tolerance = provider.tolerance;
      final toleranceDifference = provider.toleranceDifference;
      final int remaining = initialQuantity - registeredQuantity;
      if (remaining <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cantidad ya completada. No se pueden añadir más.'),
          ),
        );
        return;
      }

      final cantidadStr = await showQuantityDialog(
        context,
        initialQuantity,
        registeredQuantity,
        tolerance,
        toleranceDifference,
      );

      if (cantidadStr != null && cantidadStr.isNotEmpty) {
        int cantidad = int.tryParse(cantidadStr) ?? 0;

        await AppPreferences.setProject(resultado.projectName);

        Provider.of<RouteDataProvider>(context, listen: false).setFromRoute(
          project: resultado.projectName,
          itemCode: resultado.itemCode,
          totalPiece: initialQuantity,
        );
        Provider.of<RouteDataProvider>(
          context,
          listen: false,
        ).setRealQuantity(cantidad);
        provider.addRead(resultado, cantidad);
        await provider.addReadLocal(resultado, cantidad);
      }
    }
  }

  Future<String?> showQuantityDialog(
    BuildContext context,
    int initialQuantity, // Cantidad estimada o inicial total
    int registeredQuantity, // Sumatoria ya registrada guardada en DB
    int tolerance,
    int toleranceDifference,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    String? errorText;

    // Calculamos la diferencia (lo que falta registrar)
    final int remainingQuantity = initialQuantity - registeredQuantity;

    void onValidate(StateSetter setStateDialog) {
      final val = controller.text.trim();
      final parsed = int.tryParse(val);

      if (val.isEmpty || parsed == null || parsed <= 0) {
        errorText = "Ingrese un número válido mayor que cero";
        setStateDialog(() {});
        focusNode.requestFocus();
      } else if (parsed > remainingQuantity) {
        errorText =
            "No puede ser mayor que la cantidad restante por registrar ($remainingQuantity).";
        setStateDialog(() {});
        focusNode.requestFocus();
      } else {
        // Entrada válida: cierra el diálogo y retorna el valor
        Navigator.of(context).pop(val);
      }
    }

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  top: 20,
                  left: 24,
                  right: 24,
                ),
                child: AlertDialog(
                  title: const Text('Ingrese cantidad'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cantidad inicial: $initialQuantity',
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Cantidad registrada: $registeredQuantity',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Cantidad restante: $remainingQuantity',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Cantidad',
                          border: const OutlineInputBorder(),
                          errorText: errorText,
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: Icon(Icons.numbers, color: Colors.green),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontSize: 22,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        onFieldSubmitted: (_) {
                          onValidate(setStateDialog);
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
                      onPressed: () => Navigator.of(dialogContext).pop(null),
                      child: const Text('CANCELAR'),
                    ),
                    ElevatedButton(
                      onPressed: () => onValidate(setStateDialog),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RouteCardProvider>(context);
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final routes = provider.routes;
    final recentReads = provider.recentReads;

    if (routes.isEmpty && recentReads.isEmpty) {
      return const Center(
        child: Text(
          'No hay registros de Tarjetas de Ruta disponibles.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
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
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 7,
            child: SizedBox(
              width: 300,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _searchController,
                focusNode: _searchFocusNode,
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
                  _searchFocusNode.requestFocus();
                },
              ),
            ),
          ),
          const SizedBox(width: 6),
          ActionButtonsPieces(
            oncamarePressed: () async {
              final code = await showQrScannerDialog(context);
              if (code != null && code.isNotEmpty) {
                _onSearchSubmitted(code);
                context.read<ScanHistoryProvider>().addScan(
                  code: code,
                  deviceId:
                      "tuDeviceId", // reemplaza por tu variable/config real
                  timestamp: DateTime.now(),
                  deviceModel: "tuModelo",
                  deviceAlias: "tuAlias",
                ); // Usa tu handler normal
              }
            },
          ),
          // ActionButtonsPieces(
          //   oncamarePressed: () async {
          //     final code = await showDialog<String>(
          //       context: context,
          //       builder:
          //           (context) => Dialog(
          //             backgroundColor: Colors.black87,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //             insetPadding: const EdgeInsets.all(24),
          //             child: SizedBox(
          //               width: 340,
          //               height: 420,
          //               child: Stack(
          //                 children: [
          //                   ScannerWidget(
          //                     onCodeRead:
          //                         (code) => Navigator.of(context).pop(code),
          //                   ),
          //                   Positioned(
          //                     top: 8,
          //                     right: 8,
          //                     child: IconButton(
          //                       icon: Icon(
          //                         Icons.close,
          //                         color: Colors.white,
          //                         size: 30,
          //                       ),
          //                       onPressed: () => Navigator.of(context).pop(),
          //                       tooltip: 'Cancelar',
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //     );
          //     if (code != null && code.isNotEmpty) {
          //       // Aquí usas tu flujo normal
          //       _onSearchSubmitted(
          //         code,
          //       ); // O el método que ya uses para validar/buscar y mostrar diálogo de cantidad
          //     }
          //   },
          // ),
          const SizedBox(width: 6),
          IconButton(
            tooltip: 'Historial',
            icon: Icon(Icons.history, color: Colors.blueAccent),
            onPressed: () {
              /* Mostrar el historial */
            },
          ),
        ],
      ),
    );

    // return Container(
    //   margin: const EdgeInsets.all(6),
    //   padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).colorScheme.surface,
    //     borderRadius: BorderRadius.circular(8),
    //   ),
    //   child: Row(
    //     children: [
    //       Expanded(
    //         child: TextField(
    //           keyboardType: TextInputType.number,
    //           controller: _searchController,
    //           focusNode: _searchFocusNode,
    //           autofocus: true,
    //           decoration: InputDecoration(
    //             labelText: 'Escanea o ingresa # Tarjeta de Ruta [F1]',
    //             suffixIcon: const Icon(Icons.search),
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(10),
    //             ),
    //           ),
    //           onSubmitted: (value) {
    //             _onSearchSubmitted(value);
    //             _searchController.clear();
    //             _searchFocusNode
    //                 .requestFocus(); // Mantener el foco tras limpiar
    //           },
    //         ),
    //       ),
    //       const SizedBox(width: 6),
    //       ActionButtonsPieces(oncamarePressed: widget.onCameraPressed),
    //     ],
    //   ),
    // );
  }
}
