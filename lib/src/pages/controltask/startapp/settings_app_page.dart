import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card_read.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/kpi_total/kpi_count_card.dart';
import 'package:vc_taskcontrol/src/pages/controltask/widgets/routecard/route_card_tablet.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/hour_ranges_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/operators_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/route_data_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/sections_provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/supervisors_provider.dart';
import 'package:vc_taskcontrol/src/storage/preferences/app_preferences.dart';
import 'package:vc_taskcontrol/src/storage/preferences/general_preferences.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/router_card_provider.dart';
import 'package:vc_taskcontrol/src/services/connection_provider.dart';
import 'package:vc_taskcontrol/src/storage/routes/route_database.dart';
import 'package:vc_taskcontrol/src/widgets/custom_app_bar.dart';
import 'package:vc_taskcontrol/src/widgets/menus/custom_menu_drawer.dart';

class SettingsStartAppPage extends StatefulWidget {
  const SettingsStartAppPage({super.key});

  @override
  State<SettingsStartAppPage> createState() => _SettingsStartAppPageState();
}

class _SettingsStartAppPageState extends State<SettingsStartAppPage> {
  String _footerMessage = 'Estado: listo';
  String? _selectedSection;
  List<String> _availableSections =
      []; // Lista dummy o viene del provider/preferences

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Future.microtask(() async {
      final routeProvider = Provider.of<RouteDataProvider>(
        context,
        listen: false,
      );
      final provider = Provider.of<RouteCardProvider>(context, listen: false);
      provider.loadRoutesFromLocal();
      await provider.loadRecentReads();

      final providerSection = routeProvider.section;
      final prefsSection = await AppPreferences.getSection();
      setState(() {
        _footerMessage =
            'Sección Provider: $providerSection | Sección Pref: $prefsSection Enviada : ${provider.currentLoadingSection ?? "ninguna"}';
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _updateFooterWithProviderSection() {
  //   final provider = Provider.of<RouteDataProvider>(context, listen: false);
  //   final prefsSection = _prefsSection ?? 'no cargada';
  //   final providerSection = provider.currentLoadingSection ?? 'ninguna';

  //   setState(() {
  //     _footerMessage =
  //         'Sección Provider: $providerSection | Sección Pref: $prefsSection';
  //   });
  // }

  Future<void> _handleLoadAllRoutes() async {
    await Future.wait([
      Provider.of<RouteCardProvider>(
        context,
        listen: false,
      ).loadRoutesFromApi(),
    ]);
  }

  Future<void> _handleDeleteAllRoutes() async {
    await RouteDatabase().clearAllRouteCards();
  }

  Future<void> _handleDeleteRoutesReads() async {
    await RouteDatabase().clearAllReads();
  }

  Future<void> _handleDataRefresh(BuildContext context) async {
    Provider.of<HourRangesProvider>(
      context,
      listen: false,
    ).loadHourRangesFromApi();

    Provider.of<SectionsProvider>(context, listen: false).loadSectionsFromApi();
    Provider.of<OperatorsProvider>(
      context,
      listen: false,
    ).loadOperatorsFromApi();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('sincronizando datos base desde el servidor'),
      ),
    );
  }

  Future<void> _handleRefresh(BuildContext context) async {
    await RouteDatabase().clearAllReads();
    Provider.of<SupervisorsProvider>(
      context,
      listen: false,
    ).loadSupervisorsFromApi();
    //hora hora
    Provider.of<HourRangesProvider>(
      context,
      listen: false,
    ).loadHourRangesFromApi();

    Provider.of<SectionsProvider>(context, listen: false).loadSectionsFromApi();
    Provider.of<OperatorsProvider>(
      context,
      listen: false,
    ).loadOperatorsFromApi();

    await Provider.of<RouteCardProvider>(
      context,
      listen: false,
    ).loadRoutesFromLocal();

    await Provider.of<RouteCardProvider>(
      context,
      listen: false,
    ).loadRecentReads();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Actualizando datos...')));
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = Provider.of<ConnectionProvider>(context).isConnected;
    final provider = Provider.of<RouteCardProvider>(context);

    // if (provider.isLoading) {
    //   return Center(
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: const [
    //         CircularProgressIndicator(),
    //         SizedBox(height: 12),
    //         Text('Cargando rutas, por favor espera...'),
    //       ],
    //     ),
    //   );
    // }
    // final hasData =
    //     (provider.routes.isNotEmpty || provider.recentReads.isNotEmpty);

    // final routes = provider.routes;
    // final recentReads = provider.recentReads;

    // final columns = provider.columnsAppVisibles;
    // final rows = 50;
    // final screenHeight = MediaQuery.of(context).size.height;
    for (var read in provider.recentReadsLimited) {
      print(
        'DEBUG error Columnas - section: ${read.section}, subsection: ${read.subsection}',
      );
    }
    return Scaffold(
      appBar: CustomAppBar(
        empresa: 'Milestone Muebles SAS',
        usuario: 'Usuario: ayepes2003@yahoo.es',
        fechaHora: '26/03/2025 20:00',
        isConnected: isConnected,
        title_app: 'Application Settings General',
      ),
      drawer: const CustomDrawerMenu(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // HEADER fijo siempre visible
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _headerBar(),
                  ),
                ),
                // Area expandida que incluye tabla o mensaje
                Expanded(
                  child:
                      provider.recentReadsLimited.isEmpty
                          ? Center(
                            child: Column(
                              children: [
                                Text(
                                  'No hay registros de Tarjetas de Ruta Leidas.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: RouteCardTablet(
                                    columns: provider.columnsAppVisibles,
                                    rows: provider.recentReadsLimited,
                                  ),
                                ),
                              ),
                            ),
                          ),
                ),
                // FOOTER fijo
                Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _footerMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            // Loader solo sobre el área expandida (tabla)
            if (provider.isLoading)
              Positioned(
                top: 60, // Ajusta con la altura del header para que no lo cubra
                left: 0,
                right: 0,
                bottom: 50, // Altura del footer para dejar visible
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionButtons() {
    if (_availableSections.isEmpty) {
      return const SizedBox.shrink(); // No muestra nada si no hay secciones
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            _availableSections.map((section) {
              final isSelected = section == _selectedSection;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? Colors.blue : Colors.grey[300],
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedSection = section;
                      _footerMessage =
                          'Sección Seleccionada: $_selectedSection';
                    });
                  },
                  child: Text(section),
                ),
              );
            }).toList(),
      ),
    );
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

