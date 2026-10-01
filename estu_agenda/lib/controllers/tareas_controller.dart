import 'package:flutter/material.dart';

enum EstadoTarea { pendiente, enProceso, terminada }

class Tarea {
  final String id;
  String titulo;
  String materia;
  EstadoTarea estado;

  Tarea({
    required this.id,
    required this.titulo,
    required this.materia,
    this.estado = EstadoTarea.pendiente,
  });
}

class TareasController extends ChangeNotifier {
  // 1. Listas vacías inicialmente
  final List<String> materias = [];
  String? _materiaSeleccionada;
  String? get materiaSeleccionada => _materiaSeleccionada;

  String _filtroActivo = 'Todas';
  String get filtroActivo => _filtroActivo;

  final List<Tarea> _todasLasTareas = [];

  // --- GESTIÓN DE MATERIAS ---

  void agregarMateria(String nuevaMateria) {
    final materiaLimpia = nuevaMateria.trim();
    if (materiaLimpia.isEmpty) return;

    if (!materias.contains(materiaLimpia)) {
      materias.add(materiaLimpia);
      _materiaSeleccionada = materiaLimpia;
      notifyListeners();
    }
  }

  void editarMateriaActual(String nuevoNombre) {
    final nombreLimpio = nuevoNombre.trim();
    if (nombreLimpio.isEmpty || _materiaSeleccionada == null) return;

    final index = materias.indexOf(_materiaSeleccionada!);
    if (index != -1) {
      final materiaAntigua = _materiaSeleccionada!;
      materias[index] = nombreLimpio;
      _materiaSeleccionada = nombreLimpio;

      // Actualizar el nombre de la materia en todas sus tareas asociadas
      for (var tarea in _todasLasTareas) {
        if (tarea.materia == materiaAntigua) {
          tarea.materia = nombreLimpio;
        }
      }
      notifyListeners();
    }
  }

  void eliminarMateriaActual() {
    if (_materiaSeleccionada == null) return;

    final materiaAEliminar = _materiaSeleccionada!;
    materias.remove(materiaAEliminar);

    // Eliminar también las tareas asociadas a esta materia
    _todasLasTareas.removeWhere((t) => t.materia == materiaAEliminar);

    // Seleccionar la primera materia disponible si existe
    _materiaSeleccionada = materias.isNotEmpty ? materias.first : null;
    notifyListeners();
  }

  void seleccionarMateria(String nuevaMateria) {
    _materiaSeleccionada = nuevaMateria;
    notifyListeners();
  }

  void agregarTarea(String titulo) {
    if (titulo.trim().isEmpty || _materiaSeleccionada == null) return;
    _todasLasTareas.add(
      Tarea(
        id: DateTime.now().toString(),
        titulo: titulo.trim(),
        materia: _materiaSeleccionada!,
        estado: EstadoTarea.pendiente,
      ),
    );
    notifyListeners();
  }

  void editarTarea(String id, String nuevoTitulo) {
    final tituloLimpio = nuevoTitulo.trim();
    if (tituloLimpio.isEmpty) return;

    final index = _todasLasTareas.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todasLasTareas[index].titulo = tituloLimpio;
      notifyListeners();
    }
  }

  void eliminarTarea(String id) {
    _todasLasTareas.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void cambiarEstadoTarea(String id, EstadoTarea nuevoEstado) {
    final index = _todasLasTareas.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todasLasTareas[index].estado = nuevoEstado;
      notifyListeners();
    }
  }

  void cambiarFiltro(String nuevoFiltro) {
    _filtroActivo = nuevoFiltro;
    notifyListeners();
  }

  List<Tarea> get tareasFiltradas {
    if (_materiaSeleccionada == null) return [];

    var tareasDeMateria = _todasLasTareas.where((t) => t.materia == _materiaSeleccionada);

    if (_filtroActivo == 'Pendientes') {
      return tareasDeMateria.where((t) => t.estado == EstadoTarea.pendiente).toList();
    } else if (_filtroActivo == 'En proceso') {
      return tareasDeMateria.where((t) => t.estado == EstadoTarea.enProceso).toList();
    } else if (_filtroActivo == 'Terminadas') {
      return tareasDeMateria.where((t) => t.estado == EstadoTarea.terminada).toList();
    }
    return tareasDeMateria.toList();
  }

  Color obtenerColorEstado(EstadoTarea estado) {
    switch (estado) {
      case EstadoTarea.pendiente:
        return const Color(0xFFE57373);
      case EstadoTarea.enProceso:
        return const Color(0xFFFFB74D);
      case EstadoTarea.terminada:
        return const Color(0xFF81C784);
    }
  }
}