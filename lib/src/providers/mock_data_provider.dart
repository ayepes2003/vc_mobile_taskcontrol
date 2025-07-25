import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vc_taskcontrol/src/models/operator.dart';
import 'package:vc_taskcontrol/src/models/project.dart';
import 'package:vc_taskcontrol/src/models/section.dart';
import 'package:vc_taskcontrol/src/models/shift/hour_range_response_model.dart';
import 'package:vc_taskcontrol/src/models/shift/shift_model.dart';
import 'package:vc_taskcontrol/src/models/stepconfig.dart';
import 'package:vc_taskcontrol/src/models/supervisor.dart';

class MockDataProvider extends ChangeNotifier {
  List<Project> projects = [];
  List<Section> sections = [];
  List<Supervisor> supervisors = [];
  List<Operator> operators = [];
  List<StepConfig> steps = [];
  List<Map<String, dynamic>> columns = [];
  List<Map<String, dynamic>> rows = [];
  List<String> hourRanges = [];
  ShiftModel? currentShift;
  bool showProduction = true; // Puedes controlar este estado desde tu UI

  void loadHourRangesFromMock() {
    const String mockResponse = '''{
      "shift": {
        "name": "Turno 1",
        "start_time": "06:00:00",
        "end_time": "13:59:59"
      },
      "hour_ranges": [
        "06:00 - 07:00",
        "07:00 - 08:00",
        "08:00 - 09:00"
      ]
    }''';

    final Map<String, dynamic> data = json.decode(mockResponse);
    final model = HourRangeResponseModel.fromJson(data);
    hourRanges = model.hourRanges;
    currentShift = model.shift;
    notifyListeners();
  }

  void loadColumnsFromJson() {
    const String columnsJson = '''
   [
    { "id": "project", "title": "PROYECTO", "width": 230, "hidden": false },
    { "id": "shipping_date", "title": "DESPACHO", "width": 145, "hidden": false },
    { "id": "project_design", "title": "D.PROYECTOS", "width": 160, "hidden": false },
    { "id": "planner1", "title": "PLANNER_1", "width": 160, "hidden": false },
    { "id": "innovation", "title": "INNOVACION", "width": 160, "hidden": false },
    { "id": "planner", "title": "PLANNER", "width": 160, "hidden": false },
    { "id": "production_admin", "title": "ADMONPROD", "width": 160, "hidden": false },
    { "id": "cutting", "title": "CORTE", "width": 120, "hidden": false },
    { "id": "edgebanding", "title": "ENCHAPE", "width": 120, "hidden": false },
    { "id": "drilling", "title": "PERFORACION", "width": 130, "hidden": false },
    { "id": "preparation", "title": "ALISTAMIENTO", "width": 140, "hidden": false },
    { "id": "painting", "title": "PINTURA", "width": 120, "hidden": false },
    { "id": "packing", "title": "EMPAQUE", "width": 120, "hidden": false },
    { "id": "dispatch", "title": "DESPACHO", "width": 140, "hidden": false },
    { "id": "goal", "title": "META", "width": 100, "hidden": false }
  ]


  ''';

    final List<dynamic> columnsList = json.decode(columnsJson);
    columns = columnsList.cast<Map<String, dynamic>>();
    notifyListeners();
  }

