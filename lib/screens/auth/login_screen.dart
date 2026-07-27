import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pray_iafcj/screens/auth/register_screen.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _loginUser() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty) {
      _showMessage("Escribe tu nombre de usuario.");
      return;
    }

    if (password.isEmpty) {
      _showMessage("Escribe tu contraseña.");
      return;
    }

    try {
      await AuthService().login(
        username: username,
        password: password,
      );

      if (!mounted) return;

      _showMessage("¡Bienvenido!");
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String mensaje;

      switch (e.code) {
        case 'user-not-found':
          mensaje = "No existe una cuenta con ese usuario.";
          break;
        case 'wrong-password':
          mensaje = "Contraseña incorrecta.";
          break;
        case 'invalid-email':
          mensaje = "Nombre de usuario no válido.";
          break;
        case 'user-disabled':
          mensaje = "Esa cuenta ha sido deshabilitada.";
          break;
        default:
          mensaje = e.message ?? "Ocurrió un error.";
      }

      _showMessage(mensaje);
    } catch (e) {
      _showMessage("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset("assets/images/logop.png", width: 42, height: 42, fit: BoxFit.contain),
                  const SizedBox(width: 18),
                  Text("Inicio de Sesión", style: AppTextStyles.appTitle),
                ],
              ),
              const SizedBox(height: 90),
              AppTextField(
                controller: usernameController,
                hintText: "Nombre de usuario",
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: passwordController,
                hintText: "Contraseña",
                obscureText: true,
                showPasswordIcon: true,
              ),
              const SizedBox(height: 25),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "¿No tienes cuenta? Regístrate aquí",
                    style: AppTextStyles.body.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: AppButton(
                  text: "Continuar",
                  onPressed: _loginUser,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
