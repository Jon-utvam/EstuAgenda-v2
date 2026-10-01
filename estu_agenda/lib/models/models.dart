class Tarea {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fechaEntrega;
  bool completada;

  Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fechaEntrega,
    this.completada = false,
  });
}

class Materia {
  final String id;
  final String nombre;
  final String profesor;
  final List<Tarea> tareas;

  Materia({
    required this.id,
    required this.nombre,
    required this.profesor,
    List<Tarea>? tareas,
  }) : tareas = tareas ?? [];
}

class Alumno {
  final String id;
  final String nombre;
  final List<Materia> materias;

  Alumno({
    required this.id,
    required this.nombre,
    List<Materia>? materias,
  }) : materias = materias ?? [];
}