  void loadRowsFromJson() {
    const String rowsJson = '''
    [
      {
        "project": "Project 1 (#1976)",
        "shipping_date": { "state": "2025-08-25", "color": "#4CAF50" },
        "project_design": { "state": "complete", "color": "#4CAF50" },
        "planner1": { "state": "in_progress", "color": "#FFC107" },
        "innovation": { "state": "pending", "color": "#F44336" },
        "planner": { "state": "complete", "color": "#4CAF50" },
        "production_admin": { "state": "in_progress", "color": "#FFC107" },
        "cutting": { "state": "complete", "color": "#4CAF50" },
        "edgebanding": { "state": "in_progress", "color": "#FFC107" },
        "drilling": { "state": "pending", "color": "#F44336" },
        "preparation": { "state": "complete", "color": "#4CAF50" },
        "painting": { "state": "in_progress", "color": "#FFC107" },
        "packing": { "state": "pending", "color": "#F44336" },
        "dispatch": { "state": "complete", "color": "#4CAF50" },
        "goal": { "state": "terminado", "color": "#607D8B" }
      },
      {
        "project": "Project 2 (#1976)",
        "shipping_date": { "state": "2025-08-26", "color": "#4CAF50" },
        "project_design": { "state": "in_progress", "color": "#FFC107" },
        "planner1": { "state": "pending", "color": "#F44336" },
        "innovation": { "state": "complete", "color": "#4CAF50" },
        "planner": { "state": "in_progress", "color": "#FFC107" },
        "production_admin": { "state": "pending", "color": "#F44336" },
        "cutting": { "state": "in_progress", "color": "#FFC107" },
        "edgebanding": { "state": "pending", "color": "#F44336" },
        "drilling": { "state": "complete", "color": "#4CAF50" },
        "preparation": { "state": "in_progress", "color": "#FFC107" },
        "painting": { "state": "pending", "color": "#F44336" },
        "packing": { "state": "complete", "color": "#4CAF50" },
        "dispatch": { "state": "in_progress", "color": "#FFC107" },
        "goal": { "state": "terminado", "color": "#607D8B" }
      },
      {
        "project": "Project 3 (#1976)",
        "shipping_date": { "state": "2025-08-27", "color": "#2196F3" },
        "project_design": { "state": "pending", "color": "#F44336" },
        "planner1": { "state": "complete", "color": "#4CAF50" },
        "innovation": { "state": "in_progress", "color": "#FFC107" },
        "planner": { "state": "pending", "color": "#F44336" },
        "production_admin": { "state": "complete", "color": "#4CAF50" },
        "cutting": { "state": "pending", "color": "#F44336" },
        "edgebanding": { "state": "complete", "color": "#4CAF50" },
        "drilling": { "state": "in_progress", "color": "#FFC107" },
        "preparation": { "state": "pending", "color": "#F44336" },
        "painting": { "state": "complete", "color": "#4CAF50" },
        "packing": { "state": "in_progress", "color": "#FFC107" },
        "dispatch": { "state": "pending", "color": "#F44336" },
        "goal": { "state": "terminado", "color": "#607D8B" }
      },
      {
        "project": "Project 4",
        "shipping_date": { "state": "2025-08-28", "color": "#4CAF50" },
        "project_design": { "state": "complete", "color": "#4CAF50" },
        "planner1": { "state": "in_progress", "color": "#FFC107" },
        "innovation": { "state": "pending", "color": "#F44336" },
        "planner": { "state": "complete", "color": "#4CAF50" },
        "production_admin": { "state": "in_progress", "color": "#FFC107" },
        "cutting": { "state": "complete", "color": "#4CAF50" },
        "edgebanding": { "state": "in_progress", "color": "#FFC107" },
        "drilling": { "state": "pending", "color": "#F44336" },
        "preparation": { "state": "complete", "color": "#4CAF50" },
        "painting": { "state": "in_progress", "color": "#FFC107" },
        "packing": { "state": "pending", "color": "#F44336" },
        "dispatch": { "state": "complete", "color": "#4CAF50" },
        "goal": { "state": "terminado", "color": "#607D8B" }
      },
      {
        "project": "Project 5",
        "shipping_date": { "state": "2025-08-29", "color": "#2196F3" },
        "project_design": { "state": "in_progress", "color": "#FFC107" },
        "planner1": { "state": "pending", "color": "#F44336" },
        "innovation": { "state": "complete", "color": "#4CAF50" },
        "planner": { "state": "in_progress", "color": "#FFC107" },
        "production_admin": { "state": "pending", "color": "#F44336" },
        "cutting": { "state": "in_progress", "color": "#FFC107" },
        "edgebanding": { "state": "pending", "color": "#F44336" },
        "drilling": { "state": "complete", "color": "#4CAF50" },
        "preparation": { "state": "in_progress", "color": "#FFC107" },
        "painting": { "state": "pending", "color": "#F44336" },
        "packing": { "state": "complete", "color": "#4CAF50" },
        "dispatch": { "state": "in_progress", "color": "#FFC107" },
        "goal": { "state": "terminado", "color": "#607D8B" }
      },
        {
    "project": "Project 6 (#1976)",
    "shipping_date": { "state": "2025-09-01", "color": "#2196F3" },
    "project_design": { "state": "complete", "color": "#4CAF50" },
    "planner1": { "state": "complete", "color": "#4CAF50" },
    "innovation": { "state": "complete", "color": "#4CAF50" },
    "planner": { "state": "complete", "color": "#4CAF50" },
    "production_admin": { "state": "complete", "color": "#4CAF50" },
    "cutting": { "state": "complete", "color": "#4CAF50" },
    "edgebanding": { "state": "complete", "color": "#4CAF50" },
    "drilling": { "state": "complete", "color": "#4CAF50" },
    "preparation": { "state": "complete", "color": "#4CAF50" },
    "painting": { "state": "complete", "color": "#4CAF50" },
    "packing": { "state": "complete", "color": "#4CAF50" },
    "dispatch": { "state": "complete", "color": "#4CAF50" },
    "goal": { "state": "terminado", "color": "#607D8B" }
  },
  {
    "project": "Project 7 (#1976)",
    "shipping_date": { "state": "2025-09-02", "color": "#2196F3" },
    "project_design": { "state": "in_progress", "color": "#FFC107" },
    "planner1": { "state": "complete", "color": "#4CAF50" },
    "innovation": { "state": "complete", "color": "#4CAF50" },
    "planner": { "state": "complete", "color": "#4CAF50" },
    "production_admin": { "state": "complete", "color": "#4CAF50" },
    "cutting": { "state": "complete", "color": "#4CAF50" },
    "edgebanding": { "state": "complete", "color": "#4CAF50" },
    "drilling": { "state": "complete", "color": "#4CAF50" },
    "preparation": { "state": "complete", "color": "#4CAF50" },
    "painting": { "state": "complete", "color": "#4CAF50" },
    "packing": { "state": "complete", "color": "#4CAF50" },
    "dispatch": { "state": "complete", "color": "#4CAF50" },
    "goal": {}
  },
  {
    "project": "Project 8 (#1976)",
    "shipping_date": { "state": "2025-09-03", "color": "#2196F3" },
    "project_design": { "state": "complete", "color": "#4CAF50" },
    "planner1": { "state": "in_progress", "color": "#FFC107" },
    "innovation": { "state": "complete", "color": "#4CAF50" },
    "planner": { "state": "complete", "color": "#4CAF50" },
    "production_admin": { "state": "complete", "color": "#4CAF50" },
    "cutting": { "state": "complete", "color": "#4CAF50" },
    "edgebanding": { "state": "complete", "color": "#4CAF50" },
    "drilling": { "state": "complete", "color": "#4CAF50" },
    "preparation": { "state": "complete", "color": "#4CAF50" },
    "painting": { "state": "complete", "color": "#4CAF50" },
    "packing": { "state": "complete", "color": "#4CAF50" },
    "dispatch": { "state": "complete", "color": "#4CAF50" },
    "goal": {}
  },
  {
    "project": "Project 9 (#1976)",
    "shipping_date": { "state": "2025-09-04", "color": "#2196F3" },
    "project_design": { "state": "complete", "color": "#4CAF50" },
    "planner1": { "state": "complete", "color": "#4CAF50" },
    "innovation": { "state": "pending", "color": "#F44336" },
    "planner": { "state": "complete", "color": "#4CAF50" },
    "production_admin": { "state": "complete", "color": "#4CAF50" },
    "cutting": { "state": "complete", "color": "#4CAF50" },
    "edgebanding": { "state": "complete", "color": "#4CAF50" },
    "drilling": { "state": "complete", "color": "#4CAF50" },
    "preparation": { "state": "complete", "color": "#4CAF50" },
    "painting": { "state": "complete", "color": "#4CAF50" },
    "packing": { "state": "complete", "color": "#4CAF50" },
    "dispatch": { "state": "complete", "color": "#4CAF50" },
    "goal": {}
  },
  {
    "project": "Project 10 (#1976)",
    "shipping_date": { "state": "2025-09-05", "color": "#2196F3" },
    "project_design": { "state": "complete", "color": "#4CAF50" },
    "planner1": { "state": "complete", "color": "#4CAF50" },
    "innovation": { "state": "complete", "color": "#4CAF50" },
    "planner": { "state": "complete", "color": "#4CAF50" },
    "production_admin": { "state": "complete", "color": "#4CAF50" },
    "cutting": { "state": "complete", "color": "#4CAF50" },
    "edgebanding": { "state": "complete", "color": "#4CAF50" },
    "drilling": { "state": "complete", "color": "#4CAF50" },
    "preparation": { "state": "complete", "color": "#4CAF50" },
    "painting": { "state": "complete", "color": "#4CAF50" },
    "packing": { "state": "complete", "color": "#4CAF50" },
    "dispatch": { "state": "complete", "color": "#4CAF50" },
    "goal": { "state": "terminado", "color": "#607D8B" }
  },
  
  {
    "project": "Project 11 (#1976)",
    "shipping_date": { "state": "2025-09-05", "color": "#2196F3" },
    "project_design": { "state": "complete", "color": "#4CAF50" },
    "planner1": { "state": "complete", "color": "#4CAF50" },
    "innovation": { "state": "complete", "color": "#4CAF50" },
    "planner": { "state": "complete", "color": "#4CAF50" },
    "production_admin": { "state": "complete", "color": "#4CAF50" },
    "cutting": { "state": "complete", "color": "#4CAF50" },
    "edgebanding": { "state": "complete", "color": "#4CAF50" },
    "drilling": { "state": "complete", "color": "#4CAF50" },
    "preparation": { "state": "complete", "color": "#4CAF50" },
    "painting": { "state": "complete", "color": "#4CAF50" },
    "packing": { "state": "complete", "color": "#4CAF50" },
    "dispatch": { "state": "complete", "color": "#4CAF50" },
    "goal": { "state": "terminado", "color": "#607D8B" }
  }

    ]

  ''';

    final List<dynamic> rowsList = json.decode(rowsJson);
    rows = rowsList.cast<Map<String, dynamic>>();
    notifyListeners();
  }

