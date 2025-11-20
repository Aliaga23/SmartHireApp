class Postulacion {
  final String id;
  final String vacanteId;
  final String candidatoId;
  final String estado;
  final DateTime fechaPostulacion;
  final PostulacionCandidato? candidato;
  final PostulacionVacante? vacante;

  Postulacion({
    required this.id,
    required this.vacanteId,
    required this.candidatoId,
    required this.estado,
    required this.fechaPostulacion,
    this.candidato,
    this.vacante,
  });

  factory Postulacion.fromJson(Map<String, dynamic> json) {
    return Postulacion(
      id: json['id'] ?? '',
      vacanteId: json['vacanteId'] ?? '',
      candidatoId: json['candidatoId'] ?? '',
      estado: json['estado'] ?? '',
      fechaPostulacion: DateTime.parse(json['fecha_postulacion'] ?? DateTime.now().toIso8601String()),
      candidato: json['candidato'] != null ? PostulacionCandidato.fromJson(json['candidato']) : null,
      vacante: json['vacante'] != null ? PostulacionVacante.fromJson(json['vacante']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vacanteId': vacanteId,
      'candidatoId': candidatoId,
      'estado': estado,
      'fecha_postulacion': fechaPostulacion.toIso8601String(),
    };
  }
}

class PostulacionCandidato {
  final String? id;
  final String? titulo;
  final String? ubicacion;
  final PostulacionUsuario? usuario;

  PostulacionCandidato({
    this.id,
    this.titulo,
    this.ubicacion,
    this.usuario,
  });

  factory PostulacionCandidato.fromJson(Map<String, dynamic> json) {
    return PostulacionCandidato(
      id: json['id'],
      titulo: json['titulo'],
      ubicacion: json['ubicacion'],
      usuario: json['usuario'] != null ? PostulacionUsuario.fromJson(json['usuario']) : null,
    );
  }
}

class PostulacionUsuario {
  final String? name;
  final String? lastname;
  final String? correo;
  final String? telefono;

  PostulacionUsuario({
    this.name,
    this.lastname,
    this.correo,
    this.telefono,
  });

  factory PostulacionUsuario.fromJson(Map<String, dynamic> json) {
    return PostulacionUsuario(
      name: json['name'],
      lastname: json['lastname'],
      correo: json['correo'],
      telefono: json['telefono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastname': lastname,
      'correo': correo,
      'telefono': telefono,
    };
  }
}

class PostulacionVacante {
  final String? id;
  final String? titulo;
  final String? ubicacion;
  final String? empresaId;

  PostulacionVacante({
    this.id,
    this.titulo,
    this.ubicacion,
    this.empresaId,
  });

  factory PostulacionVacante.fromJson(Map<String, dynamic> json) {
    return PostulacionVacante(
      id: json['id'],
      titulo: json['titulo'],
      ubicacion: json['ubicacion'],
      empresaId: json['empresaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'ubicacion': ubicacion,
      'empresaId': empresaId,
    };
  }
}
