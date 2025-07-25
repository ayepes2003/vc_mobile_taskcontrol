import 'package:vc_taskcontrol/src/models/routescard/route_card.dart';

class RouteCardRead {
  final RouteCard card; // Model from loaded CSV data
  final int enteredQuantity;
  final DateTime readAt;

  RouteCardRead({
    required this.card,
    required this.enteredQuantity,
    required this.readAt,
  });

  int get difference {
    final diff = enteredQuantity - (int.tryParse(card.totalPiece) ?? 0);
    // print(
    //   'DIF [${card.codeProces}]: $enteredQuantity - ${card.totalPiece} = $diff',
    // );
    return diff;
  }

  // int get difference => enteredQuantity - (int.tryParse(card.quantity) ?? 0);

  // String get status =>
  //     enteredQuantity == (int.tryParse(card.quantity) ?? 0)
  //         ? 'Terminated'
  //         : 'Read';
  String get status {
    if (enteredQuantity == null) return 'Pending';
    if (enteredQuantity == (int.tryParse(card.quantity) ?? 0))
      return 'Terminated';
    return 'Read';
  }
}
