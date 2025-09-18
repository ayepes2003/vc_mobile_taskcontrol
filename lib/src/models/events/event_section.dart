class Event {
  final int id;
  final String name;
  final String icon;
  final String color;
  final String? label; // <- Label corto para el botón
  final int? maxDurationMinutes;
  final bool blockInterface;

  Event({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.label,
    this.maxDurationMinutes,
    required this.blockInterface,
  });

  // Desde JSON (API)
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      label: json['label'], // <-- añadido aquí
      maxDurationMinutes:
          json['maxDurationMinutes'] is int
              ? json['maxDurationMinutes']
              : json['maxDurationMinutes'] == null
              ? null
              : int.tryParse(json['maxDurationMinutes'].toString()),
      blockInterface:
          json['blockInterface'] == 1 || json['blockInterface'] == true,
    );
  }

  // A JSON (API)
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'color': color,
    'label': label, // <-- añadido aquí
    'maxDurationMinutes': maxDurationMinutes,
    'blockInterface': blockInterface ? 1 : 0,
  };

  // Desde Map (SQLite/local)
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as int,
      name: map['name'] as String,
      icon: map['icon'] as String,
      color: map['color'] as String,
      label: map['label'], // <-- añadido aquí
      maxDurationMinutes:
          map['maxDurationMinutes'] is int
              ? map['maxDurationMinutes']
              : map['maxDurationMinutes'] == null
              ? null
              : int.tryParse(map['maxDurationMinutes'].toString()),
      blockInterface:
          map['blockInterface'] == 1 || map['blockInterface'] == true,
    );
  }

  // A Map (SQLite/local)
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'icon': icon,
    'color': color,
    'label': label, // <-- añadido aquí
    'maxDurationMinutes': maxDurationMinutes,
    'blockInterface': blockInterface ? 1 : 0,
  };
}
