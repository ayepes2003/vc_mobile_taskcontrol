import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vc_taskcontrol/src/providers/data_provider.dart';
import 'package:vc_taskcontrol/src/providers/theme_provider.dart';
import 'package:vc_taskcontrol/src/services/connection_provider.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/storage/preferences/general_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String empresa;
  final String usuario;
  final String fechaHora;
  final bool isConnected;
  final String title_app;

  const CustomAppBar({
    super.key,
    required this.empresa,
    required this.usuario,
    required this.fechaHora,
    required this.isConnected,
    required this.title_app,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isConnected = Provider.of<ConnectionProvider>(context).isConnected;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AppBar(
      leading: ModalRoute.of(context)?.canPop == true ? BackButton() : null,
      title: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                empresa,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title_app,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$fechaHora\n$usuario',
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            themeProvider.currentTheme.brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          tooltip: 'Cambiar tema',
          onPressed: () {
            if (themeProvider.currentTheme.brightness == Brightness.dark) {
              themeProvider.setLightMode();
              GeneralPreferences.isDarkMode = false;
            } else {
              themeProvider.setDarkMode();
              GeneralPreferences.isDarkMode = true;
            }
          },
        ),
        // IconButton(
        //   icon: Icon(Icons.visibility_off), // O cualquier icono representativo
        //   tooltip: 'Ocultar columnas de producción',
        //   onPressed: () {
        //     final provider = Provider.of<DataProvider>(context, listen: false);
        //     provider.toggleProductionColumns(); // O alternar según estado
        //     // provider.toggleProductionColumns(true); // O alternar según estado
        //   },
        // ),
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Settings',
          onPressed: () {
            final location = GoRouterState.of(context).matchedLocation;
            if (location != '/settings') {
              context.push('/settings');
            }
          },
        ),

        Icon(
          isConnected ? Icons.wifi : Icons.wifi_off,
          color:
              isConnected ? const Color.fromARGB(255, 39, 201, 44) : Colors.red,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
