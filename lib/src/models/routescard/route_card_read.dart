import 'package:vc_taskcontrol/src/models/routescard/route_card.dart';

class RouteCardRead {
  final RouteCard? card; // Modelo ruta
  final int enteredQuantity;
  final DateTime readAt;
  final int? difference; // Diferencia opcional pasada desde DB
  final String? status;
  final String? deviceId;
  final int? syncAttempts;

  RouteCardRead({
    this.card,
    required this.enteredQuantity,
    required this.readAt,
    this.difference,
    this.status,
    this.deviceId,
    this.syncAttempts,
  });

  // Si difference no viene (null), se calcula; si viene, se usa directamente
  int get effectiveDifference {
    if (difference != null) return difference!;
    if (card == null) return 0;
    return enteredQuantity - (int.tryParse(card!.totalPiece) ?? 0);
  }

  // Status como getter manteniendo acceso
  // Si tienes status en base, se usa; sino lo calculamos simple:
  String get effectiveStatus {
    if (status != null) return status!;
    if (card == null) return 'Pending';
    if (enteredQuantity == (int.tryParse(card!.quantity) ?? 0))
      return 'Terminated';
    return 'Read';
  }
}