  Future<void> loadMonitorData() async {
    loadColumnsFromJson();
    loadRowsFromJson();
  }

  void loadStepsFromJson() {
    const String stepsJson = '''
  {
    "status": "success",
    "data": [
      {
        "id": 1,
        "name": "supervisor",
        "label": "Supervisores",
        "step_id": 1,
        "icon": "person",
        "selectedColor": "#4CAF50",
        "selectedTextColor": "#FFFFFF"
      },
      {
        "id": 2,
        "name": "hour_range",
        "label": "Hora - Hora",
        "step_id": 2,
        "icon": "access_time",
        "selectedColor": "#FFA726",
        "selectedTextColor": "#FFFFFF"
      },
      {
        "id": 3,
        "name": "section",
        "label": "Sección",
        "step_id": 3,
        "icon": "category",
        "selectedColor": "#607D8B",
        "selectedTextColor": "#FFFFFF"
      },
      {
        "id": 4,
        "name": "subsection",
        "label": "Centros Trabajo",
        "step_id": 4,
        "icon": "view_list",
        "selectedColor": "#9C27B0",
        "selectedTextColor": "#FFFFFF"
      },
      {
        "id": 5,
        "name": "operator",
        "label": "Operario",
        "step_id": 5,
        "icon": "people",
        "selectedColor": "#FF9800",
        "selectedTextColor": "#FFFFFF"
      },
      {
        "id": 6,
        "name": "pieces",
        "label": "Piezas",
        "step_id": 6,
        "icon": "barcode",
        "selectedColor": "#009688",
        "selectedTextColor": "#FFFFFF"
      }
    ]
  }
  ''';
    /*
,
      {
        "id": 7,
        "name": "quantity",
        "label": "Cantidad",
        "step_id": 7,
        "icon": "calculate",
        "selectedColor": "#009688",
        "selectedTextColor": "#FFFFFF"
      }
*/
    final Map<String, dynamic> data = json.decode(stepsJson);
    final List<dynamic> stepList = data['data'];
    steps = stepList.map((item) => StepConfig.fromJson(item)).toList();
    notifyListeners();
  }

