import 'package:coordinator_dashpord_for_studentmark/core/models/role_permission.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/user.dart';

class Role {
  final int id;
  final String name;
  final String description;
  // final DateTime createdAt;
  // final DateTime? updatedAt;

  // Navigation properties
  final List<User>? users;
  final List<RolePermission>? rolePermissions;

  Role({
    required this.id,
    required this.name,
    required this.description,
    // required this.createdAt,
    // this.updatedAt,
    this.users,
    this.rolePermissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      // createdAt: DateTime.parse(json['createdAt'] as String),
      // updatedAt: json['updatedAt'] != null
      //     ? DateTime.parse(json['updatedAt'] as String)
      //     : null,
      users: json['users'] != null
          ? (json['users'] as List).map((e) => User.fromJson(e)).toList()
          : null,
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
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
      'users': users?.map((e) => e.toJson()).toList(),
      'rolePermissions': rolePermissions?.map((e) => e.toJson()).toList(),
    };
  }
}
