import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
