// import 'dart:convert';

class RouteInitialData {
  final int id; // From 'server_id'
  final int? serverId;
  final String codeProces;
  final int productionBaselineId;
  final int projectProductionId;
  final int sectionId;
  final String routeNum;
  final int initialQuantity;
  final int statusId;

  final String? sectionName;
  final int? ppId;
  final int? ppProjectId;
  final int? ppStatusId;

  final String? projectName;
  final String? projectCode;
  final String? codeDispatch;
  final String? codeSalesErp;

  // Campos locales adicionales si tienes
  // (agrega aquí si necesitas campos locales específicos)

  RouteInitialData({
    required this.id,
    this.serverId,
    required this.codeProces,
    required this.productionBaselineId,
    required this.projectProductionId,
    required this.sectionId,
    required this.routeNum,
    required this.initialQuantity,
    required this.statusId,
    this.sectionName,
    this.ppId,
    this.ppProjectId,
    this.ppStatusId,
    this.projectName,
    this.projectCode,
    this.codeDispatch,
    this.codeSalesErp,
  });

  // Helper para limpiar Strings y evitar nulls
  static String _safeTrim(dynamic value) {
    return (value ?? '').toString().trim();
  }

  // Construir desde JSON (Map) - limpieza similar a RouteCard
  factory RouteInitialData.fromJson(Map<String, dynamic> json) {
    return RouteInitialData(
      id: json['id'] ?? 0,
      codeProces: _safeTrim(json['code_proces']),
      productionBaselineId: json['production_baseline_id'] ?? 0,
      projectProductionId: json['project_production_id'] ?? 0,
      sectionId: json['section_id'] ?? 0,
      routeNum: _safeTrim(json['route_num']),
      initialQuantity: json['initial_quantity'] ?? 0,
      statusId: json['status_id'] ?? 0,
      sectionName:
          json['section_name'] != null ? _safeTrim(json['section_name']) : null,
      ppId: json['pp_id'],
      ppProjectId: json['pp_project_id'],
      ppStatusId: json['pp_status_id'],
      projectName:
          json['project_name'] != null ? _safeTrim(json['project_name']) : null,
      projectCode:
          json['project_code'] != null ? _safeTrim(json['project_code']) : null,
      codeDispatch:
          json['code_dispatch'] != null
              ? _safeTrim(json['code_dispatch'])
              : null,
      codeSalesErp:
          json['code_sales_erp'] != null
              ? _safeTrim(json['code_sales_erp'])
              : null,
    );
  }

  // Convertir a JSON (para API), sin campos locales
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code_proces': codeProces,
      'production_baseline_id': productionBaselineId,
      'project_production_id': projectProductionId,
      'section_id': sectionId,
      'route_num': routeNum,
      'initial_quantity': initialQuantity,
      'status_id': statusId,
      'section_name': sectionName,
      'pp_id': ppId,
      'pp_project_id': ppProjectId,
      'pp_status_id': ppStatusId,
      'project_name': projectName,
      'project_code': projectCode,
      'code_dispatch': codeDispatch,
      'code_sales_erp': codeSalesErp,
    };
  }

  // Construir desde Map SQLite (incluye campos locales si tienes)
  factory RouteInitialData.fromMap(Map<String, dynamic> map) {
    return RouteInitialData(
      id: map['id'] as int,
      codeProces: _safeTrim(map['code_proces']),
      productionBaselineId: map['production_baseline_id'] ?? 0,
      projectProductionId: map['project_production_id'] ?? 0,
      sectionId: map['section_id'] ?? 0,
      routeNum: _safeTrim(map['route_num']),
      initialQuantity: map['initial_quantity'] ?? 0,
      statusId: map['status_id'] ?? 0,
      sectionName:
          map['section_name'] != null ? _safeTrim(map['section_name']) : null,
      ppId: map['pp_id'],
      ppProjectId: map['pp_project_id'],
      ppStatusId: map['pp_status_id'],
      projectName:
          map['project_name'] != null ? _safeTrim(map['project_name']) : null,
      projectCode:
          map['project_code'] != null ? _safeTrim(map['project_code']) : null,
      codeDispatch:
          map['code_dispatch'] != null ? _safeTrim(map['code_dispatch']) : null,
      codeSalesErp:
          map['code_sales_erp'] != null
              ? _safeTrim(map['code_sales_erp'])
              : null,
    );
  }

  // Convertir a Map para SQLite (puedes agregar parámetro forInsert para control)
  Map<String, dynamic> toMap({bool forInsert = false}) {
    final map = <String, dynamic>{
      'id': id,
      'code_proces': codeProces,
      'production_baseline_id': productionBaselineId,
      'project_production_id': projectProductionId,
      'section_id': sectionId,
      'route_num': routeNum,
      'initial_quantity': initialQuantity,
      'status_id': statusId,
      'section_name': sectionName,
      'pp_id': ppId,
      'pp_project_id': ppProjectId,
      'pp_status_id': ppStatusId,
      'project_name': projectName,
      'project_code': projectCode,
      'code_dispatch': codeDispatch,
      'code_sales_erp': codeSalesErp,
    };

    if (!forInsert) {
      // Solo incluye 'id' si NO es para insert (por ejemplo para update)
      map['id'] = id;
    }

    return map;
  }
}
// import 'package:dio/dio.dart';