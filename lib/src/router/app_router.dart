import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/pages/controltask/startapp/settings_app_page.dart';
import 'package:vc_taskcontrol/src/pages/controltask/startapp/start_app_page.dart';
import 'package:vc_taskcontrol/src/pages/scanner/test_scanner_page.dart';

import '../pages/pages_base.dart';
import '../services/connection_provider.dart';

GoRouter createRouter(ConnectionProvider connectionProvider) {
  return GoRouter(
    refreshListenable: connectionProvider,
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomePage()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsAppPage(),
      ),
      GoRoute(
        path: '/prodtime',
        builder: (context, state) => ControltaskBasePage(),
      ),
      GoRoute(
        path: '/monitoring',
        builder: (context, state) => MonitoringGeneralStatusPage(),
      ),
      GoRoute(
        path: '/scannertest',
        builder: (context, state) => TestScanPage(),
      ),
      GoRoute(path: '/start_app', builder: (context, state) => StartAppPage()),
      GoRoute(
        path: '/settingsApp',
        builder: (context, state) => SettingsStartAppPage(),
      ),
      GoRoute(
        path: '/no-connection',
        builder: (context, state) => const NoConnectionPage(),
      ),
      // Otras rutas...
    ],
    redirect: (context, state) {
      final isConnected =
          Provider.of<ConnectionProvider>(context, listen: false).isConnected;
      final isSettings = state.matchedLocation == '/settings';
      final isNoConnection = state.matchedLocation == '/no-connection';

      if (!isConnected && !isSettings && !isNoConnection) {
        return '/no-connection';
      }
      if (isConnected && isNoConnection) {
        return '/';
      }
      return null;
    },
  );
}
