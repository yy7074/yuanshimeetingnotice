class UserModel {
  final String id;
  final String email;
  final String nameEn;
  final String nameZh;
  final String titleEn;
  final String titleZh;
  final String organizationEn;
  final String organizationZh;
  final String avatarUrl;
  final UserRole role;
  final bool mustChangePassword;

  const UserModel({
    required this.id,
    required this.email,
    required this.nameEn,
    required this.nameZh,
    required this.titleEn,
    required this.titleZh,
    required this.organizationEn,
    required this.organizationZh,
    required this.avatarUrl,
    this.role = UserRole.attendee,
    this.mustChangePassword = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'nameEn': nameEn,
    'nameZh': nameZh,
    'titleEn': titleEn,
    'titleZh': titleZh,
    'organizationEn': organizationEn,
    'organizationZh': organizationZh,
    'avatarUrl': avatarUrl,
    'role': role.name,
    'mustChangePassword': mustChangePassword,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    email: json['email'] as String,
    nameEn: json['nameEn'] as String,
    nameZh: json['nameZh'] as String,
    titleEn: json['titleEn'] as String,
    titleZh: json['titleZh'] as String,
    organizationEn: json['organizationEn'] as String,
    organizationZh: json['organizationZh'] as String,
    avatarUrl: json['avatarUrl'] as String,
    role: UserRole.values.firstWhere(
      (e) => e.name == json['role'],
      orElse: () => UserRole.attendee,
    ),
    mustChangePassword: json['mustChangePassword'] == true,
  );
}

enum UserRole { attendee, speaker, vip, admin }
