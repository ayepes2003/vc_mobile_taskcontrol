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

final controller = TextEditingController();

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
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 100));
    final provider = Provider.of<RouteCardProvider>(context, listen: false);
    final routeDataProvider = Provider.of<RouteDataProvider>(
      context,
      listen: false,
    );
    // final resultado = provider.findByCodeProces(code.trim());
    final selectedSectionId =
        routeDataProvider.selectedSectionId ??
        AppPreferences.getSectionId() ??
        0;
    final selectedSectionName =
        routeDataProvider.section ?? AppPreferences.getSection() ?? '';

    final resultado = await provider.searchByCodeProcesAndSectionId(
      code.trim(),
      selectedSectionId,
      selectedSectionName,
    );

    setState(() {
      _resultado = resultado;
    });

    if (resultado == null) {
      // Aquí se muestra el mensaje si NO se encontró nada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se encontró registro con ese código en la sección seleccionada. (Memory,Sqlite,Api)',
          ),
        ),
      );
      return;
    }
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

        //no hay tarjeta por seccion y codigo
      }
      print('${resultado.codePiece} ${resultado.itemCode}');

      final cantidadStr = await showQuantityDialog(
        context,
        initialQuantity,
        registeredQuantity,
        tolerance,
        toleranceDifference,
        code,
        remaining,
        resultado.codePiece,
        resultado.itemCode,
      );

      if (cantidadStr != null && cantidadStr.isNotEmpty) {
        final parts = cantidadStr.split('|');
        final cantidad = int.tryParse(parts[0]) ?? 0;
        final isPartial = parts.length > 1 && parts[1] == 'true';
        // int cantidad = int.tryParse(cantidadStr) ?? 0;

        await AppPreferences.setProject(resultado.projectName);
        await AppPreferences.setSectionId(int.parse(resultado.sectionId));

        Provider.of<RouteDataProvider>(context, listen: false).setFromRoute(
          project: resultado.projectName,
          itemCode: resultado.itemCode,
          section: resultado.sectionName,
          totalPiece: initialQuantity,
          // selectSectionId: int.tryParse(resultado.sectionId),
        );
        Provider.of<RouteDataProvider>(
          context,
          listen: false,
        ).setRealQuantity(cantidad);

        // Send to provider memory tablet
        provider.addRead(resultado, cantidad, isPartial);
        // save to local sqlite and send to api server
        await provider.addReadLocal(resultado, cantidad, isPartial);
      }
    }
  }

  Future<String?> showQuantityDialog(
    BuildContext context,
    int initialQuantity,
    int registeredQuantity,
    int tolerance,
    int toleranceDifference,
    String code,
    int remaining,
    String esquema,
    String material,
  ) async {
    final focusNode = FocusNode();
    String? errorText;
    bool isPartial = false;
    final sectionName = AppPreferences.getSection();
    final int remainingQuantity = initialQuantity - registeredQuantity;
    // final controller = TextEditingController();
    final controller = TextEditingController(
      text: remainingQuantity.toString(),
    );
    void onValidate(StateSetter setStateDialog) {
      final val = controller.text.trim();
      final parsed = int.tryParse(val);

      // --- Validación modificada según el switch ---
      if (!isPartial) {
        // Si NO es parcial, usa las validaciones actuales
        if (val.isEmpty || parsed == null || parsed <= 0) {
          errorText = "Ingrese un número válido mayor que cero";
          setStateDialog(() {});
          focusNode.requestFocus();
          return;
        } else if (parsed > remainingQuantity) {
          errorText =
              "No puede ser mayor que la cantidad restante por registrar ($remainingQuantity).";
          setStateDialog(() {});
          focusNode.requestFocus();
          return;
        }
      } else {
        if (val.isEmpty || parsed == null || parsed <= 0) {
          errorText = "Ingrese un número válido mayor que cero";
          setStateDialog(() {});
          focusNode.requestFocus();
          return;
        }
      }
      // Si pasa validación, retorna el valor junto con el estado de parcialidad
      Navigator.of(context).pop("$val|$isPartial");
    }

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

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
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    width: 300,
                    child: AlertDialog(
                      // title: Center(child: Text('Ingrese cantidad a reportar')),
                      title: Center(
                        child: Text('Selecione Proceso Completo ó Parcial'),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: // Supongamos que tienes disponibles estas variables:
                                // sectionName, esquema, material, code
                                sectionName == 'CORTE'
                                    ? Container(
                                      padding: const EdgeInsets.all(12),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors
                                                .yellow
                                                .shade100, // Color de fondo para CORTE
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.orange,
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            //
                                            'Esquema: $esquema',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                          Text(
                                            //  $material
                                            'Material: $material',
                                            style: TextStyle(
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                          Text(
                                            'T. Ruta: $code',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    : Text(
                                      'T. Ruta: $code',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  isPartial
                                      ? "Proceso: Parcial"
                                      : "Proceso: Completo",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isPartial ? Colors.red : Colors.green,
                                  ),
                                ),
                              ),
                              Switch(
                                value: isPartial,
                                onChanged: (val) {
                                  setStateDialog(() => isPartial = val);
                                },
                                activeColor:
                                    isDark ? Colors.redAccent : Colors.red,
                                inactiveThumbColor:
                                    isDark
                                        ? Colors.white
                                        : Colors
                                            .green, // ¡Brillante en modo oscuro!
                                inactiveTrackColor:
                                    isDark
                                        ? Colors.grey.shade700
                                        : Colors.grey.shade300,
                              ),
                            ],
                          ),
                          Text(
                            "Cambiar cantidad solo cuando sea Proceso Parcial",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          QuantityWidget(
                            remainingQuantity: remainingQuantity,
                            initialQuantity: initialQuantity,
                            registeredQuantity: registeredQuantity,
                            controller: controller,
                            focusNode: focusNode,
                            errorText: errorText,
                            onFieldSubmitted: () => onValidate(setStateDialog),
                          ),

                          if (errorText != null)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  errorText!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 12),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed:
                              () => Navigator.of(dialogContext).pop(null),
                          child: const Text('CANCELAR'),
                        ),
                        ElevatedButton(
                          onPressed: () => onValidate(setStateDialog),
                          child: const Text('ACEPTAR'),
                        ),
                      ],
                    ),
                  ),
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
                // keyboardType: TextInputType.text para digitar texto,
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
                  // _searchFocusNode.requestFocus();
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

          const SizedBox(width: 6),
          IconButton(
            tooltip: 'Historial',
            icon: Icon(Icons.history, color: Colors.deepOrange),
            onPressed: () {
              /* Mostrar el historial */
            },
          ),
        ],
      ),
    );
  }
}

class QuantityWidget extends StatelessWidget {
  const QuantityWidget({
    super.key,
    required this.remainingQuantity,
    required this.initialQuantity,
    required this.registeredQuantity,
    required this.controller,
    required this.focusNode,
    required this.errorText,
    required this.onFieldSubmitted,
  });

  final int remainingQuantity;
  final int initialQuantity;
  final int registeredQuantity;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final VoidCallback onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inicial: $initialQuantity',
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Registrada: $registeredQuantity',
                style: const TextStyle(color: Colors.grey, fontSize: 18),
              ),
              Text(
                'Restante: $remainingQuantity',
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),

        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: TextFormField(
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
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontSize: 22,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              onFieldSubmitted: (_) => onFieldSubmitted(),
            ),
          ),
        ),
      ],
    );
  }
}
