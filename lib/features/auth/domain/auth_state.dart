import 'user_model.dart';

sealed class AuthState {
  const AuthState();

  bool get isAuthenticated => this is Authenticated;
  bool get isGuest => this is AuthGuest;
  UserModel? get currentUser =>
      this is Authenticated ? (this as Authenticated).user : null;
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final UserModel user;
  const Authenticated(this.user);
}

class AuthGuest extends AuthState {
  const AuthGuest();
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

