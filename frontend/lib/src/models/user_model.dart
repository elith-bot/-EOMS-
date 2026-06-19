class User {
  final int id;
  final String email;
  final String fullName;
  final String role;
  final int institutionId;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.institutionId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? json['email'] ?? '',
      role: json['role'] ?? 'student',
      institutionId: json['institution_id'] ?? 0,
    );
  }
}
