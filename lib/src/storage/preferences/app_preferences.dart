import 'base_preferences.dart';

class AppPreferences {
  // Claves para persistencia
  static const String projectKey = 'project';
  static const String sectionKey = 'section';
  static const String subsectionKey = 'subsection';
  static const String supervisorKey = 'supervisor';
  static const String operatorKey = 'operator';
  static const String estimatedQuantityKey = 'estimated_quantity';

  // Setters
  static Future<void> setProject(String value) async =>
      await BasePreferences.setString(projectKey, value);

  static Future<void> setSection(String value) async =>
      await BasePreferences.setString(sectionKey, value);

  static Future<void> setSubsection(String value) async =>
      await BasePreferences.setString(subsectionKey, value);

  static Future<void> setSupervisor(String value) async =>
      await BasePreferences.setString(supervisorKey, value);

  static Future<void> setOperator(String value) async =>
      await BasePreferences.setString(operatorKey, value);

  static Future<void> setEstimatedQuantity(String value) async =>
      await BasePreferences.setString(estimatedQuantityKey, value);

  // Getters
  static String? getProject() => BasePreferences.getString(projectKey);

  static String? getSection() => BasePreferences.getString(sectionKey);

  static String? getSubsection() => BasePreferences.getString(subsectionKey);

  static String? getSupervisor() => BasePreferences.getString(supervisorKey);

  static String? getOperator() => BasePreferences.getString(operatorKey);

  static String? getEstimatedQuantity() =>
      BasePreferences.getString(estimatedQuantityKey);

  // Limpieza rápida (opcional)
  static Future<void> clearAll() async {
    await BasePreferences.setString(projectKey, '');
    await BasePreferences.setString(sectionKey, '');
    await BasePreferences.setString(subsectionKey, '');
    await BasePreferences.setString(supervisorKey, '');
    await BasePreferences.setString(operatorKey, '');
    await BasePreferences.setString(estimatedQuantityKey, '');
  }
}
