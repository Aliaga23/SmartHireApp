class PostulacionCandidato {
  final String id;
  final DateTime? creadoEn;
  final VacantePostulacion? vacante;
  final double? puntuacionCompatibilidad;

  PostulacionCandidato({
    required this.id,
    this.creadoEn,
    this.vacante,
    this.puntuacionCompatibilidad,
  });

  factory PostulacionCandidato.fromJson(Map<String, dynamic> json) {
    return PostulacionCandidato(
      id: json['id'] ?? '',
      creadoEn: json['creado_en'] != null ? DateTime.parse(json['creado_en']) : null,
      vacante: json['vacante'] != null ? VacantePostulacion.fromJson(json['vacante']) : null,
      puntuacionCompatibilidad: json['puntuacion_compatibilidad']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creado_en': creadoEn?.toIso8601String(),
    };
  }
}

class VacantePostulacion {
  final String? id;
  final String? titulo;
  final String? descripcion;
  final String? estado;
  final double? salarioMinimo;
  final double? salarioMaximo;
  final DateTime? creadoEn;
  final EmpresaSimple? empresa;
  final Modalidad? modalidad;
  final Horario? horario;

  VacantePostulacion({
    this.id,
    this.titulo,
    this.descripcion,
    this.estado,
    this.salarioMinimo,
    this.salarioMaximo,
    this.creadoEn,
    this.empresa,
    this.modalidad,
    this.horario,
  });

  factory VacantePostulacion.fromJson(Map<String, dynamic> json) {
    return VacantePostulacion(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      estado: json['estado'],
      salarioMinimo: json['salario_minimo'] != null 
          ? double.tryParse(json['salario_minimo'].toString())
          : null,
      salarioMaximo: json['salario_maximo'] != null
          ? double.tryParse(json['salario_maximo'].toString())
          : null,
      creadoEn: json['creado_en'] != null ? DateTime.parse(json['creado_en']) : null,
      empresa: json['empresa'] != null ? EmpresaSimple.fromJson(json['empresa']) : null,
      modalidad: json['modalidad'] != null ? Modalidad.fromJson(json['modalidad']) : null,
      horario: json['horario'] != null ? Horario.fromJson(json['horario']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'estado': estado,
      'salario_minimo': salarioMinimo,
      'salario_maximo': salarioMaximo,
    };
  }
}

class EmpresaSimple {
  final String? id;
  final String? name;
  final String? area;

  EmpresaSimple({
    this.id,
    this.name,
    this.area,
  });

  factory EmpresaSimple.fromJson(Map<String, dynamic> json) {
    return EmpresaSimple(
      id: json['id'],
      name: json['name'],
      area: json['area'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'area': area,
    };
  }
}

class Modalidad {
  final String? id;
  final String? nombre;

  Modalidad({
    this.id,
    this.nombre,
  });

  factory Modalidad.fromJson(Map<String, dynamic> json) {
    return Modalidad(
      id: json['id'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}

class Horario {
  final String? id;
  final String? nombre;

  Horario({
    this.id,
    this.nombre,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      id: json['id'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}
