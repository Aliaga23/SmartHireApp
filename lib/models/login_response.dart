class LoginResponse {
  final String token;
  final String tipoUsuario;
  final Usuario usuario;

  LoginResponse({
    required this.token,
    required this.tipoUsuario,
    required this.usuario,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      tipoUsuario: json['tipoUsuario'] ?? '',
      usuario: Usuario.fromJson(json['usuario']),
    );
  }
}

class Usuario {
  final String? id;
  final String? name;
  final String? lastname;
  final String? correo;
  final String? telefono;
  final String? rol;
  final String? fechaNacimiento;
  final Reclutador? reclutador;

  Usuario({
    this.id,
    this.name,
    this.lastname,
    this.correo,
    this.telefono,
    this.rol,
    this.fechaNacimiento,
    this.reclutador,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      correo: json['correo'],
      telefono: json['telefono'],
      rol: json['rol'],
      fechaNacimiento: json['fecha_nacimiento'],
      reclutador: json['reclutador'] != null ? Reclutador.fromJson(json['reclutador']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'correo': correo,
      'telefono': telefono,
      'rol': rol,
      'fecha_nacimiento': fechaNacimiento,
    };
  }
}

class Reclutador {
  final String? id;
  final String? posicion;
  final String? empresaId;
  final Empresa? empresa;

  Reclutador({
    this.id,
    this.posicion,
    this.empresaId,
    this.empresa,
  });

  factory Reclutador.fromJson(Map<String, dynamic> json) {
    return Reclutador(
      id: json['id'],
      posicion: json['posicion'],
      empresaId: json['empresaId'],
      empresa: json['empresa'] != null ? Empresa.fromJson(json['empresa']) : null,
    );
  }
}

class Empresa {
  final String? id;
  final String? name;
  final String? area;
  final String? descripcion;

  Empresa({
    this.id,
    this.name,
    this.area,
    this.descripcion,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id: json['id'],
      name: json['name'],
      area: json['area'],
      descripcion: json['descripcion'],
    );
  }
}
