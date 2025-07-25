import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:go_router/go_router.dart';
import 'package:vc_taskcontrol/src/settings/theme/app_theme.dart';
import 'package:vc_taskcontrol/src/storage/preferences/general_preferences.dart';

class CircularMenuWidget extends StatefulWidget {
  const CircularMenuWidget({Key? key}) : super(key: key);

  @override
  _CircularMenuWidgetState createState() => _CircularMenuWidgetState();
}

class _CircularMenuWidgetState extends State<CircularMenuWidget> {
  String _selectionLabel = 'Ningún';
  Color _selectionColor = AppColors.accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return CircularMenu(
      animationDuration: Duration(milliseconds: 600),
      alignment: Alignment.bottomCenter,
      toggleButtonColor: AppColors.primary,
      backgroundWidget: Center(
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: scheme.onSurface, fontSize: 24),
            children: <TextSpan>[
              TextSpan(
                text: _selectionLabel,
                style: TextStyle(
                  color: _selectionColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: ' opción seleccionada.'),
            ],
          ),
        ),
      ),
      items: [
        CircularMenuItem(
          icon: Icons.home,
          color: AppColors.primary,
          onTap: () {
            setState(() {
              _selectionColor = AppColors.primary;
              _selectionLabel = 'Inicio';
            });
          },
        ),

        CircularMenuItem(
          icon: Icons.barcode_reader,
          color: AppColors.secondary,
          onTap: () {
            setState(() {
              _selectionColor = AppColors.secondary;
              _selectionLabel = 'Production Time';
              context.push('/prodtime');
            });
          },
        ),
        CircularMenuItem(
          icon: Icons.search,
          color: AppColors.secondary,
          onTap: () {
            setState(() {
              _selectionColor = AppColors.secondary;
              _selectionLabel = 'Buscar';
            });
          },
        ),
        CircularMenuItem(
          icon: Icons.settings,
          color: AppColors.accent,
          badgeLabel: 'Settings',
          onTap: () {
            setState(() {
              _selectionColor = AppColors.accent;
              _selectionLabel = 'Ajustes';
              final location = GoRouterState.of(context).matchedLocation;
              if (location != '/settings') {
                GeneralPreferences.currentModule = 'Settings';
                context.push('/settings');
              }
            });
          },
        ),
        CircularMenuItem(
          icon: Icons.bluetooth, // Nuevo icono reemplazando a "chat"
          color: AppColors.success,
          onTap: () {
            setState(() {
              _selectionColor = AppColors.success;
              _selectionLabel = 'Bluetooth';
            });
          },
        ),
        CircularMenuItem(
          icon: Icons.monitor, // Nuevo icono para báscula
          color: AppColors.warning,
          onTap: () {
            setState(() {
              _selectionColor = AppColors.warning;
              _selectionLabel = 'Monitoring';
              context.push('/monitoring');
            });
          },
        ),
      ],
    );
  }
}
