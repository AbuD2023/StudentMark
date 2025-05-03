import 'package:coordinator_dashpord_for_studentmark/core/models/permission.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/role.dart';

class RolePermission {
  final int id;
  final int roleId;
  final int permissionId;
  // final DateTime createdAt;
  // final DateTime? updatedAt;

  // Navigation properties
  final Role? role;
  final Permission? permission;

  RolePermission({
    required this.id,
    required this.roleId,
    required this.permissionId,
    // required this.createdAt,
    // this.updatedAt,
    this.role,
    this.permission,
  });

  factory RolePermission.fromJson(Map<String, dynamic> json) {
    return RolePermission(
      id: json['id'] as int,
      roleId: json['roleId'] as int,
      permissionId: json['permissionId'] as int,
      // createdAt: DateTime.parse(json['createdAt'] as String),
      // updatedAt: json['updatedAt'] != null
      //     ? DateTime.parse(json['updatedAt'] as String)
      //     : null,
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      permission: json['permission'] != null
          ? Permission.fromJson(json['permission'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roleId': roleId,
      'permissionId': permissionId,
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
      'role': role?.toJson(),
      'permission': permission?.toJson(),
    };
  }
}
