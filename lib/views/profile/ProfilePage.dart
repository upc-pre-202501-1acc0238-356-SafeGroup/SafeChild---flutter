import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../models/tutor.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _streetController = TextEditingController();
  final _districtController = TextEditingController();
  bool updating = false;

  @override
  void initState() {
    super.initState();
    // Obtener el estado de autenticación
    final authState = context.read<AuthBloc>().state;
    debugPrint('Estado de autenticación: $authState');

    if (authState is AuthAuthenticated) {
      final tutorId = authState.tutorId ?? authState.user.id;
      debugPrint('Cargando perfil para tutorId: $tutorId');
      context.read<ProfileBloc>().add(ProfileFetched(tutorId));
    } else {
      debugPrint('Usuario no autenticado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0EA5AA),
      appBar: AppBar(
        backgroundColor: Color(0xFF0EA5AA),
        elevation: 0,
        title: Text('Perfil', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (state is ProfileError) {
            return Center(child: Text(state.message, style: TextStyle(color: Colors.white)));
          } else if (state is ProfileLoaded) {
            final tutor = state.tutor;
            // Actualiza controladores solo cuando se carga por primera vez
            if (_numberController.text.isEmpty) {
              _numberController.text = tutor.number;
              _streetController.text = tutor.street;
              _districtController.text = tutor.district;
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Bienvenido a SafeChild',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                      _readonlyField('Nombre completo', tutor.fullName),
                      SizedBox(height: 16),
                      _readonlyField('Correo', tutor.email),
                      SizedBox(height: 16),
                      _readonlyField('Documento', tutor.doc),
                      SizedBox(height: 16),
                      _editableField('Número (9 dígitos)', _numberController, r'^\d{9}$', 'Ingrese un número válido'),
                      SizedBox(height: 16),
                      _editableField('Calle', _streetController, r'.+', 'Ingrese su calle'),
                      SizedBox(height: 16),
                      _editableField('Distrito', _districtController, r'.+', 'Ingrese su distrito'),
                      SizedBox(height: 24),
                      BlocConsumer<ProfileBloc, ProfileState>(
                        listenWhen: (previous, current) =>
                        current is ProfileUpdateSuccess ||
                            (current is ProfileError && previous is! ProfileError),
                        listener: (context, state) {
                          if (state is ProfileUpdateSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Datos actualizados'))
                            );
                            setState(() => updating = false);
                          } else if (state is ProfileError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message))
                            );
                            setState(() => updating = false);
                          }
                        },
                        builder: (context, _) {
                          return SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF72C3CF),
                                foregroundColor: Colors.black87,
                                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: updating ? null : _updateProfile,
                              child: updating
                                  ? CircularProgressIndicator(color: Colors.black)
                                  : Text('Guardar cambios'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: Text('No hay datos disponibles', style: TextStyle(color: Colors.white)));
          }
        },
      ),
    );
  }

  void _updateProfile() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => updating = true);

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && authState.tutorId != null) {
      final profileState = context.read<ProfileBloc>().state;
      if (profileState is ProfileLoaded) {
        final tutor = profileState.tutor;
        final updatedTutor = Tutor(
          id: tutor.id,
          fullName: tutor.fullName,
          email: tutor.email,
          doc: tutor.doc,
          password: tutor.password,
          number: _numberController.text.trim(),
          street: _streetController.text.trim(),
          district: _districtController.text.trim(),
          role: tutor.role,
          profileId: tutor.profileId,
        );

        context.read<ProfileBloc>().add(ProfileUpdateRequested(authState.tutorId!, updatedTutor));
      }
    }
  }

  Widget _readonlyField(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFB4C2C8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
        style: TextStyle(color: Colors.black87),
      ),
    );
  }

  Widget _editableField(String label, TextEditingController controller, String pattern, String errorMsg) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFB4C2C8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
        validator: (v) => v == null || !RegExp(pattern).hasMatch(v.trim()) ? errorMsg : null,
        style: TextStyle(color: Colors.black87),
      ),
    );
  }
}