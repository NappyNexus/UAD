/// Represents a demo user for the login screen.
class DemoUser {
  final String email;
  final String cedula;
  final String password;
  final String role;
  final String name;
  final String? photo;

  const DemoUser({
    required this.email,
    required this.cedula,
    required this.password,
    required this.role,
    required this.name,
    this.photo,
  });
}
