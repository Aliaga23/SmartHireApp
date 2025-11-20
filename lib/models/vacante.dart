class Vacante {
  final String id;
  final String titulo;
  final String? descripcion;
  final String? ubicacion;
  final String? salario;
  final String? tipoContrato;
  final String? experiencia;
  final String? estado;
  final String? empresaId;
  final VacanteCount? count;

  Vacante({
    required this.id,
    required this.titulo,
    this.descripcion,
    this.ubicacion,
    this.salario,
    this.tipoContrato,
    this.experiencia,
    this.estado,
    this.empresaId,
    this.count,
  });

  factory Vacante.fromJson(Map<String, dynamic> json) {
    return Vacante(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'],
      ubicacion: json['ubicacion'],
      salario: json['salario'],
      tipoContrato: json['tipo_contrato'],
      experiencia: json['experiencia'],
      estado: json['estado'],
      empresaId: json['empresaId'],
      count: json['_count'] != null ? VacanteCount.fromJson(json['_count']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'ubicacion': ubicacion,
      'salario': salario,
      'tipo_contrato': tipoContrato,
      'experiencia': experiencia,
      'estado': estado,
      'empresaId': empresaId,
    };
  }
}

class VacanteCount {
  final int postulaciones;

  VacanteCount({required this.postulaciones});

  factory VacanteCount.fromJson(Map<String, dynamic> json) {
    return VacanteCount(
      postulaciones: json['postulaciones'] ?? 0,
    );
  }
}
