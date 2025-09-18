import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/models/events/event_section.dart';
import 'package:vc_taskcontrol/src/providers/app/routercard/event_blocker_provider.dart';

class EventReportDialog extends StatefulWidget {
  final List<Event> events;

  const EventReportDialog({Key? key, required this.events}) : super(key: key);

  @override
  _EventReportDialogState createState() => _EventReportDialogState();
}

class _EventReportDialogState extends State<EventReportDialog> {
  Event? activeEvent;

  String getEventLabel(Event event) {
    switch (event.name) {
      case 'batch_run':
        return 'Batch';
      case 'machine_maintenance':
        return 'Mantenimiento';
      case 'lunch_break':
        return 'Almuerzo';
      case 'bathroom':
        return 'Baño';
      case 'shift_change':
        return 'Cambio Turno';
      case 'machine_stop':
        return 'Maquina';
      case 'material_shortage':
        return 'Falta Material';
      case 'cancel_event':
        return 'Cerrar';
      default:
        return event.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              activeEvent == null ? "Selecciona un evento" : "Evento activo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            widget.events.isNotEmpty
                ? Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 20,
                  children:
                      widget.events.map((event) {
                        bool isActive = activeEvent == event;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (activeEvent == null) {
                                  setState(() {
                                    activeEvent = event;
                                  });
                                  Provider.of<EventBlockerProvider>(
                                    context,
                                    listen: false,
                                  ).startEvent(event);
                                } else if (isActive) {
                                  Provider.of<EventBlockerProvider>(
                                    context,
                                    listen: false,
                                  ).finishEvent();
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Opacity(
                                opacity:
                                    (activeEvent == null || isActive) ? 1 : 0.3,
                                child: CircleAvatar(
                                  radius: 54,
                                  backgroundColor: Color(
                                    int.parse(
                                      event.color.replaceFirst('#', '0xff'),
                                    ),
                                  ),
                                  child: Icon(
                                    _getIconFromString(event.icon),
                                    color: Colors.white,
                                    size: 44,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 14),
                            Text(
                              event.label ?? getEventLabel(event),
                              style: TextStyle(
                                fontSize: isActive ? 19 : 16,
                                fontWeight:
                                    isActive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color: isActive ? Colors.red : null,
                              ),
                            ),
                            if (isActive)
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  "Activo",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                )
                : Center(child: Text("No hay eventos para mostrar")),
            if (activeEvent != null)
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.15),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning, color: Colors.red, size: 28),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'Para salir, toca nuevamente "${getEventLabel(activeEvent!)}"',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

IconData _getIconFromString(String iconName) {
  switch (iconName) {
    case 'accessibility_new':
      return Icons.accessibility_new;
    case 'stop':
      return Icons.stop;
    case 'construction':
      return Icons.construction;
    case 'restaurant':
      return Icons.restaurant;
    case 'wc':
      return Icons.wc;
    case 'remove_shopping_cart':
      return Icons.remove_shopping_cart;
    case 'close':
      return Icons.close;
    default:
      return Icons.help_outline;
  }
}
