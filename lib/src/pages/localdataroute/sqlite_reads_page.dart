import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/router_card_provider.dart';
// import 'package:vc_taskcontrol/src/models/routescard/route_card_read.dart';
// import 'package:vc_taskcontrol/src/providers/router_card_provider.dart';

class SQLiteReadsPage extends StatefulWidget {
  const SQLiteReadsPage({Key? key}) : super(key: key);

  @override
  _SQLiteReadsPageState createState() => _SQLiteReadsPageState();
}

class _SQLiteReadsPageState extends State<SQLiteReadsPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReads();
  }

  Future<void> _loadReads() async {
    final provider = context.read<RouteCardProvider>();
    await provider.loadRecentReads();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reads = context.watch<RouteCardProvider>().recentReads;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local SQLite Reads'),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : reads.isEmpty
              ? const Center(child: Text('No reads stored locally'))
              : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: reads.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final read = reads[index];
                  return ListTile(
                    title: Text('Code: ${read.card?.codeProces ?? 'Unknown'}'),
                    subtitle: Text(
                      'Entered Quantity: ${read.enteredQuantity}\n'
                      'Read At: ${read.readAt.toLocal().toString()}\n'
                      'Difference: ${read.difference}',
                    ),
                    isThreeLine: true,
                    leading: const Icon(Icons.list_alt),
                  );
                },
              ),
    );
  }
}
