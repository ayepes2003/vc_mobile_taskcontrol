import 'package:flutter/material.dart';

class SelectionSummaryWidget extends StatelessWidget {
  final String supervisor;
  final String project;
  final String operatorName;
  final String section;
  final String subsection;

  const SelectionSummaryWidget({
    Key? key,
    required this.supervisor,
    required this.project,
    required this.operatorName,
    required this.section,
    required this.subsection,
  }) : super(key: key);

  Widget _buildInfoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, bottom: 4.0),
      child: Text(
        "$label: $value",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildInfoText("Supervisor", supervisor),
                _buildInfoText("Operario", operatorName),
              ],
            ),
            Row(
              children: [
                _buildInfoText("Sección", section),
                _buildInfoText("Subsección", subsection),
              ],
            ),
            // Si quieres agregar el proyecto, puedes ponerlo en una tercera fila:
            // Row(
            //   children: [
            //     _buildInfoText("Proyecto", project),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
