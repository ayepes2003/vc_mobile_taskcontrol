import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/models/routescard/route_card_read.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/router_card_provider.dart';

class RouteCardTablet extends StatelessWidget {
  final List<Map<String, dynamic>> columns; // columnasTablet del provider
  final List<dynamic> rows; // Lista de RouteCardRead
  final int maxRows;

  const RouteCardTablet({
    Key? key,
    required this.columns,
    required this.rows,
    this.maxRows = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Limita la cantidad de filas a mostrar
    final rowsToShow = rows.take(maxRows).toList();
    final provider = Provider.of<RouteCardProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scroll horizontal (si la tabla es ancha)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 55,
            horizontalMargin: 5,
            border: TableBorder.all(
              color: Theme.of(context).colorScheme.outline,
              width: 0.5,
            ),
            // Usa WidgetStateProperty (Flutter 3.19+) para el color del encabezado
            headingRowColor: WidgetStateProperty.resolveWith(
              (states) =>
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            columns:
                columns
                    .where((c) => c['visible'] != false)
                    .map(
                      (column) => DataColumn(
                        label: Tooltip(
                          message: column['tooltip'] ?? '',
                          child: Row(
                            children: [
                              if (column['icono'] != null)
                                Icon(column['icono'], size: 16),
                              const SizedBox(width: 4),
                              Text(column['titulo']),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
            rows:
                rowsToShow.isEmpty
                    ? [
                      DataRow(
                        cells:
                            columns
                                .where((c) => c['visible'] != false)
                                .map(
                                  (column) => DataCell(
                                    SizedBox(
                                      width: column['ancho'],
                                      child: Text(
                                        column['key'] == columns.first['key']
                                            ? 'No recent records'
                                            : '',
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                        textAlign:
                                            column['align'] ?? TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ]
                    : rowsToShow.map((row) {
                      final isPartial =
                          row is RouteCardRead ? row.isPartial == true : false;
                      return DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>((
                          Set<MaterialState> states,
                        ) {
                          if (isPartial) {
                            return Colors.yellow.withOpacity(0.3);
                          }
                          return null;
                        }),
                        cells:
                            columns.where((c) => c['visible'] != false).map((
                              column,
                            ) {
                              final value =
                                  row is RouteCardRead && row is! Map
                                      ? provider.getCellValue(
                                        row,
                                        column['key'],
                                      )
                                      : row['key'] ?? '';
                              Color txtColor =
                                  column['colorTexto'] ?? Colors.black;
                              return DataCell(
                                SizedBox(
                                  width: column['ancho'],
                                  child: Text(
                                    value,
                                    textAlign:
                                        column['align'] ?? TextAlign.center,
                                    style: TextStyle(
                                      color: txtColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      );
                    }).toList(),
          ),
        ),
      ],
    );
  }
}
