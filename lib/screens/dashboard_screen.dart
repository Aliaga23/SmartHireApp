import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../providers/vacante_provider.dart';
import 'login_screen.dart';
import 'vacantes_screen.dart';
import 'perfil_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final vacanteProvider = Provider.of<VacanteProvider>(context, listen: false);
    
    final empresaId = authProvider.loginResponse?.usuario.reclutador?.empresaId;
    final token = authProvider.loginResponse?.token;
    
    if (empresaId != null && token != null) {
      vacanteProvider.loadVacantes(empresaId, token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _DashboardContent(onRefresh: _loadData),
      const PerfilScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF14324A),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.dashboard_outlined, 'Dashboard', 0),
                _buildNavItem(Icons.person_outline, 'Perfil', 1),
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
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF00BCD4).withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF00BCD4) : const Color(0xFF8B9DAF),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF00BCD4),
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
  final VoidCallback onRefresh;

  const _DashboardContent({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final vacanteProvider = Provider.of<VacanteProvider>(context);
    final usuario = authProvider.loginResponse?.usuario;
    final empresa = usuario?.reclutador?.empresa;

    final vacantesActivas = vacanteProvider.vacantes.where((v) => v.estado == 'activa').length;
    final totalPostulaciones = vacanteProvider.vacantes.fold<int>(
      0, 
      (sum, v) => sum + (v.count?.postulaciones ?? 0)
    );

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
                padding: const EdgeInsets.all(20.0),
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
                        Icons.business,
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
                            empresa?.name ?? 'SmartHire',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            usuario?.reclutador?.posicion ?? 'Dashboard',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF8B9DAF),
                              fontWeight: FontWeight.w400,
                            ),
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
                ),
              ),
              
              // Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => onRefresh(),
                  color: const Color(0xFF00BCD4),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panel de Control',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ).animate().fadeIn(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 600),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Estadísticas
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.work_outline,
                                title: 'Vacantes Activas',
                                value: vacantesActivas.toString(),
                                color: const Color(0xFF00BCD4),
                              ).animate().fadeIn(
                                delay: const Duration(milliseconds: 300),
                                duration: const Duration(milliseconds: 600),
                              ).slideX(
                                begin: -0.1,
                                duration: const Duration(milliseconds: 600),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.people_outline,
                                title: 'Postulaciones',
                                value: totalPostulaciones.toString(),
                                color: const Color(0xFF7B2CBF),
                              ).animate().fadeIn(
                                delay: const Duration(milliseconds: 400),
                                duration: const Duration(milliseconds: 600),
                              ).slideX(
                                begin: 0.1,
                                duration: const Duration(milliseconds: 600),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Acciones Rápidas
                        Text(
                          'Acciones Rápidas',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ).animate().fadeIn(
                          delay: const Duration(milliseconds: 500),
                          duration: const Duration(milliseconds: 600),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildActionCard(
                          icon: Icons.add_business,
                          title: 'Ver Vacantes',
                          subtitle: 'Gestionar todas las vacantes de la empresa',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const VacantesScreen(),
                              ),
                            );
                          },
                        ).animate().fadeIn(
                          delay: const Duration(milliseconds: 600),
                          duration: const Duration(milliseconds: 600),
                        ).slideX(
                          begin: -0.1,
                          duration: const Duration(milliseconds: 600),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        _buildActionCard(
                          icon: Icons.person_search,
                          title: 'Buscar Candidatos',
                          subtitle: 'Encontrar el talento ideal',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Funcionalidad próximamente')),
                            );
                          },
                        ).animate().fadeIn(
                          delay: const Duration(milliseconds: 700),
                          duration: const Duration(milliseconds: 600),
                        ).slideX(
                          begin: -0.1,
                          duration: const Duration(milliseconds: 600),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Vacantes Recientes
                        if (vacanteProvider.vacantes.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Vacantes Recientes',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const VacantesScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Ver todas',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF00BCD4),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ).animate().fadeIn(
                            delay: const Duration(milliseconds: 800),
                            duration: const Duration(milliseconds: 600),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          ...vacanteProvider.vacantes.take(3).map((vacante) {
                            return _buildVacanteCard(vacante);
                          }).toList(),
                        ],
                        
                        if (vacanteProvider.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(
                                color: Color(0xFF00BCD4),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
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
          color: color.withOpacity(0.3),
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
      child: Column(
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
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF8B9DAF),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF14324A).withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF00BCD4).withOpacity(0.2),
            width: 1,
          ),
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
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF8B9DAF),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF8B9DAF),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVacanteCard(vacante) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14324A).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
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
              Expanded(
                child: Text(
                  vacante.titulo,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: vacante.estado == 'activa' 
                      ? const Color(0xFF00BCD4).withOpacity(0.2)
                      : const Color(0xFF8B9DAF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  vacante.estado.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: vacante.estado == 'activa' 
                        ? const Color(0xFF00BCD4)
                        : const Color(0xFF8B9DAF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: const Color(0xFF8B9DAF),
              ),
              const SizedBox(width: 4),
              Text(
                vacante.ubicacion,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF8B9DAF),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.people_outline,
                size: 14,
                color: const Color(0xFF8B9DAF),
              ),
              const SizedBox(width: 4),
              Text(
                '${vacante.count?.postulaciones ?? 0} postulaciones',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF8B9DAF),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(
      delay: const Duration(milliseconds: 900),
      duration: const Duration(milliseconds: 600),
    );
  }
}
