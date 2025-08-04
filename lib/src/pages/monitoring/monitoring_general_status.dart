import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:is_tv/is_tv.dart';

import 'package:vc_taskcontrol/src/pages/monitoring/monitor_general_data_source.dart';
import 'package:vc_taskcontrol/src/services/connection_provider.dart';
import 'package:vc_taskcontrol/src/widgets/custom_app_bar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/mock_data_provider.dart';

class MonitoringGeneralStatusPage extends StatelessWidget {
  const MonitoringGeneralStatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isConnected = Provider.of<ConnectionProvider>(context).isConnected;

    return Scaffold(
      appBar: CustomAppBar(
        empresa: 'Milestone Muebles SAS',
        usuario: 'Usuario: ayepes2003@yahoo.es',
        fechaHora: '26/03/2025 20:00',
        isConnected: isConnected,
        title_app: 'Production Time Control(HorApp)',
      ),
      body: Consumer<MockDataProvider>(
        builder: (context, dataProvider, child) {
          // Muestra un loader si aún no hay datos
          if (dataProvider.columns.isEmpty || dataProvider.rows.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final dataSource = MonitorGeneralDataSource(
            dataRows: dataProvider.rows,
            columns: dataProvider.columns,
          );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SfDataGrid(
              isScrollbarAlwaysShown: true,
              source: dataSource,
              columns:
                  dataProvider.columns
                      .where((col) => col['hidden'] != true)
                      .map(
                        (col) => GridColumn(
                          columnName: col['id'],
                          width:
                              (col['width'] as num?)?.toDouble() ??
                              160.0, // Usa el ancho definido o un valor por defecto
                          columnWidthMode: ColumnWidthMode.none,
                          label: Container(
                            margin: const EdgeInsets.all(6),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              // color: Colors.indigo[100],
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text(
                              col['title'] ?? col['id'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.indigo,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),

              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              // columnWidthMode: ColumnWidthMode.fill,
              columnWidthMode: ColumnWidthMode.none,
              // defaultColumnWidth: 300,
            ),
          );
        },
      ),
    );
  }
}
