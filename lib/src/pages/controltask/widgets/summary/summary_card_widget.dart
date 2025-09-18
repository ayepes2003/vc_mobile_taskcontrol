import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/events/event_report_dialog.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/route_data_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/router_card_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/sections_provider.dart';
import 'package:vc_taskcontrol/src/storage/preferences/app_preferences.dart';
import 'package:vc_taskcontrol/src/storage/routes/route_database.dart';

class SummaryCardWidget extends StatelessWidget {
  // final int? realQuantity;
  final Widget? lastEntry;
  //  this.realQuantity,
  const SummaryCardWidget({super.key, this.lastEntry});

  @override
  Widget build(BuildContext context) {
    final bool tablet = MediaQuery.of(context).size.width > 700;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // Recupera los datos desde el Provider
    final routeData = context.watch<RouteDataProvider>();
    final realQuantity = context.watch<RouteDataProvider>().realQuantity;

    final int estimatedQuantity = routeData.totalPieces ?? 0;
    final int difference = (realQuantity ?? 0) - estimatedQuantity;

    // cantidades por ultima ruta leida
    final provider = Provider.of<RouteCardProvider>(context);
    final int estimated = provider.estimatedQuantity;
    final int real = provider.realQuantityAccumulated;
    final int diff = provider.difference;

    final String project = routeData.projectName?.trim() ?? 'Sin proyecto';

    final String supervisor = routeData.supervisor?.trim() ?? '—';
    final String operatorName = routeData.operatorName?.trim() ?? '—';
    final String section = routeData.section?.trim() ?? '—';
    final String subsection = routeData.subsection?.trim() ?? '—';
    // print("Supervisor: $supervisor");
    // print("Operator:$operatorName");
    // print("Section:$section");
    // print("Subsection $subsection");
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          // Proyecto arriba
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.13),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.assignment, size: 32, color: colorScheme.primary),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    project,
                    style: textTheme.titleLarge!.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 1),
          // Cantidades en el centro
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("CANTIDAD", style: textTheme.titleMedium),
                  _buildSummaryRow(context, "Inicial", estimated.toString()),
                  _buildSummaryRow(context, "Real", (real ?? "-").toString()),
                  _buildSummaryRow(
                    context,
                    "Faltante",
                    diff.toString(),
                    highlight: difference > 0,
                  ),
                ],
              ),
            ),
          ),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _buildSummaryRow(context, "Supervisor", supervisor),
                  _buildSummaryRow(context, "Operario", operatorName),
                  _buildSummaryRow(context, "Sección", section),
                  _buildSummaryRow(context, "SubSección", subsection),
                ],
              ),
            ),
          ),
          // Último dato abajo
          if (!tablet && lastEntry != null)
            lastEntry!
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconButton(
                    tooltip: "Cargar todas las tarjetas rutas por seccion",
                    icon: Icons.download_for_offline,
                    onPressed: () async {
                      final sectionName = AppPreferences.getSection();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$sectionName: Cargando rutas...'),
                        ),
                      );
                      await Future.wait([
                        Provider.of<RouteCardProvider>(
                          context,
                          listen: false,
                        ).loadRoutesFromApi(sectionName: sectionName),
                      ]);
                    },
                  ),
                  SizedBox(width: 8),
                  _buildIconButton(
                    tooltip: "Reportar Eventos",
                    icon: Icons.timer_outlined,
                    onPressed: () async {
                      final sectionName =
                          AppPreferences.getSection() ?? 'SinSección';

                      await Provider.of<SectionsProvider>(
                        context,
                        listen: false,
                      ).loadEventSectionsFromApi(sectionName: sectionName);

                      final events =
                          Provider.of<SectionsProvider>(
                            context,
                            listen: false,
                          ).eventSections;

                      if (events.isNotEmpty) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => EventReportDialog(events: events),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'No se encontraron eventos para la sección seleccionada.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool highlight = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.3),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium!.copyWith(
                color: highlight ? Colors.red : colorScheme.onSurface,
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Función auxiliar para crear icon buttons con tooltip
Widget _buildIconButton({
  required String tooltip,
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: Colors.red, size: 28),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
      ),
    ),
  );
}



// _buildIconButton(
                  //   tooltip: "Eliminar todas las tarjetas leídas",
                  //   icon: Icons.delete_forever,
                  //   onPressed: () async {
                  //     await RouteDatabase().clearAllRouteCards();
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //         content: Text(
                  //           'Se eliminaron todas las tarjetas rutas.',
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),

                  // Text(
                  //   'Sin datos recientes',
                  //   style: textTheme.bodyLarge!.copyWith(
                  //     color: colorScheme.secondary,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 16,
                  //   ),
                  // ),