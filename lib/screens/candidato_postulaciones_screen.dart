import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/candidato_provider.dart';
import '../models/postulacion_candidato.dart';

class CandidatoPostulacionesScreen extends StatefulWidget {
  const CandidatoPostulacionesScreen({super.key});

  @override
  State<CandidatoPostulacionesScreen> createState() => _CandidatoPostulacionesScreenState();
}

class _CandidatoPostulacionesScreenState extends State<CandidatoPostulacionesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      final provider = Provider.of<CandidatoProvider>(context, listen: false);
      if (!provider.isLoading && provider.hasMoreApplications) {
        provider.loadApplications(loadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.work_outline, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Mis Postulaciones',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
            ),
            
            // List
            Expanded(
              child: Consumer<CandidatoProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.postulaciones.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF00BCD4)),
                    );
                  }

                  if (provider.postulaciones.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.work_off_outlined,
                              size: 80,
                              color: const Color(0xFF8B9DAF).withOpacity(0.5),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No tienes postulaciones',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Explora vacantes y comienza a postularte',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF8B9DAF),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().scale(),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => provider.loadApplications(),
                    backgroundColor: const Color(0xFF14324A),
                    color: const Color(0xFF00BCD4),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: provider.postulaciones.length + (provider.hasMoreApplications ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == provider.postulaciones.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(color: Color(0xFF00BCD4)),
                            ),
                          );
                        }

                        final postulacion = provider.postulaciones[index];
                        return _buildPostulacionCard(context, postulacion, provider)
                            .animate()
                            .fadeIn(delay: (index * 100).ms)
                            .slideY(begin: 0.1);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostulacionCard(BuildContext context, PostulacionCandidato postulacion, CandidatoProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF00BCD4).withOpacity(0.1),
                  const Color(0xFF0097A7).withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.business_outlined, size: 14, color: Color(0xFF8B9DAF)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              postulacion.vacante?.empresa?.name ?? 'N/A',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF8B9DAF),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  postulacion.vacante?.descripcion ?? 'Sin descripción',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF8B9DAF),
                    height: 1.6,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 16),
                
                // Info chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (postulacion.vacante?.modalidad != null)
                      _buildInfoChip(
                        Icons.laptop_outlined,
                        postulacion.vacante!.modalidad!.nombre ?? 'N/A',
                        const Color(0xFF7B2CBF),
                      ),
                    if (postulacion.vacante?.horario != null)
                      _buildInfoChip(
                        Icons.schedule_outlined,
                        postulacion.vacante!.horario!.nombre ?? 'N/A',
                        const Color(0xFFFFA726),
                      ),
                    if (postulacion.vacante?.salarioMinimo != null)
                      _buildInfoChip(
                        Icons.attach_money,
                        '\$${postulacion.vacante!.salarioMinimo!.toInt()} - \$${postulacion.vacante!.salarioMaximo!.toInt()}',
                        const Color(0xFF26A69A),
                      ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Compatibility score
                if (postulacion.puntuacionCompatibilidad != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF7B2CBF).withOpacity(0.2),
                          const Color(0xFF5A189A).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF7B2CBF).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.analytics, color: Color(0xFF7B2CBF), size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Compatibilidad',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF8B9DAF),
                                ),
                              ),
                              Text(
                                '${postulacion.puntuacionCompatibilidad!.toStringAsFixed(1)}%',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7B2CBF), Color(0xFF5A189A)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${postulacion.puntuacionCompatibilidad!.toInt()}',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

}
