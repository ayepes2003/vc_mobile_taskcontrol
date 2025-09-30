// version: 1.1.0+2  # Nueva funcionalidad
// version: 1.0.1+3  # Solo corrección de bugs
// version: 2.0.0+4  # Cambio mayor (breaking changes)
//'2.1.0'  to '2.2.0' y buildNumber=2
class AppVersion {
  static const String version = '2.2.0'; // ↑ de 2.1.0 a 2.2.0
  static const int buildNumber = 2; // ↑ de 1 a 2
  static const String releaseDate = '30/09/2025';
  static const String developer = 'ayepes2003@yahoo.es';
  static const String appName = 'Láminas+Reporte Corte';
  static const String branch = 'feature/partial_report';
  static const String changes = 'Nuevo: Reporte láminas Corte ';
  static String get fullVersion => '$version+$buildNumber';
  static String get versionTitle => '$appName v$version';
}

  // static const String releaseDate = '17/09/2024';
  // static const String developer = 'ayepes2003@yahoo.es';
  // static const String appName = 'Parciales+Exportar JSON';
  // static const String branch = 'feature/partial_report';
  // static const String changes = 'Exportación de reportes parciales a JSON';