import 'base_preferences.dart';

class AppPreferences {
  // Claves para persistencia
  static const String projectKey = 'project';
  static const String sectionKey = 'section';
  static const String subsectionKey = 'subsection';
  static const String supervisorKey = 'supervisor';
  static const String selectedHourRange = '00:00:01';
  static const String setShiftName = 'ShiftName';
  static const String operatorKey = 'operator';
  static const String estimatedQuantityKey = 'estimated_quantity';

  // Claves para identificadores
  static const String supervisorIdKey = 'supervisor_id';
  static const String sectionIdKey = 'section_id';
  static const String subsectionIdKey = 'subsection_id';
  static const String operatorIdKey = 'operator_id';
  // Setters

  static Future<void> setProject(String value) async =>
      await BasePreferences.setString(projectKey, value);

  static Future<void> setSupervisorId(int id) async =>
      await BasePreferences.setInt(supervisorIdKey, id);

  static Future<void> setSupervisor(String value) async =>
      await BasePreferences.setString(supervisorKey, value);

  static Future<void> setselectedHourRange(String value) async =>
      await BasePreferences.setString(selectedHourRange, value);

  static Future<void> setSectionId(int id) async =>
      await BasePreferences.setInt(sectionIdKey, id);

  static Future<void> setSection(String value) async =>
      await BasePreferences.setString(sectionKey, value);

  static Future<void> setSubsection(String value) async =>
      await BasePreferences.setString(subsectionKey, value);

  static Future<void> setOperator(String value) async =>
      await BasePreferences.setString(operatorKey, value);

  static Future<void> setEstimatedQuantity(String value) async =>
      await BasePreferences.setString(estimatedQuantityKey, value);

  // Setters para IDs (int)
  static Future<void> setSubsectionId(int id) async =>
      await BasePreferences.setInt(subsectionIdKey, id);

  static Future<void> setOperatorId(int id) async =>
      await BasePreferences.setInt(operatorIdKey, id);

  // Getters
  static String? getProject() => BasePreferences.getString(projectKey);

  static String? getSupervisor() => BasePreferences.getString(supervisorKey);
  static String? getselectedHourRange() =>
      BasePreferences.getString(selectedHourRange);
  static String? getSection() => BasePreferences.getString(sectionKey);
  static String? getSubsection() => BasePreferences.getString(subsectionKey);
  static String? getOperator() => BasePreferences.getString(operatorKey);

  static String? getEstimatedQuantity() =>
      BasePreferences.getString(estimatedQuantityKey);

  // Getters para IDs (int)
  static int? getSupervisorId() => BasePreferences.getInt(supervisorIdKey);
  static int? getSectionId() => BasePreferences.getInt(sectionIdKey);
  static int? getSubsectionId() => BasePreferences.getInt(subsectionIdKey);
  static int? getOperatorId() => BasePreferences.getInt(operatorIdKey);

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
