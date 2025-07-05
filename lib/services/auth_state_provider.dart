import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';

class AuthStateProvider {
  static final AuthStateProvider _instance = AuthStateProvider._internal();
  factory AuthStateProvider() => _instance;
  AuthStateProvider._internal();

  AuthBloc? _authBloc;

  void setAuthBloc(AuthBloc authBloc) {
    _authBloc = authBloc;
  }

  AuthState? getAuthState() {
    return _authBloc?.state;
  }
}