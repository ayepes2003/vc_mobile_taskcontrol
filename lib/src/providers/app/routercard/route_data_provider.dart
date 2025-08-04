import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/section.dart';
import 'package:vc_taskcontrol/src/storage/preferences/app_preferences.dart';

class RouteDataProvider extends ChangeNotifier {
  String? projectName;
  String? item;
  int? totalPieces;
  String? section;
  String? subsection;
  String? supervisor;
  String? operatorName;
  int? estimatedQuantity;
  int? realQuantity;
  String? shiftName;
  String? selectedHourRange;

  //Migración a la nueva propiedad centralcontent
  int? selectedSupervisorId;
  int? selectedOperatorId;
  int? selectedSectionId;
  int? selectedSubsectionId;
  int? selectedProjectId;
  String? selectedProjectName;
  Section? selectedSection;
  String? selectedSubsection;

  // MÉTODO PARA ACTUALIZAR TODO DESDE LA RUTA O UNA NUEVA BÚSQUEDA
  void setFromRoute({
    String? project,
    String? itemCode,
    int? totalPiece,
    String? section,
    String? subsection,
    String? supervisor,
    String? operatorName,
    int? estimatedQuantity,
    String? shiftName,
    String? selectedHourRange,
    // int? selectSectionId,
  }) {
    if (project != null) projectName = project;
    if (itemCode != null) item = itemCode;
    if (totalPiece != null) totalPieces = totalPiece;
    if (section != null) this.section = section;

    if (subsection != null) this.subsection = subsection;
    if (supervisor != null) this.supervisor = supervisor;
    if (operatorName != null) this.operatorName = operatorName;
    if (estimatedQuantity != null) this.estimatedQuantity = estimatedQuantity;
    if (shiftName != null) this.shiftName = shiftName;
    if (selectedHourRange != null) this.selectedHourRange = selectedHourRange;
    // if (selectSectionId != null) this.selectedSectionId = selectSectionId;
    notifyListeners();
  }

  // HIDRATAR DESDE PREFERENCIAS AL INICIAR APP
  void hydrateFromPrefs({
    required String? project,
    required String? section,
    required String? subsection,
    required String? supervisor,
    required String? operatorName,
    required int? estimatedQuantity,
    String? shiftName,
    String? selectedHourRange,
    int? selectedSupervisorId, // 👈 nuevo
    int? selectedSectionId, // 👈 nuevo
    int? selectedSubsectionId,
    int? selectedOperatorId, // 👈 nuevo
  }) {
    projectName = project;
    this.section = section;
    this.subsection = subsection;
    this.supervisor = supervisor;
    this.operatorName = operatorName;
    this.estimatedQuantity = estimatedQuantity;
    this.shiftName = shiftName;
    this.selectedHourRange = selectedHourRange;
    this.selectedSupervisorId = selectedSupervisorId;
    this.selectedOperatorId = selectedOperatorId;
    this.selectedSectionId = selectedSectionId;
    this.selectedSubsectionId = selectedSubsectionId;
    print(
      'hydrateFromPrefs: selectedSectionId=$selectedSectionId, selectedSupervisorId=$selectedSupervisorId',
    );
    notifyListeners();
  }

  void setSelectedSectionId(int? id) {
    selectedSectionId = id;
    notifyListeners();
  }

  void setSelectedSection(Section section) {
    selectedSection = section;
    selectedSectionId = section.id;
    // print('Antes: selectedSection=${selectedSection}');
    selectedSubsection = null; // 🔁 limpia automáticamente
    notifyListeners();
    // print('notifyListeners: selectedSubsection=${selectedSection}');
  }

  void setSection(String value) {
    section = value;
    // print('Antes: section=${section}');
    notifyListeners();
    // print('notifyListeners: section=${section}');
  }

  void setSubsection(String value) {
    subsection = value;
    // print('Antes: subsection=${selectedSection}');
    selectedSubsection = null; // 🔁 limpia automáticamente
    notifyListeners();
    // print('notifyListeners: subsection=${selectedSection}');
  }

  void setSelectedSubsectionId(int? id) {
    selectedSubsectionId = id;
    notifyListeners();
  }

  // void setSelectedSubsection(String subsection) {
  //   selectedSubsection = subsection;
  //   notifyListeners();
  // }

  void setSelectedSubsection(String name, {int? id}) {
    selectedSubsection = name;
    selectedSubsectionId = id;
    notifyListeners();
  }

  void setSupervisor(String value) {
    supervisor = value;
    // print('Antes: supervisor=${selectedSection}');
    notifyListeners();
    // print('notifyListeners: supervisor=${selectedSection}');
  }

  void setSelectedSupervisorId(int id) {
    selectedSupervisorId = id;
    // print('Antes: selectedSupervisorId=${selectedSection}');
    notifyListeners();
    // print('notifyListeners: selectedSupervisorId=${selectedSection}');
  }

  void setSelectedOperatorId(int id) {
    // 👈 Setter
    selectedOperatorId = id;
    // print('Antes: selectedOperatorId=${selectedSection}');
    notifyListeners();
    // print('notifyListeners: selectedOperatorId=${selectedSection}');
  }

  void setOperatorName(String value) {
    operatorName = value;
    // print('Antes: operatorName=${selectedSection}');
    notifyListeners();
    // print('notifyListeners: operatorName=${selectedSection}');
  }

  void setEstimatedQuantity(int value) {
    estimatedQuantity = value;
    notifyListeners();
  }

  void setRealQuantity(int value) {
    realQuantity = value;
    notifyListeners();
  }

  void setShiftName(String value) {
    shiftName = value;
    notifyListeners();
  }

  void setSelectedHourRange(String value) {
    selectedHourRange = value;
    notifyListeners();
  }

  // LIMPIAR DATOS DE SESIÓN—UTIL AL CERRAR O REINICIAR
  void clear() {
    projectName = null;
    item = null;
    totalPieces = null;
    section = null;
    subsection = null;
    supervisor = null;
    operatorName = null;
    estimatedQuantity = null;
    shiftName = null;
    selectedHourRange = null;
    notifyListeners();
  }

  // SETTERS INDIVIDUALES PARA FLUJOS PASO-A-PASO
  void setProject(String value) {
    projectName = value;
    notifyListeners();
  }

  void setSelectedProjectId(int id) {
    selectedProjectId = id;
    notifyListeners();
  }

  void setSelectedProjectName(String name) {
    selectedProjectName = name;
    notifyListeners();
  }
}
