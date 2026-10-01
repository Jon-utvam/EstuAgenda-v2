import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Variables para el género y las políticas
  String? _selectedGender;
  bool _acceptedTerms = false;

  // Paleta de colores
  final Color stuDark = const Color(0xFF1A635D);
  final Color stuVibrant = const Color(0xFF4AB6AC);
  final Color stuInput = const Color(0xFFF0F4F8);

  void _register() {
    // Validar formulario primero
    if (_formKey.currentState!.validate()) {
      // Validar si aceptó las políticas de privacidad
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes aceptar las políticas de privacidad y avisos para continuar.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // Si todo está correcto
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registrando usuario...'),
          backgroundColor: stuDark,
        ),
      );
    }
  }

  // Ventana emergente para mostrar los avisos/políticas
  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Políticas de Privacidad y Avisos',
          style: TextStyle(color: stuDark, fontWeight: FontWeight.bold),
        ),
        content: const SingleChildScrollView(
          child: Text(
            '(aquí irán los avisos)',
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cerrar',
              style: TextStyle(color: stuDark, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: stuDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Imagen reemplazando al icono antiguo
                  Image.asset(
                    'assets/logo.png',
                    height: 80,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Crear Cuenta',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: stuDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Campo de Nombre
                  TextFormField(
                    controller: _nameController,
                    cursorColor: stuDark,
                    decoration: InputDecoration(
                      labelText: 'Nombre Completo',
                      labelStyle: TextStyle(color: stuDark),
                      filled: true,
                      fillColor: stuInput,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: stuVibrant, width: 2),
                      ),
                      prefixIcon: Icon(Icons.person, color: stuVibrant),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo de Correo
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: stuDark,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      labelStyle: TextStyle(color: stuDark),
                      filled: true,
                      fillColor: stuInput,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: stuVibrant, width: 2),
                      ),
                      prefixIcon: Icon(Icons.email, color: stuVibrant),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo';
                      }
                      if (!value.contains('@')) {
                        return 'Ingresa un correo válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo de Contraseña
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    cursorColor: stuDark,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: stuDark),
                      filled: true,
                      fillColor: stuInput,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: stuVibrant, width: 2),
                      ),
                      prefixIcon: Icon(Icons.lock, color: stuVibrant),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo de Confirmar Contraseña
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    cursorColor: stuDark,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      labelStyle: TextStyle(color: stuDark),
                      filled: true,
                      fillColor: stuInput,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: stuVibrant, width: 2),
                      ),
                      prefixIcon: Icon(Icons.lock_outline, color: stuVibrant),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor confirma tu contraseña';
                      }
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Desplegable de Género
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Género',
                      labelStyle: TextStyle(color: stuDark),
                      filled: true,
                      fillColor: stuInput,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: stuVibrant, width: 2),
                      ),
                      prefixIcon: Icon(Icons.wc, color: stuVibrant),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Masculino',
                        child: Text('Masculino'),
                      ),
                      DropdownMenuItem(
                        value: 'Femenino',
                        child: Text('Femenino'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona tu género';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Casilla de Aceptación de Políticas y Avisos
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        activeColor: stuDark,
                        onChanged: (bool? value) {
                          setState(() {
                            _acceptedTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _showPrivacyPolicy,
                          child: Text.rich(
                            TextSpan(
                              text: 'Acepto las ',
                              style: const TextStyle(color: Colors.black87),
                              children: [
                                TextSpan(
                                  text: 'políticas de privacidad y avisos',
                                  style: TextStyle(
                                    color: stuDark,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Botón de Registro
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: stuDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Botón para regresar al Login
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: stuDark,
                    ),
                    child: const Text(
                      '¿Ya tienes cuenta? Inicia sesión',
                      style: TextStyle(fontWeight: FontWeight.w600),
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
}