import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';

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
  bool login(String email, String password) {
    final user = AppConstants.demoUsers.where(
      (u) => u.email == email && u.password == password,
    );
    if (user.isNotEmpty) {
      final matched = user.first;
      state = AuthState(
        isAuthenticated: true,
        currentRole: matched.role,
        userName: matched.name,
        userEmail: matched.email,
      );
      return true;
    }
    return false;
  }

  /// Select a role directly (used from RoleSelectScreen).
  void selectRole(String role) {
    final user = AppConstants.demoUsers.firstWhere(
      (u) => u.role == role,
      orElse: () => AppConstants.demoUsers.first,
    );
    state = AuthState(
      isAuthenticated: true,
      currentRole: role,
      userName: user.name,
      userEmail: user.email,
    );
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