  void loadSupervisorsFromJson() {
    const String supervisorsJson = '''
    [
      {"id": 1, "name": "Harold", "document_num": "11111111", "turno": "Turno_1"},
      {"id": 2, "name": "Jorge", "document_num": "222222", "turno": "Turno_2"},
      {"id": 3, "name": "Supervisor3", "document_num": "4444", "turno": "Turno_3"},
      {"id": 4, "name": "Supervisor4", "document_num": "222222", "turno": "Turno_1"},
       {"id": 5, "name": "Supervisor5", "document_num": "4444", "turno": "Turno_3"}
    ]
    ''';

    final List<dynamic> data = json.decode(supervisorsJson);
    supervisors = data.map((item) => Supervisor.fromJson(item)).toList();
    notifyListeners();
  }

  void loadProjectsFromJson() {
    const String projectsJson = '''
    {
      "status": "success",
      "data": [
        {
          "id": 1,
          "project_name": "Proyecto Alpha",
          "location": "Planta 1",
          "code_production": "1976",
          "estimated_quantity": 1139,
          "section_name": "CORTE",
          "subsection_name": "ALL",
          "start_date": "2025-06-01",
          "end_date": "2025-12-31"
        },
        {
          "id": 2,
          "project_name": "Proyecto Beta",
          "location": "Planta 2",
          "code_production": "1234",
          "estimated_quantity": 2000,
          "section_name": "ENSAMBLE",
          "subsection_name": "A1",
          "start_date": "2025-07-01",
          "end_date": "2025-12-31"
        },
        {
          "id": 3,
          "project_name": "Riverside 2do Despacho",
          "location": "Planta 1",
          "code_production": "1976",
          "estimated_quantity": 1139,
          "section_name": "CORTE",
          "subsection_name": "ALL",
          "start_date": "2025-06-01",
          "end_date": "2025-12-31"
        }
      ]
    }
    ''';

    final Map<String, dynamic> data = json.decode(projectsJson);
    final List<dynamic> projectList = data['data'];
    projects = projectList.map((item) => Project.fromJson(item)).toList();
    notifyListeners();
  }

