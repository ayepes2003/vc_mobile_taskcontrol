import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:go_router/go_router.dart';
import 'package:vc_taskcontrol/src/settings/theme/app_theme.dart';
import 'package:vc_taskcontrol/src/storage/preferences/general_preferences.dart';

class CircularStartMenuWidget extends StatefulWidget {
  const CircularStartMenuWidget({Key? key}) : super(key: key);

  @override
  _CircularStartMenuWidgetState createState() =>
      _CircularStartMenuWidgetState();
}

class _CircularStartMenuWidgetState extends State<CircularStartMenuWidget> {
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
              const TextSpan(text: ' opción seleccionada. ajuste Aplicación: '),
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
              _selectionLabel = 'Start Page';
            });
          },
        ),
        CircularMenuItem(
          icon: Icons.list,
          color: AppColors.accent,
          badgeLabel: 'Loading Card Lists',
          onTap: () {
            setState(() {
              _selectionColor = AppColors.accent;
              _selectionLabel = 'Loading Card Lists';
              final location = GoRouterState.of(context).matchedLocation;
              if (location != '/settingsApp') {
                GeneralPreferences.currentModule = 'settingsApp';
                context.push('/settingsApp');
              }
            });
          },
        ),
        CircularMenuItem(
          icon: Icons.search,
          color: AppColors.secondary,
          onTap: () {
            setState(() {
              _selectionColor = AppColors.secondary;
              _selectionLabel = 'Buscar Registros';
            });
          },
        ),

        CircularMenuItem(
          icon: Icons.bluetooth,
          color: AppColors.success,
          onTap: () {
            setState(() {
              _selectionColor = AppColors.success;
              _selectionLabel = 'Bluetooth';
            });
          },
        ),
        CircularMenuItem(
          icon: Icons.qr_code_2_sharp,
          color: AppColors.primary,
          onTap: () {
            setState(() {
              _selectionColor = AppColors.success;
              _selectionLabel = 'Test Barcode';
              final location = GoRouterState.of(context).matchedLocation;
              if (location != '/scannertest') {
                GeneralPreferences.currentModule = 'scannertest';
                context.push('/scannertest');
              }
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
