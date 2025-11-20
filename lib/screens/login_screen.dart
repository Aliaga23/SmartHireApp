import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';
import 'dashboard_screen.dart';
import 'candidato_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es requerido';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        // Redirect based on user type
        final tipoUsuario = authProvider.loginResponse?.tipoUsuario;
        
        Widget nextScreen;
        if (tipoUsuario == 'candidato') {
          nextScreen = const CandidatoDashboardScreen();
        } else {
          // reclutador or admin
          nextScreen = const DashboardScreen();
        }
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      } else if (mounted && authProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: const Color(0xFFE94560),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(20),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A1828),
              Color(0xFF0F2638),
              Color(0xFF14324A),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F2638).withOpacity(0.5),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00BCD4).withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.work_outline,
                        size: 80,
                        color: Color(0xFF00BCD4),
                      ),
                    ).animate().scale(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Title
                    Text(
                      'SmartHire Studio',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ).animate().fadeIn(
                      duration: const Duration(milliseconds: 800),
                    ).slideY(
                      begin: -0.3,
                      duration: const Duration(milliseconds: 800),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Sistema de Gestión de Reclutamiento',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF8B9DAF),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 800),
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Card Container
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14324A).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: const Color(0xFF00BCD4).withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            label: 'Correo Electrónico',
                            hint: 'correo@ejemplo.com',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                          ).animate().fadeIn(
                            delay: const Duration(milliseconds: 400),
                            duration: const Duration(milliseconds: 600),
                          ).slideX(
                            begin: -0.2,
                            duration: const Duration(milliseconds: 600),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Contraseña',
                            hint: '••••••••',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            validator: _validatePassword,
                          ).animate().fadeIn(
                            delay: const Duration(milliseconds: 600),
                            duration: const Duration(milliseconds: 600),
                          ).slideX(
                            begin: -0.2,
                            duration: const Duration(milliseconds: 600),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return GradientButton(
                                text: 'INICIAR SESIÓN',
                                onPressed: _handleLogin,
                                isLoading: authProvider.isLoading,
                              );
                            },
                          ).animate().fadeIn(
                            delay: const Duration(milliseconds: 800),
                            duration: const Duration(milliseconds: 600),
                          ).scale(
                            delay: const Duration(milliseconds: 800),
                            duration: const Duration(milliseconds: 600),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 800),
                    ).scale(
                      begin: const Offset(0.8, 0.8),
                      duration: const Duration(milliseconds: 800),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    Text(
                      'Powered by SmartHire Solutions',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF8B9DAF).withOpacity(0.5),
                        fontWeight: FontWeight.w300,
                      ),
                    ).animate().fadeIn(
                      delay: const Duration(milliseconds: 1000),
                      duration: const Duration(milliseconds: 800),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
