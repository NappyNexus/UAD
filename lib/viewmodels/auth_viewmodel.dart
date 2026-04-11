import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock/mock_data.dart';

/// Auth state for the application.
class AuthState {
  final bool isAuthenticated;
  final String? currentRole;
  final String? userName;
  final String? userEmail;
  final String? userPhoto;

  const AuthState({
    this.isAuthenticated = false,
    this.currentRole,
    this.userName,
    this.userEmail,
    this.userPhoto,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? currentRole,
    String? userName,
    String? userEmail,
    String? userPhoto,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentRole: currentRole ?? this.currentRole,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhoto: userPhoto ?? this.userPhoto,
    );
  }
}

/// ViewModel for authentication and role selection.
class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel() : super(const AuthState());

  /// Attempt login with credentials. Returns true if successful.
  bool login(String identifier, String password) {
    // Validate by cedula (ID) as requested
    final userMatches = demoUsers.where(
      (u) => u.cedula == identifier && u.password == password,
    );
    if (userMatches.isNotEmpty) {
      final matched = userMatches.first;
      state = AuthState(
        isAuthenticated: true,
        currentRole: matched.role,
        userName: matched.name,
        userEmail: matched.email,
        userPhoto: matched.photo,
      );
      return true;
    }
    return false;
  }

  /// Update the user photo.
  void setUserPhoto(String? photoUrl) {
    state = state.copyWith(userPhoto: photoUrl);
  }

  /// Log out and reset state.
  void logout() {
    state = const AuthState();
  }
}

/// Provider for [AuthViewModel].
final authProvider = StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(),
);
