import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/AuthViewModel.dart';
import '../../modelo/beans/Tutor.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _docController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _numberController = TextEditingController();
  final _streetController = TextEditingController();
  final _districtController = TextEditingController();

  bool _loading = false;
  final RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xFF0EA5AA),
      appBar: AppBar(
        backgroundColor: Color(0xFF0EA5AA),
        elevation: 0,
        title: Text('Registro', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Crea tu cuenta de Tutor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 32),
                  _buildBox(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre completo',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese su nombre completo' : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildBox(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                      validator: (v) => v == null || !emailRegex.hasMatch(v.trim()) ? 'Ingrese un email válido' : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildBox(
                    child: TextFormField(
                      controller: _docController,
                      decoration: InputDecoration(
                        labelText: 'Documento',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese su documento' : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildBox(
                    child: TextFormField(
                      controller: _numberController,
                      decoration: InputDecoration(
                        labelText: 'Número',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese su número' : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildBox(
                    child: TextFormField(
                      controller: _streetController,
                      decoration: InputDecoration(
                        labelText: 'Calle',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese su calle' : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildBox(
                    child: TextFormField(
                      controller: _districtController,
                      decoration: InputDecoration(
                        labelText: 'Distrito',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese su distrito' : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildBox(
                    child: TextFormField(
                      controller: _passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                      validator: (v) => v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildBox(
                    child: TextFormField(
                      controller: _confirmPassController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmar contraseña',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                      validator: (v) => v != _passController.text ? 'Las contraseñas no coinciden' : null,
                    ),
                  ),
                  if (authVM.error != null)
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        authVM.error!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD0D9DB),
                        foregroundColor: Colors.black87,
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _loading
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _loading = true);
                          final tutor = Tutor(
                            fullName: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                            doc: _docController.text.trim(),
                            password: _passController.text,
                            number: _numberController.text.trim(),
                            street: _streetController.text.trim(),
                            district: _districtController.text.trim(),
                            role: 'TUTOR', // Fijo
                          );
                          final ok = await authVM.registerTutor(tutor);
                          setState(() => _loading = false);
                          if (ok) Navigator.pop(context);
                        }
                      },
                      child: _loading
                          ? CircularProgressIndicator(color: Colors.black)
                          : Text('Registrarse'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBox({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFD0D9DB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}