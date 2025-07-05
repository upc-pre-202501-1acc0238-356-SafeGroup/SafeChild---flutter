import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../home/HomePage.dart';
import 'RegisterPage.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String?> emailError = ValueNotifier<String?>(null);

    return Scaffold(
      backgroundColor: Color(0xFF0EA5AA),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Iniciar sesión como padre/tutor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/SafechildLogo.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFD0D9DB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _userController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    ),
                  ),
                ),
                ValueListenableBuilder<String?>(
                  valueListenable: emailError,
                  builder: (context, value, child) {
                    if (value == null) return SizedBox.shrink();
                    return Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFD0D9DB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    ),
                  ),
                ),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (state is AuthUnauthenticated && state.error != null)
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              state.error!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        if (state is AuthError)
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              state.message,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        SizedBox(height: 24),
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFD0D9DB),
                              foregroundColor: Colors.black87,
                              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                              final email = _userController.text.trim();
                              if (!emailRegex.hasMatch(email)) {
                                emailError.value = 'Ingrese un email válido';
                                return;
                              } else {
                                emailError.value = null;
                              }
                              context.read<AuthBloc>().add(
                                AuthLoginRequested(
                                  email,
                                  _passController.text,
                                ),
                              );
                            },
                            child: state is AuthLoading
                                ? CircularProgressIndicator()
                                : Text('Iniciar sesión'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterPage()),
                  ),
                  child: Text(
                    '¿No tienes cuenta? Regístrate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}