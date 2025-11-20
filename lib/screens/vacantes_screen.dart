import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../providers/vacante_provider.dart';
import 'postulaciones_screen.dart';

class VacantesScreen extends StatefulWidget {
  const VacantesScreen({super.key});

  @override
  State<VacantesScreen> createState() => _VacantesScreenState();
}

class _VacantesScreenState extends State<VacantesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVacantes();
    });
  }

  void _loadVacantes() {
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
    final vacanteProvider = Provider.of<VacanteProvider>(context);

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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Vacantes',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _loadVacantes(),
                  color: const Color(0xFF00BCD4),
                  child: vacanteProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF00BCD4),
                          ),
                        )
                      : vacanteProvider.vacantes.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.work_off_outlined,
                                    size: 80,
                                    color: const Color(0xFF8B9DAF).withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No hay vacantes disponibles',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: const Color(0xFF8B9DAF),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: vacanteProvider.vacantes.length,
                              itemBuilder: (context, index) {
                                final vacante = vacanteProvider.vacantes[index];
                                return _buildVacanteCard(vacante).animate().fadeIn(
                                  delay: Duration(milliseconds: 100 * index),
                                  duration: const Duration(milliseconds: 400),
                                ).slideY(
                                  begin: 0.1,
                                  duration: const Duration(milliseconds: 400),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVacanteCard(vacante) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostulacionesScreen(vacante: vacante),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    vacante.titulo,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: vacante.estado == 'activa' 
                        ? const Color(0xFF00BCD4).withOpacity(0.2)
                        : const Color(0xFF8B9DAF).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    vacante.estado.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: vacante.estado == 'activa' 
                          ? const Color(0xFF00BCD4)
                          : const Color(0xFF8B9DAF),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              vacante.descripcion,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF8B9DAF),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildInfoChip(Icons.location_on_outlined, vacante.ubicacion),
                _buildInfoChip(Icons.work_outline, vacante.modalidad),
                _buildInfoChip(Icons.description_outlined, vacante.tipoContrato),
                _buildInfoChip(Icons.people_outline, '${vacante.count?.postulaciones ?? 0} postulaciones'),
              ],
            ),
            if (vacante.salarioMin != null && vacante.salarioMax != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: const Color(0xFF00BCD4),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '\$${vacante.salarioMin!.toStringAsFixed(0)} - \$${vacante.salarioMax!.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF00BCD4),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: const Color(0xFF8B9DAF),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF8B9DAF),
          ),
        ),
      ],
    );
  }
}
