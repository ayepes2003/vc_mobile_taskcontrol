import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/events/event_section.dart';

class EventBlockerProvider with ChangeNotifier {
  Event? _activeEvent;

  Event? get activeEvent => _activeEvent;

  void startEvent(Event event) {
    _activeEvent = event;
    notifyListeners();
  }

  void finishEvent() {
    _activeEvent = null;
    notifyListeners();
  }

  bool get isBlocking => _activeEvent != null;
}
