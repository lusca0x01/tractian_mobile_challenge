import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  const LocationModel({
    required this.id,
    required this.name,
    required this.parentId,
  });

  final String? id;
  final String? name;
  final String? parentId;

  LocationModel.fromMap(Map<String, String?> map)
      : id = map["id"],
        name = map["name"],
        parentId = map["parentId"];

  Map<String, String?> toMap() {
    return {
      "id": id,
      "name": name,
      "parentId": parentId,
    };
  }

  @override
  List<Object?> get props => [id, name, parentId];
}
