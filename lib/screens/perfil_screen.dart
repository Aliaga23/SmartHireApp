import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final usuario = authProvider.loginResponse?.usuario;
    final tipoUsuario = authProvider.loginResponse?.tipoUsuario;

    return Container(
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header con Avatar
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF00BCD4).withOpacity(0.2),
                        const Color(0xFF0097A7).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF00BCD4).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00BCD4).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          tipoUsuario == 'reclutador' ? Icons.business_center : Icons.person,
                          size: 64,
                          color: Colors.white,
                        ),
                      ).animate().scale(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.elasticOut,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Nombre
                      Text(
                        '${usuario?.name} ${usuario?.lastname}',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 600),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Badge de tipo de usuario
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
                            const Icon(Icons.verified, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              tipoUsuario?.toUpperCase() ?? 'USUARIO',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(
                        delay: const Duration(milliseconds: 300),
                        duration: const Duration(milliseconds: 600),
                      ).scale(
                        delay: const Duration(milliseconds: 300),
                        duration: const Duration(milliseconds: 600),
                      ),
                    ],
                  ),
                ).animate().fadeIn(
                  duration: const Duration(milliseconds: 800),
                ).slideY(
                  begin: -0.2,
                  duration: const Duration(milliseconds: 800),
                ),
                
                const SizedBox(height: 32),
                
                // Sección: Información Personal
                _buildSectionTitle('Información Personal').animate().fadeIn(
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 600),
                ),
                
                const SizedBox(height: 16),
                
                _buildInfoCard(
                  icon: Icons.email_outlined,
                  title: 'Correo Electrónico',
                  value: usuario?.correo ?? 'N/A',
                  color: const Color(0xFF00BCD4),
                ).animate().fadeIn(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 600),
                ).slideX(
                  begin: -0.1,
                  duration: const Duration(milliseconds: 600),
                ),
                
                const SizedBox(height: 12),
                
                _buildInfoCard(
                  icon: Icons.phone_outlined,
                  title: 'Teléfono',
                  value: usuario?.telefono ?? 'N/A',
                  color: const Color(0xFF7B2CBF),
                ).animate().fadeIn(
                  delay: const Duration(milliseconds: 600),
                  duration: const Duration(milliseconds: 600),
                ).slideX(
                  begin: -0.1,
                  duration: const Duration(milliseconds: 600),
                ),
                
                if (usuario?.fechaNacimiento != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.cake_outlined,
                    title: 'Fecha de Nacimiento',
                    value: usuario!.fechaNacimiento!.substring(0, 10),
                    color: const Color(0xFFFFA726),
                  ).animate().fadeIn(
                    delay: const Duration(milliseconds: 700),
                    duration: const Duration(milliseconds: 600),
                  ).slideX(
                    begin: -0.1,
                    duration: const Duration(milliseconds: 600),
                  ),
                ],
                
                if (tipoUsuario == 'reclutador' && usuario?.reclutador != null) ...[
                  const SizedBox(height: 32),
                  
                  _buildSectionTitle('Información Laboral').animate().fadeIn(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 600),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildInfoCard(
                    icon: Icons.work_outline,
                    title: 'Posición',
                    value: usuario?.reclutador?.posicion ?? 'N/A',
                    color: const Color(0xFF00BCD4),
                  ).animate().fadeIn(
                    delay: const Duration(milliseconds: 900),
                    duration: const Duration(milliseconds: 600),
                  ).slideX(
                    begin: -0.1,
                    duration: const Duration(milliseconds: 600),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildInfoCard(
                    icon: Icons.business_outlined,
                    title: 'Empresa',
                    value: usuario?.reclutador?.empresa?.name ?? 'N/A',
                    color: const Color(0xFF7B2CBF),
                  ).animate().fadeIn(
                    delay: const Duration(milliseconds: 1000),
                    duration: const Duration(milliseconds: 600),
                  ).slideX(
                    begin: -0.1,
                    duration: const Duration(milliseconds: 600),
                  ),
                  
                  if (usuario?.reclutador?.empresa?.area != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.category_outlined,
                      title: 'Área',
                      value: usuario!.reclutador!.empresa!.area ?? 'N/A',
                      color: const Color(0xFFFFA726),
                    ).animate().fadeIn(
                      delay: const Duration(milliseconds: 1100),
                      duration: const Duration(milliseconds: 600),
                    ).slideX(
                      begin: -0.1,
                      duration: const Duration(milliseconds: 600),
                    ),
                  ],
                  
                  if (usuario?.reclutador?.empresa?.descripcion != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14324A).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF00BCD4).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00BCD4).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.description_outlined,
                                  color: Color(0xFF00BCD4),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Descripción',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF8B9DAF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            usuario!.reclutador!.empresa!.descripcion ?? 'N/A',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(
                      delay: const Duration(milliseconds: 1200),
                      duration: const Duration(milliseconds: 600),
                    ).slideX(
                      begin: -0.1,
                      duration: const Duration(milliseconds: 600),
                    ),
                  ],
                ],
                
                const SizedBox(height: 32),
                
                // Botón de cerrar sesión
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE94560).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
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
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar Sesión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE94560),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                      textStyle: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ).animate().fadeIn(
                  delay: const Duration(milliseconds: 1300),
                  duration: const Duration(milliseconds: 600),
                ).scale(
                  delay: const Duration(milliseconds: 1300),
                  duration: const Duration(milliseconds: 600),
                ),
                
                const SizedBox(height: 24),
                
                // Footer
                Center(
                  child: Text(
                    'SmartHire Studio',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF8B9DAF).withOpacity(0.5),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ).animate().fadeIn(
                  delay: const Duration(milliseconds: 1400),
                  duration: const Duration(milliseconds: 800),
                ),
                
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF14324A).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
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
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
