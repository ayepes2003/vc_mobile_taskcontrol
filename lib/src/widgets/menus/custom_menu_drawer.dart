import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/settings/theme/app_theme.dart';

class CustomDrawerMenu extends StatelessWidget {
  const CustomDrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary, // Verde corporativo
                  AppColors.primary.withOpacity(0.8), // Variación suave
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage(
                    'assets/logo.png', // Asegúrate de que este archivo esté en pubspec.yaml
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Milestone Muebles S.A.S.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'ayepes2003@yahoo.es',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: theme.colorScheme.primary),
            title: Text(
              'Inicio',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: theme.colorScheme.secondary),
            title: Text(
              'Configuración',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: theme.colorScheme.secondary),
            title: Text(
              'Acerca de',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            onTap: () {
              Navigator.pop(context); // Cierra el Drawer

              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Información de la versión'),
                      content: const Text(
                        'Fecha de Version: 17/09/2025\n'
                        'Desarrollador: ayepes2003@yahoo.es\n'
                        'Versión: Parciales+Exportar JSON\n'
                        'Versión: 2.1.\n'
                        // 'Versión: 1.0.10'
                        'Branch:Feature/partial_report\n',
                      ),
                      actions: [
                        TextButton(
                          onPressed:
                              () => Navigator.pop(context), // Cierra el dialog
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
              );
            },
          ),

          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: Text(
              'Cerrar sesión',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
