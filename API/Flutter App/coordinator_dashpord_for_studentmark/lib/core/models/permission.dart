import 'package:coordinator_dashpord_for_studentmark/core/models/role_permission.dart';

class Permission {
  final int id;
  final String name;
  final String? description;
  final String module;
  // final DateTime createdAt;
  // final DateTime? updatedAt;

  // Navigation properties
  final List<RolePermission>? rolePermissions;

  Permission({
    required this.id,
    required this.name,
    this.description,
    required this.module,
    // required this.createdAt,
    // this.updatedAt,
    this.rolePermissions,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      module: json['module'],
      // createdAt: DateTime.parse(json['createdAt']),
      // updatedAt:
      //     json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      rolePermissions: json['rolePermissions'] != null
          ? (json['rolePermissions'] as List)
              .map((e) => RolePermission.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'module': module,
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
      'rolePermissions': rolePermissions?.map((e) => e.toJson()).toList(),
    };
  }
}
