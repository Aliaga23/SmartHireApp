import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/candidato_provider.dart';
import '../providers/auth_provider.dart';

class CandidatoPerfilScreen extends StatefulWidget {
  const CandidatoPerfilScreen({super.key});

  @override
  State<CandidatoPerfilScreen> createState() => _CandidatoPerfilScreenState();
}

class _CandidatoPerfilScreenState extends State<CandidatoPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _bioController = TextEditingController();
  final _ubicacionController = TextEditingController();
  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final candidatoProvider = Provider.of<CandidatoProvider>(context, listen: false);
      final candidato = candidatoProvider.candidato;
      if (candidato != null) {
        _tituloController.text = candidato.titulo ?? '';  // titulo puede ser null
        _bioController.text = candidato.bio ?? '';       // bio puede ser null
        _ubicacionController.text = candidato.ubicacion ?? '';  // ubicacion puede ser null
      }
    });
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _bioController.dispose();
    _ubicacionController.dispose();
    super.dispose();
  }

  Future<void> _scanCV() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return;

      if (!mounted) return;

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF14324A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF00BCD4)),
              const SizedBox(height: 20),
              Text(
                'Procesando CV con IA...',
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ],
          ),
        ),
      );

      // Convert image to base64
      final bytes = await File(image.path).readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      // Process with OCR
      final provider = Provider.of<CandidatoProvider>(context, listen: false);
      final success = await provider.parseCv(base64Image);

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (success) {
        // Update form fields
        final candidato = provider.candidato!;
        _tituloController.text = candidato.titulo ?? '';  // titulo puede ser null
        _bioController.text = candidato.bio ?? '';        // bio puede ser null
        _ubicacionController.text = candidato.ubicacion ?? '';  // ubicacion puede ser null

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ CV procesado exitosamente',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: const Color(0xFF26A69A),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al procesar CV: ${provider.error}',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: const Color(0xFFE94560),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e', style: GoogleFonts.inter()),
          backgroundColor: const Color(0xFFE94560),
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<CandidatoProvider>(context, listen: false);
    final success = await provider.updateProfile({
      'titulo': _tituloController.text,
      'bio': _bioController.text,
      'ubicacion': _ubicacionController.text,
    });

    if (!mounted) return;

    if (success) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perfil actualizado', style: GoogleFonts.inter()),
          backgroundColor: const Color(0xFF26A69A),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar', style: GoogleFonts.inter()),
          backgroundColor: const Color(0xFFE94560),
        ),
      );
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
        child: Consumer2<CandidatoProvider, AuthProvider>(
          builder: (context, candidatoProvider, authProvider, child) {
            final candidato = candidatoProvider.candidato;

            if (candidato == null) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF00BCD4)),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Header
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
                      child: const Icon(Icons.person_outline, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Mi Perfil',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (!_isEditing)
                      IconButton(
                        onPressed: () => setState(() => _isEditing = true),
                        icon: const Icon(Icons.edit, color: Color(0xFF00BCD4)),
                      ),
                  ],
                ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),

                const SizedBox(height: 24),

                // OCR Button
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B2CBF), Color(0xFF5A189A)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B2CBF).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _scanCV,
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Icon(Icons.document_scanner, color: Colors.white, size: 32),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Escanear CV con IA',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Sube tu CV y la IA llenará tu perfil automáticamente',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),

                const SizedBox(height: 32),

                // Profile Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Información Personal'),
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _tituloController,
                        label: 'Título Profesional',
                        icon: Icons.work_outline,
                        enabled: _isEditing,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu título profesional';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _ubicacionController,
                        label: 'Ubicación',
                        icon: Icons.location_on_outlined,
                        enabled: _isEditing,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu ubicación';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _bioController,
                        label: 'Biografía Profesional',
                        icon: Icons.description_outlined,
                        enabled: _isEditing,
                        maxLines: 4,
                      ),

                      if (_isEditing) ...[
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() => _isEditing = false);
                                  final candidato = candidatoProvider.candidato!;
                                  _tituloController.text = candidato.titulo ?? '';    // titulo puede ser null
                                  _bioController.text = candidato.bio ?? '';          // bio puede ser null
                                  _ubicacionController.text = candidato.ubicacion ?? ''; // ubicacion puede ser null
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B9DAF),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text('Cancelar', style: GoogleFonts.inter(fontSize: 16)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _saveProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00BCD4),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text('Guardar', style: GoogleFonts.inter(fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Skills Section
                      _buildSectionTitle('Habilidades (${candidato.habilidadesCandidato?.length ?? 0})'),
                      const SizedBox(height: 16),
                      
                      if (candidato.habilidadesCandidato != null && candidato.habilidadesCandidato!.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: candidato.habilidadesCandidato!.map((hab) {
                            return _buildSkillChip(hab.habilidad?.nombre, hab.nivel);
                          }).toList(),
                        )
                      else
                        Text(
                          'No hay habilidades agregadas',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF8B9DAF),
                            fontSize: 14,
                          ),
                        ),

                      const SizedBox(height: 32),

                      // Languages Section
                      _buildSectionTitle('Idiomas (${candidato.lenguajesCandidato?.length ?? 0})'),
                      const SizedBox(height: 16),
                      
                      if (candidato.lenguajesCandidato != null && candidato.lenguajesCandidato!.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: candidato.lenguajesCandidato!.map((lang) {
                            return _buildLanguageChip(lang.lenguaje?.nombre, lang.nivel);
                          }).toList(),
                        )
                      else
                        Text(
                          'No hay idiomas agregados',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF8B9DAF),
                            fontSize: 14,
                          ),
                        ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14324A).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00BCD4).withOpacity(0.2),
        ),
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.inter(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: const Color(0xFF8B9DAF)),
          prefixIcon: Icon(icon, color: const Color(0xFF00BCD4)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildSkillChip(String? name, int nivel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name ?? 'N/A',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$nivel/10',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageChip(String? name, int nivel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B2CBF), Color(0xFF5A189A)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name ?? 'N/A',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$nivel/10',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