  Widget _headerBar() {
    return Row(
      children: [
        // KPICountsWidget(),
        _buildIconButton(
          tooltip: "Actualizar datos (Supervisores, Operadores, etc.)",
          icon: Icons.manage_accounts,
          onPressed: () async {
            _footerMessage =
                "Actualizando datos (Supervisores, Operadores, etc.)";
            _handleDataRefresh(context);
            setState(() {});
          },
        ),
        _buildIconButton(
          tooltip: "Cargar todas las tarjetas rutas por seccion",
          icon: Icons.download_for_offline,
          onPressed: () async {
            final sectionName = AppPreferences.getSection();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$sectionName: Cargando rutas...')),
            );
            await Future.wait([
              Provider.of<RouteCardProvider>(
                context,
                listen: false,
              ).loadRoutesFromApi(sectionName: sectionName),
            ]);
            // _handleLoadAllRoutes();
          },
        ),
        _buildIconButton(
          tooltip: "Exportar tarjetas de ruta al servidor",
          icon: Icons.import_export,
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Exportando tarjetas de ruta...')),
            );
          },
        ),
        _buildIconButton(
          tooltip: "Sincronizar tarjetas de ruta leídas",
          icon: Icons.sync,
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sincronizando lecturas...')),
            );
          },
        ),
        _buildIconButton(
          tooltip: "Eliminar todas las tarjetas leídas",
          icon: Icons.delete_forever,
          onPressed: () async {
            await _handleDeleteRoutesReads();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Se eliminaron todas las lecturas.'),
              ),
            );
            setState(() {
              _footerMessage = 'Se eliminaron todas las lecturas.';
            });
          },
        ),
        _buildIconButton(
          tooltip: "Eliminar todo",
          icon: Icons.delete_sweep,
          onPressed: () async {
            await _handleDeleteAllRoutes();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Se eliminaron todos los datos')),
            );
            setState(() {
              _footerMessage = 'Se eliminó todo.';
            });
          },
        ),
        // Puedes añadir más botones si quieres
      ],
    );
  }
}
