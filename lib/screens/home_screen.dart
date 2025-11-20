import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final usuario = authProvider.loginResponse?.usuario;
    final tipoUsuario = authProvider.loginResponse?.tipoUsuario;

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
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF00BCD4).withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00BCD4).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenido',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF8B9DAF),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${usuario?.name} ${usuario?.lastname}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE94560).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          await authProvider.logout();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.logout, color: Color(0xFFE94560), size: 20),
                        tooltip: 'Cerrar Sesión',
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ).animate().fadeIn(
                  duration: const Duration(milliseconds: 600),
                ).slideY(
                  begin: -0.2,
                  duration: const Duration(milliseconds: 600),
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              tipoUsuario?.toUpperCase() ?? 'N/A',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 600),
                      ).slideX(
                        begin: -0.2,
                        duration: const Duration(milliseconds: 600),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        'Información Personal',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn(
                        delay: const Duration(milliseconds: 300),
                        duration: const Duration(milliseconds: 600),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Personal Info Grid
                      _buildInfoCard(
                        Icons.email_outlined,
                        'Correo Electrónico',
                        usuario?.correo ?? 'N/A',
                      ).animate().fadeIn(
                        delay: const Duration(milliseconds: 400),
                        duration: const Duration(milliseconds: 600),
                      ).slideX(
                        begin: -0.1,
                        duration: const Duration(milliseconds: 600),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildInfoCard(
                        Icons.phone_outlined,
                        'Teléfono',
                        usuario?.telefono ?? 'N/A',
                      ).animate().fadeIn(
                        delay: const Duration(milliseconds: 500),
                        duration: const Duration(milliseconds: 600),
                      ).slideX(
                        begin: -0.1,
                        duration: const Duration(milliseconds: 600),
                      ),
                      
                      if (tipoUsuario == 'reclutador' && usuario?.reclutador != null) ...[
                        const SizedBox(height: 32),
                        
                        Text(
                          'Información Laboral',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ).animate().fadeIn(
                          delay: const Duration(milliseconds: 600),
                          duration: const Duration(milliseconds: 600),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildInfoCard(
                          Icons.work_outline,
                          'Posición',
                          usuario?.reclutador?.posicion ?? 'N/A',
                        ).animate().fadeIn(
                          delay: const Duration(milliseconds: 700),
                          duration: const Duration(milliseconds: 600),
                        ).slideX(
                          begin: -0.1,
                          duration: const Duration(milliseconds: 600),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        _buildInfoCard(
                          Icons.business_outlined,
                          'Empresa',
                          usuario?.reclutador?.empresa?.name ?? 'N/A',
                        ).animate().fadeIn(
                          delay: const Duration(milliseconds: 800),
                          duration: const Duration(milliseconds: 600),
                        ).slideX(
                          begin: -0.1,
                          duration: const Duration(milliseconds: 600),
                        ),
                        
                        if (usuario?.reclutador?.empresa?.area != null) ...[
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            Icons.category_outlined,
                            'Área',
                            usuario!.reclutador!.empresa!.area ?? 'N/A',
                          ).animate().fadeIn(
                            delay: const Duration(milliseconds: 900),
                            duration: const Duration(milliseconds: 600),
                          ).slideX(
                            begin: -0.1,
                            duration: const Duration(milliseconds: 600),
                          ),
                        ],
                      ],
                      
                      const SizedBox(height: 40),
                      
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.work_outline,
                              color: const Color(0xFF00BCD4).withOpacity(0.3),
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'SmartHire Studio',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF8B9DAF).withOpacity(0.5),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(
                          delay: const Duration(milliseconds: 1000),
                          duration: const Duration(milliseconds: 800),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF14324A).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00BCD4).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00BCD4).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00BCD4),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF8B9DAF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
