import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/pos_config.dart'; // <-- Configuración de columnas dinámicas
import '../providers/table_provider.dart';

class PosTable extends StatelessWidget {
  const PosTable({super.key});

  Color _getRowColor(Map<String, dynamic> item) {
    // Busca la primera columna con rowColorBuilder definido
    for (final column in posTableColumns) {
      if (column.rowColorBuilder != null) {
        final color = column.rowColorBuilder!(item);
        // ignore: unnecessary_null_comparison
        if (color != null) return color;
      }
    }
    return Colors.transparent; // Fallback seguro
  }

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<TableProvider>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.65,
          ),
          child: DataTable(
            columnSpacing: 20,
            dataRowMinHeight: 40,
            dataRowMaxHeight: 60,
            columns:
                posTableColumns
                    .map((column) => DataColumn(label: Text(column.title)))
                    .toList(),
            rows:
                tableProvider.items.reversed
                    .map(
                      (item) => DataRow(
                        color: WidgetStateProperty.all(_getRowColor(item)),
                        cells:
                            posTableColumns
                                .map(
                                  (column) => DataCell(
                                    Text(
                                      column.valueBuilder(item).toString(),
                                      style: column.textStyleBuilder?.call(
                                        item,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}
