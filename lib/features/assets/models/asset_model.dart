import 'package:equatable/equatable.dart';

class AssetModel extends Equatable {
  const AssetModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.locationId,
  });

  final String? id;
  final String? name;
  final String? parentId;
  final String? locationId;

  AssetModel.fromMap(Map<String, String?> map)
      : id = map["id"],
        name = map["name"],
        parentId = map["parentId"],
        locationId = map["locationId"];

  Map<String, String?> toMap() {
    return {
      "id": id,
      "name": name,
      "parentId": parentId,
      "locationId": locationId,
    };
  }

  @override
  List<Object?> get props => [id, name, locationId];
}
