import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../providers/candidato_provider.dart';
import '../models/postulacion_candidato.dart';
import 'candidato_postulaciones_screen.dart';
import 'candidato_perfil_screen.dart';
import 'login_screen.dart';

class CandidatoDashboardScreen extends StatefulWidget {
  const CandidatoDashboardScreen({super.key});

  @override
  State<CandidatoDashboardScreen> createState() => _CandidatoDashboardScreenState();
}

class _CandidatoDashboardScreenState extends State<CandidatoDashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final candidatoProvider = Provider.of<CandidatoProvider>(context, listen: false);
      candidatoProvider.loadProfile();
      candidatoProvider.loadApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? const _DashboardContent()
          : _selectedIndex == 1
              ? const CandidatoPostulacionesScreen()
              : const CandidatoPerfilScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1828),
              Color(0xFF14324A),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00BCD4).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.dashboard, 'Inicio', 0),
                _buildNavItem(Icons.work_outline, 'Mis Postulaciones', 1),
                _buildNavItem(Icons.person_outline, 'Perfil', 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                )
              : null,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: isSelected ? 26 : 24,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, CandidatoProvider>(
      builder: (context, authProvider, candidatoProvider, child) {
        final usuario = authProvider.loginResponse?.usuario;
        final candidato = candidatoProvider.candidato;
        final postulaciones = candidatoProvider.postulaciones;

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
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  candidatoProvider.loadProfile(),
                  candidatoProvider.loadApplications(),
                ]);
              },
              backgroundColor: const Color(0xFF14324A),
              color: const Color(0xFF00BCD4),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hola, ${usuario?.name ?? "Candidato"} 👋',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              candidato?.titulo ?? 'Profesional',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF8B9DAF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
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
                        icon: const Icon(Icons.logout, color: Color(0xFFE94560)),
                      ),
                    ],
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),

                  const SizedBox(height: 32),

                  // Statistics Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.work_outline,
                          title: 'Postulaciones',
                          value: '${postulaciones.length}',
                          color: const Color(0xFF00BCD4),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                          ),
                        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.star_outline,
                          title: 'Habilidades',
                          value: '${candidato?.habilidadesCandidato?.length ?? 0}',
                          color: const Color(0xFF7B2CBF),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7B2CBF), Color(0xFF5A189A)],
                          ),
                        ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.2),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.language_outlined,
                          title: 'Idiomas',
                          value: '${candidato?.lenguajesCandidato?.length ?? 0}',
                          color: const Color(0xFFFFA726),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFA726), Color(0xFFFB8C00)],
                          ),
                        ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.business_center_outlined,
                          title: 'Experiencias',
                          value: '${candidato?.experiencias?.length ?? 0}',
                          color: const Color(0xFF26A69A),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF26A69A), Color(0xFF00897B)],
                          ),
                        ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.2),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Recent Applications Section
                  Text(
                    'Postulaciones Recientes',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: 16),

                  if (candidatoProvider.isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00BCD4),
                      ),
                    )
                  else if (postulaciones.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14324A).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF00BCD4).withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.work_off_outlined,
                            size: 64,
                            color: const Color(0xFF8B9DAF).withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Sin postulaciones aún',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Comienza a postularte a vacantes para verlas aquí',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF8B9DAF),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 700.ms).scale()
                  else
                    ...postulaciones.take(3).map((postulacion) {
                      return _buildApplicationCard(postulacion).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1);
                    }),

                  if (postulaciones.length > 3) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Navigate to applications screen
                        },
                        child: Text(
                          'Ver todas las postulaciones →',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF00BCD4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(PostulacionCandidato postulacion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF14324A).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00BCD4).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.business, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postulacion.vacante?.titulo ?? 'N/A',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      postulacion.vacante?.empresa?.name ?? 'N/A',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF8B9DAF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (postulacion.puntuacionCompatibilidad != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B2CBF), Color(0xFF5A189A)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.analytics, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Compatibilidad: ${postulacion.puntuacionCompatibilidad!.toStringAsFixed(1)}%',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
