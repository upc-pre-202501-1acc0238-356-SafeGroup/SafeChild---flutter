import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../models/tutor.dart';
import '../../repositories/profile_repository.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _streetController = TextEditingController();

  List<String> _districts = [];
  String? _selectedDistrict;
  bool updating = false;

  @override
  void initState() {
    super.initState();

    _loadDistricts();

    final authState = context.read<AuthBloc>().state;
    debugPrint('Estado de autenticación: $authState');

    if (authState is AuthAuthenticated) {
      final tutorId = authState.tutorId;
      if (tutorId != null) {
        context.read<ProfileBloc>().add(ProfileFetched(tutorId));
      } else {
        debugPrint('Error: No se encontró ID de tutor');
      }
    }
  }

  Future<void> _loadDistricts() async {
    final profileRepository = ProfileRepository();
    final districts = await profileRepository.fetchDistricts();
    setState(() {
      _districts = districts;
    });
  }

  // Método para formatear el distrito para mostrar
  String _formatDistrict(String backendValue) {
    return backendValue
        .split('_')
        .map((word) => word.substring(0, 1) + word.substring(1).toLowerCase())
        .join(' ');
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
          } else if (state is ProfileLoaded) {
    final tutor = state.tutor;
    _numberController.text = tutor.number;
    _streetController.text = tutor.street;
    _selectedDistrict = _selectedDistrict ?? tutor.district;

    return BlocListener<ProfileBloc, ProfileState>(
    listener: (context, state) {
    if (state is ProfileUpdateSuccess) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Perfil actualizado con éxito'),
    backgroundColor: Colors.green,
    ),
    );
    setState(() => updating = false);
    } else if (state is ProfileError) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text(state.message),
    backgroundColor: Colors.red,
    ),
    );
    setState(() => updating = false);
    }
    },
    child: Padding(
    padding: EdgeInsets.all(16),
    child: Form(
    key: _formKey,
    child: ListView(
    children: [
    _readonlyField('Nombre completo', tutor.fullName),
    SizedBox(height: 16),
    _readonlyField('Correo electrónico', tutor.email),
    SizedBox(height: 16),
    _readonlyField('Documento', tutor.doc),
    SizedBox(height: 16),
    _editableField(
    'Número de teléfono',
    _numberController,
    r'^\d{9}$',
    'Ingrese un número válido (9 dígitos)'
    ),
    SizedBox(height: 16),
    _editableField(
    'Calle',
    _streetController,
    r'^.+$',
    'Ingrese una calle válida'
    ),
    SizedBox(height: 16),
    _districtDropdown(),
    SizedBox(height: 32),
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
    onPressed: updating ? null : _updateProfile,
    child: updating
    ? CircularProgressIndicator(color: Colors.black)
        : Text('Actualizar perfil'),
    ),
    ),
    ],
    ),
    ),
    ),
    );

    } else if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.white, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Error al cargar el perfil',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                  SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is AuthAuthenticated) {
                        final tutorId = authState.tutorId ?? authState.user.id;
                        context.read<ProfileBloc>().add(ProfileFetched(tutorId));
                      }
                    },
                    child: Text(
                      'Reintentar',
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Cargando...', style: TextStyle(color: Colors.white)));
          }
        },
      ),
    );
  }

  Widget _districtDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFB4C2C8),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedDistrict,
        decoration: InputDecoration(
          labelText: 'Distrito',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
        ),
        items: _districts.map((district) {
          return DropdownMenuItem<String>(
            value: district,
            child: Text(_formatDistrict(district)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedDistrict = value;
          });
        },
        validator: (v) => v == null ? 'Seleccione un distrito' : null,
        isExpanded: true,
      ),
    );
  }

  void _updateProfile() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => updating = true);

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
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
          district: _selectedDistrict ?? tutor.district,
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