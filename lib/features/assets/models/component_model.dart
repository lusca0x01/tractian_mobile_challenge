import 'package:equatable/equatable.dart';

class ComponentModel extends Equatable {
  const ComponentModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.gatewayId,
    required this.locationId,
  });

  final String? id;
  final String? name;
  final String? parentId;
  final String? sensorId;
  final String? sensorType;
  final String? status;
  final String? gatewayId;
  final String? locationId;

  ComponentModel.fromMap(Map<String, String?> map)
      : id = map["id"],
        name = map["name"],
        parentId = map["parentId"],
        sensorId = map["sensorId"],
        sensorType = map["sensorType"],
        status = map["status"],
        gatewayId = map["gatewayId"],
        locationId = map["locationId"];

  Map<String, String?> toMap() {
    return {
      "id": id,
      "name": name,
      "parentId": parentId,
      "sensorId": sensorId,
      "sensorType": sensorType,
      "status": status,
      "gatewayId": gatewayId,
      "locationId": locationId,
    };
  }

  @override
  List<Object?> get props =>
      [id, name, parentId, sensorId, sensorType, status, gatewayId, locationId];
}
