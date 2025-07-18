import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassMenu extends StatelessWidget {
  const GlassMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo degradado corporativo
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0051A2), Color(0xFF00C6FB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // Contenedor glassmorphism con botones de menú
        Center(
          child: GlassmorphicContainer(
            width: 350,
            height: 350,
            borderRadius: 24,
            blur: 20,
            alignment: Alignment.center,
            border: 2,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
              stops: [0.1, 1],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.5),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuButton(
                  icon: Icons.home,
                  label: 'Inicio',
                  onTap: () {
                    // Navega a la ruta de inicio
                  },
                ),
                SizedBox(height: 24),
                MenuButton(
                  icon: Icons.settings,
                  label: 'Configuración',
                  onTap: () {
                    // Navega a configuración
                  },
                ),
                SizedBox(height: 24),
                MenuButton(
                  icon: Icons.info,
                  label: 'Acerca de',
                  onTap: () {
                    // Navega a acerca de
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.25),
        foregroundColor: Colors.blue[900],
        minimumSize: Size(200, 48),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      icon: Icon(icon, size: 28),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
