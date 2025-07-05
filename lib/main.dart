import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'repositories/auth_repository.dart';
import 'repositories/profile_repository.dart';
import 'services/auth_state_provider.dart';
import 'views/iam/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Configuración de Stripe
  Stripe.publishableKey = dotenv.env['PUBLISHABLE_KEY'] ?? '';
  await Stripe.instance.applySettings();

  // Crear instancias de repositorios
  final authRepository = AuthRepository();
  final profileRepository = ProfileRepository();

  // Crear e inicializar el AuthBloc
  final authBloc = AuthBloc(authRepository: authRepository);

  // Configurar el AuthStateProvider con el AuthBloc
  AuthStateProvider().setAuthBloc(authBloc);

  runApp(MyApp(
      authBloc: authBloc,
      profileRepository: profileRepository
  ));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final ProfileRepository profileRepository;

  const MyApp({
    Key? key,
    required this.authBloc,
    required this.profileRepository
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(
          value: authBloc,
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            profileRepository: profileRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'SafeChild',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoginPage(),
      ),
    );
  }
}