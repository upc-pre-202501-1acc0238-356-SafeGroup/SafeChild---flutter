import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/AuthViewModel.dart';
import '../../modelo/beans/Tutor.dart';
import 'package:http/http.dart' as http;
import '../../config/ApiConfig.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Tutor? tutor;
  bool loading = true;
  bool updating = false;
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _streetController = TextEditingController();
  final _districtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTutor();
  }

  Future<void> _fetchTutor() async {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final id = authVM.tutorId;
    if (id == null) return;
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/tutors/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        tutor = Tutor.fromJson(data);
        _numberController.text = tutor!.number;
        _streetController.text = tutor!.street;
        _districtController.text = tutor!.district;
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  Future<void> _updateTutor() async {
    if (!_formKey.currentState!.validate() || tutor == null) return;
    setState(() => updating = true);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final updatedTutor = Tutor(
      id: tutor!.id,
      fullName: tutor!.fullName,
      email: tutor!.email,
      doc: tutor!.doc,
      password: tutor!.password,
      number: _numberController.text.trim(),
      street: _streetController.text.trim(),
      district: _districtController.text.trim(),
      role: tutor!.role,
      profileId: tutor!.profileId,
    );
    final ok = await authVM.updateTutor(updatedTutor);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Datos actualizados')));
      setState(() => tutor = updatedTutor);
    }
    setState(() => updating = false);
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xFF0EA5AA),
      appBar: AppBar(
        backgroundColor: Color(0xFF0EA5AA),
        elevation: 0,
        title: Text('Perfil', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : tutor == null
          ? Center(child: Text('No se pudo cargar el perfil', style: TextStyle(color: Colors.white)))
          : SingleChildScrollView(
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
                _readonlyField('Nombre completo', tutor!.fullName),
                SizedBox(height: 16),
                _readonlyField('Correo', tutor!.email),
                SizedBox(height: 16),
                _readonlyField('Documento', tutor!.doc),
                SizedBox(height: 16),
                _editableField('Número (9 dígitos)', _numberController, r'^\d{9}$', 'Ingrese un número válido'),
                SizedBox(height: 16),
                _editableField('Calle', _streetController, r'.+', 'Ingrese su calle'),
                SizedBox(height: 16),
                _editableField('Distrito', _districtController, r'.+', 'Ingrese su distrito'),
                SizedBox(height: 24),
                if (authVM.error != null)
                  Text(authVM.error!, style: TextStyle(color: Colors.red)),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF72C3CF),
                      foregroundColor: Colors.black87,
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: updating ? null : _updateTutor,
                    child: updating
                        ? CircularProgressIndicator(color: Colors.black)
                        : Text('Guardar cambios'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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