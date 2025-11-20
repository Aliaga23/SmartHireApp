import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../providers/vacante_provider.dart';
import '../models/vacante.dart';

class PostulacionesScreen extends StatefulWidget {
  final Vacante vacante;
  
  const PostulacionesScreen({super.key, required this.vacante});

  @override
  State<PostulacionesScreen> createState() => _PostulacionesScreenState();
}

class _PostulacionesScreenState extends State<PostulacionesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPostulaciones();
    });
  }

  void _loadPostulaciones() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final vacanteProvider = Provider.of<VacanteProvider>(context, listen: false);
    
    final token = authProvider.loginResponse?.token;
    
    if (token != null) {
      vacanteProvider.loadPostulaciones(widget.vacante.id, token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vacanteProvider = Provider.of<VacanteProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.vacante.titulo,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 56),
                      child: Text(
                        '${vacanteProvider.postulaciones.length} postulaciones',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF8B9DAF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _loadPostulaciones(),
                  color: const Color(0xFF00BCD4),
                  child: vacanteProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF00BCD4),
                          ),
                        )
                      : vacanteProvider.postulaciones.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 80,
                                    color: const Color(0xFF8B9DAF).withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No hay postulaciones aún',
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
                              itemCount: vacanteProvider.postulaciones.length,
                              itemBuilder: (context, index) {
                                final postulacion = vacanteProvider.postulaciones[index];
                                return _buildPostulacionCard(postulacion, authProvider).animate().fadeIn(
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

  Widget _buildPostulacionCard(postulacion, AuthProvider authProvider) {
    final candidato = postulacion.candidato?.usuario;
    
    Color getEstadoColor(String estado) {
      switch (estado.toLowerCase()) {
        case 'aceptada':
          return const Color(0xFF00BCD4);
        case 'rechazada':
          return const Color(0xFFE94560);
        case 'pendiente':
          return const Color(0xFFFFA726);
        default:
          return const Color(0xFF8B9DAF);
      }
    }

    return Container(
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BCD4).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF00BCD4),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${candidato?.name ?? ''} ${candidato?.lastname ?? ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      candidato?.correo ?? 'N/A',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF8B9DAF),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: getEstadoColor(postulacion.estado).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  postulacion.estado.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: getEstadoColor(postulacion.estado),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 14,
                color: const Color(0xFF8B9DAF),
              ),
              const SizedBox(width: 6),
              Text(
                candidato?.telefono ?? 'N/A',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF8B9DAF),
                ),
              ),
              const SizedBox(width: 20),
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: const Color(0xFF8B9DAF),
              ),
              const SizedBox(width: 6),
              Text(
                postulacion.fechaPostulacion.substring(0, 10),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF8B9DAF),
                ),
              ),
            ],
          ),
          if (postulacion.estado.toLowerCase() == 'pendiente') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final token = authProvider.loginResponse?.token;
                      if (token != null) {
                        final success = await Provider.of<VacanteProvider>(context, listen: false)
                            .updateEstadoPostulacion(postulacion.id, 'aceptada', token);
                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Postulación aceptada'),
                              backgroundColor: Color(0xFF00BCD4),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Aceptar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BCD4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final token = authProvider.loginResponse?.token;
                      if (token != null) {
                        final success = await Provider.of<VacanteProvider>(context, listen: false)
                            .updateEstadoPostulacion(postulacion.id, 'rechazada', token);
                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Postulación rechazada'),
                              backgroundColor: Color(0xFFE94560),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Rechazar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE94560),
                      side: const BorderSide(color: Color(0xFFE94560)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
