import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/models/project.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/route_data_provider.dart';

class ProjectListWidget extends StatelessWidget {
  final List<Project> projects;
  final int? selectedProjectId;
  final ValueChanged<Project>? onSelected;

  const ProjectListWidget({
    Key? key,
    required this.projects,
    required this.selectedProjectId,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (projects.isEmpty) {
      return const Center(child: Text('No hay proyectos disponibles'));
    }
    final selectedId = context.watch<RouteDataProvider>().selectedProjectId;
    final onSelected = context.read<RouteDataProvider>().setSelectedProjectId;
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: projects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final project = projects[index];
        final isSelected = project.id == selectedProjectId;
        return Card(
          // CAMBIO: usamos el color primario con opacidad para seleccionado, y surface para no seleccionado
          color:
              isSelected
                  ? colorScheme.primary.withOpacity(0.13)
                  : colorScheme.surface,
          elevation: isSelected ? 6 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              // CAMBIO: borde naranja para seleccionado, gris/acento para no seleccionado
              color:
                  isSelected
                      ? colorScheme.primary
                      : colorScheme.secondary.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: ListTile(
            title: Text(
              project.projectName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                // CAMBIO: color adaptativo según el theme
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sección: ${project.sectionName}  |  Sub: ${project.subsectionName}',
                  style: TextStyle(color: colorScheme.secondary, fontSize: 16),
                ),
                Text(
                  'Código: ${project.codeProduction}',
                  style: TextStyle(
                    color: colorScheme.secondary.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Ubicación: ${project.location}',
                  style: TextStyle(color: colorScheme.secondary, fontSize: 16),
                ),
                Text(
                  'Cantidad estimada: ${project.estimatedQuantity}',
                  style: TextStyle(
                    color: colorScheme.secondary.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Del ${project.startDate} al ${project.endDate}',
                  style: TextStyle(
                    color: colorScheme.secondary.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            onTap: () {
              // onSelected != null ? () => onSelected!(project) : null,
            },
          ),
        );
      },
    );
  }
}