  void loadSectionsFromJson() {
    const String sectionsJson = '''
    {
      "status": "success",
      "data": [
        {
          "id": 1,
          "section_name": "CORTE",
          "sub_section_name": "CORTE",
          "verb_operation": "CORTADAS",
          "measurements": ["LAMINAS"],
          "subsections": ["SECC1", "SECC2"]
        },
        {
          "id": 2,
          "section_name": "ENCHAPE",
          "sub_section_name": "ENCHAPE",
          "verb_operation": "ENCHAPADAS",
          "measurements": ["PIEZAS"],
          "subsections": ["KALL", "CURVOS", "STREAM"]
        }
        ,
        {
          "id": 3,
          "section_name": "PERFORACION",
          "sub_section_name": "ENCHAPE",
          "verb_operation": "PERFORADAS",
          "measurements": ["PIEZAS"],
          "subsections": ["KALL", "CURVOS", "STREAM"]
        }
      ]
    }
    ''';

    final Map<String, dynamic> data = json.decode(sectionsJson);
    final List<dynamic> sectionList = data['data'];
    sections = sectionList.map((item) => Section.fromJson(item)).toList();
    notifyListeners();
  }

  void loadOperatorsFromJson() {
    const String operatorsJson = '''
    [
      {
        "id": 1,
        "name": "Operario1",
        "document_num": "11111111",
        "shift": "Turno_1",
        "sectionId": 1,
        "sectionName": "Sección A",
        "subsectionId": 1,
        "subsectionName": "Subsección X"
      },
      {
        "id": 2,
        "name": "Operario2",
        "document_num": "222222",
        "shift": "Turno_2",
        "sectionId": 2,
        "sectionName": "Sección B",
        "subsectionId": 2,
        "subsectionName": "Subsección Y"
      },
      {
        "id": 3,
        "name": "Operario3",
        "document_num": "4444",
        "shift": "Turno_3",
        "sectionId": 3,
        "sectionName": "Sección C",
        "subsectionId": 3,
        "subsectionName": "Subsección Z"
      },
      {
        "id": 4,
        "name": "Operario4",
        "document_num": "5555",
        "shift": "Turno_1",
        "sectionId": 1,
        "sectionName": "Sección A",
        "subsectionId": 2,
        "subsectionName": "Subsección Y"
      },
      {
        "id": 5,
        "name": "Operario5",
        "document_num": "6666",
        "shift": "Turno_2",
        "sectionId": 2,
        "sectionName": "Sección B",
        "subsectionId": 1,
        "subsectionName": "Subsección X"
      }
    ]
    ''';

    final List<dynamic> data = json.decode(operatorsJson);
    operators = data.map((item) => Operator.fromJson(item)).toList();
    notifyListeners();
  }

  void toggleProductionColumns() {
    final prodIds = [
      'cutting',
      'edgebanding',
      'drilling',
      'preparation',
      'painting',
      'packing',
    ];

    final preProdIds = ['project_design', 'planner1', 'innovation', 'planner'];

    for (var col in columns) {
      if (prodIds.contains(col['id'])) {
        col['hidden'] = !showProduction;
      }
      if (preProdIds.contains(col['id'])) {
        col['hidden'] = showProduction;
      }
    }
    showProduction = !showProduction; // Alterna el estado para la próxima vez
    notifyListeners();
  }
}
