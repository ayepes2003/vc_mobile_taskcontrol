import 'shift_model.dart';

class HourRangeResponseModel {
  final ShiftModel shift;
  final List<String> hourRanges;

  HourRangeResponseModel({required this.shift, required this.hourRanges});

  factory HourRangeResponseModel.fromJson(Map<String, dynamic> json) {
    return HourRangeResponseModel(
      shift: ShiftModel.fromJson(json['shift']),
      hourRanges: List<String>.from(json['hour_ranges']),
    );
  }
}
