import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../iam/LoginPage.dart';
import '../profile/ProfilePage.dart';
import '../payments/payment.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;

          return Scaffold(
            backgroundColor: Color(0xFF0EA5AA),
            appBar: AppBar(
              backgroundColor: Color(0xFF0EA5AA),
              elevation: 0,
              title: Text('Home', style: TextStyle(color: Colors.white)),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.person, size: 40),
                      ),
                    ),
                    accountName: Text(user.username),
                    accountEmail: Text(user.roles.join(', ')),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Perfil'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.message),
                    title: Text('Mensajes'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Citas'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text('Pagos'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Payment()));
                    },
                  ),
                  Spacer(),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                            (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
            body: Center(
              child: Text(
                'Bienvenido a SafeChild',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else {
          return LoginPage();
        }
      },
    );
  }
}