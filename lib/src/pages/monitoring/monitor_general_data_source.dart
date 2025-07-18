import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MonitorGeneralDataSource extends DataGridSource {
  final List<Map<String, dynamic>> dataRows;
  final List<Map<String, dynamic>> columns;

  MonitorGeneralDataSource({required this.dataRows, required this.columns});

  late final List<DataGridRow> _rows =
      dataRows
          .map(
            (row) => DataGridRow(
              cells:
                  columns
                      .where((col) => col['hidden'] != true)
                      .map(
                        (col) => DataGridCell(
                          columnName: col['id'],
                          value: row[col['id']],
                        ),
                      )
                      .toList(),
            ),
          )
          .toList();

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((cell) {
            if (cell.columnName == 'project') {
              return Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  cell.value?.toString() ?? '',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }
            final cellData = cell.value as Map<String, dynamic>? ?? {};
            final colorHex = cellData['color'] ?? '#EEEEEE';
            final stateText = cellData['state']?.toString().toUpperCase() ?? '';
            return Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _hexToColor(colorHex),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                stateText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          }).toList(),
    );
  }

  // Conversor de hexadecimal a Color
  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex'; // Añade opacidad si falta
    return Color(int.parse(hex, radix: 16));
  }
}
