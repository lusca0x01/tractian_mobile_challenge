import 'package:equatable/equatable.dart';

class CompanyModel extends Equatable {
  const CompanyModel({
    required this.id,
    required this.name,
  });

  final String? id;
  final String? name;

  CompanyModel.fromMap(Map<String, String?> map)
      : id = map["id"],
        name = map["name"];

  Map<String, String?> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}
