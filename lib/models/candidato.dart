class Candidato {
  final String id;
  final String? titulo;
  final String? bio;
  final String? ubicacion;
  final String? fotoPerfilUrl;
  final String? usuarioId;
  final Usuario? usuario;
  final List<HabilidadCandidato>? habilidadesCandidato;
  final List<LenguajeCandidato>? lenguajesCandidato;
  final List<ExperienciaCandidato>? experiencias;
  final int? totalPostulaciones;

  Candidato({
    required this.id,
    this.titulo,
    this.bio,
    this.ubicacion,
    this.fotoPerfilUrl,
    this.usuarioId,
    this.usuario,
    this.habilidadesCandidato,
    this.lenguajesCandidato,
    this.experiencias,
    this.totalPostulaciones,
  });

  factory Candidato.fromJson(Map<String, dynamic> json) {
    return Candidato(
      id: json['id'] ?? '',
      titulo: json['titulo'],
      bio: json['bio'],
      ubicacion: json['ubicacion'],
      fotoPerfilUrl: json['foto_perfil_url'],
      usuarioId: json['usuarioId'],
      usuario: json['usuario'] != null ? Usuario.fromJson(json['usuario']) : null,
      habilidadesCandidato: json['habilidadesCandidato'] != null
          ? (json['habilidadesCandidato'] as List).map((e) => HabilidadCandidato.fromJson(e)).toList()
          : null,
      lenguajesCandidato: json['lenguajesCandidato'] != null
          ? (json['lenguajesCandidato'] as List).map((e) => LenguajeCandidato.fromJson(e)).toList()
          : null,
      experiencias: json['experiencias'] != null
          ? (json['experiencias'] as List).map((e) => ExperienciaCandidato.fromJson(e)).toList()
          : null,
      totalPostulaciones: json['_count'] != null ? json['_count']['postulaciones'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'bio': bio,
      'ubicacion': ubicacion,
      'foto_perfil_url': fotoPerfilUrl,
      'usuarioId': usuarioId,
    };
  }
}

class Usuario {
  final String? id;
  final String? name;
  final String? lastname;
  final String? correo;
  final String? telefono;
  final String? fechaNacimiento;

  Usuario({
    this.id,
    this.name,
    this.lastname,
    this.correo,
    this.telefono,
    this.fechaNacimiento,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      correo: json['correo'],
      telefono: json['telefono'],
      fechaNacimiento: json['fecha_nacimiento'],
    );
  }
}

class HabilidadCandidato {
  final String? id;
  final int nivel;
  final Habilidad? habilidad;

  HabilidadCandidato({
    this.id,
    required this.nivel,
    this.habilidad,
  });

  factory HabilidadCandidato.fromJson(Map<String, dynamic> json) {
    return HabilidadCandidato(
      id: json['id'],
      nivel: json['nivel'] ?? 0,
      habilidad: json['habilidad'] != null ? Habilidad.fromJson(json['habilidad']) : null,
    );
  }
}

class Habilidad {
  final String? id;
  final String? nombre;
  final Categoria? categoria;

  Habilidad({
    this.id,
    this.nombre,
    this.categoria,
  });

  factory Habilidad.fromJson(Map<String, dynamic> json) {
    return Habilidad(
      id: json['id'],
      nombre: json['nombre'],
      categoria: json['categoria'] != null ? Categoria.fromJson(json['categoria']) : null,
    );
  }
}

class Categoria {
  final String? id;
  final String? nombre;

  Categoria({
    this.id,
    this.nombre,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}

class LenguajeCandidato {
  final String? id;
  final int nivel;
  final Lenguaje? lenguaje;

  LenguajeCandidato({
    this.id,
    required this.nivel,
    this.lenguaje,
  });

  factory LenguajeCandidato.fromJson(Map<String, dynamic> json) {
    return LenguajeCandidato(
      id: json['id'],
      nivel: json['nivel'] ?? 0,
      lenguaje: json['lenguaje'] != null ? Lenguaje.fromJson(json['lenguaje']) : null,
    );
  }
}

class Lenguaje {
  final String? id;
  final String? nombre;

  Lenguaje({
    this.id,
    this.nombre,
  });

  factory Lenguaje.fromJson(Map<String, dynamic> json) {
    return Lenguaje(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}

class ExperienciaCandidato {
  final String? id;
  final String? titulo;
  final String? empresa;
  final String? descripcion;
  final String? ubicacion;
  final String? fechaComienzo;
  final String? fechaFinal;

  ExperienciaCandidato({
    this.id,
    this.titulo,
    this.empresa,
    this.descripcion,
    this.ubicacion,
    this.fechaComienzo,
    this.fechaFinal,
  });

  factory ExperienciaCandidato.fromJson(Map<String, dynamic> json) {
    return ExperienciaCandidato(
      id: json['id'],
      titulo: json['titulo'],
      empresa: json['empresa'],
      descripcion: json['descripcion'],
      ubicacion: json['ubicacion'],
      fechaComienzo: json['fecha_comienzo'],
      fechaFinal: json['fecha_final'],
    );
  }
}
