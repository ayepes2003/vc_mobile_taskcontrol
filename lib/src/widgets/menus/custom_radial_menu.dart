import 'package:flutter/material.dart';
import 'package:animated_radial_menu/animated_radial_menu.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vc_taskcontrol/src/pages/target/target_page.dart';
// Ajusta la ruta según tu estructura

class CustomRadialMenu extends StatelessWidget {
  const CustomRadialMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo personalizado (puedes cambiarlo por imagen o degradado)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.cyan.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        // Menú radial animado
        RadialMenu(
          children: [
            RadialButton(
              icon: const Icon(Icons.ac_unit),
              buttonColor: Colors.teal,
              onPress: () => Get.to(() => const TargetPage()),
            ),
            RadialButton(
              icon: const Icon(Icons.camera_alt),
              buttonColor: Colors.green,
              onPress: () => Get.to(() => const TargetPage()),
            ),
            RadialButton(
              icon: const Icon(Icons.map),
              buttonColor: Colors.orange,
              onPress: () => Get.to(() => const TargetPage()),
            ),
            RadialButton(
              icon: const Icon(Icons.access_alarm),
              buttonColor: Colors.indigo,
              onPress: () => Get.to(() => const TargetPage()),
            ),
            RadialButton(
              icon: const Icon(Icons.watch),
              buttonColor: Colors.pink,
              onPress: () => Get.to(() => const TargetPage()),
            ),
            RadialButton(
              icon: const Icon(Icons.settings),
              buttonColor: Colors.blue,
              onPress: () => Get.to(() => const TargetPage()),
            ),
            RadialButton(
              icon: const Icon(Icons.mail_outline),
              buttonColor: Colors.yellow,
              onPress: () => Get.to(() => const TargetPage()),
            ),
            RadialButton(
              icon: const Icon(Icons.logout),
              buttonColor: Colors.red,
              onPress: () => Get.to(() => const TargetPage()),
            ),
          ],
        ),
      ],
    );
  }
}
