class AppUser {
  final String fullName;
  final String agency;
  final String email;
  final String password;
  final String role; // 👈 NEW
  final bool isVerified;

  AppUser({
    required this.fullName,
    required this.agency,
    required this.email,
    required this.password,
    this.role = "user", // 👈 DEFAULT VALUE
    this.isVerified = false
  });

  /// Convert model → JSON
  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "agency": agency,
      "email": email,
      "password": password,
      "role": role,
      "isVerified":isVerified
    };
  }

  /// Convert JSON → model
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      fullName: json["fullName"] ?? "",
      agency: json["agency"] ?? "",
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      role: json["role"] ?? "user", // 👈 fallback default
       isVerified: json["isVerified"] ?? false, // 👈 fallback default
    );
  }

  /// copyWith for updates
  AppUser copyWith({
    String? fullName,
    String? agency,
    String? email,
    String? password,
    String? role,
  }) {
    return AppUser(
      fullName: fullName ?? this.fullName,
      agency: agency ?? this.agency,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}