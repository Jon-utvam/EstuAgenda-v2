import 'package:flutter/material.dart';
import '../models/models.dart';
import 'materias_tareas_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';


class TareaConMateria {
  final Tarea tarea;
  final Materia materia;

  TareaConMateria({required this.tarea, required this.materia});
}

class CalendarScreen extends StatefulWidget {
  final Alumno? alumno;
  final String? correo;

  const CalendarScreen({
    super.key,
    this.alumno,
    this.correo,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const Color primaryTeal = Color(0xFF1D969F);
  static const Color bgColor = Color(0xFFEBF6F8);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF124B51);

  late DateTime _visibleMonth;
  int _currentBottomNavIndex = 0;

  final List<String> _months = const [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  final List<String> _weekDays = const ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month, 1);
  }

  // --- OBTENCIÓN DINÁMICA DE DATOS ---

  List<TareaConMateria> get _todasLasTareas {
    if (widget.alumno == null || widget.alumno!.materias.isEmpty) {
      return [];
    }

    final List<TareaConMateria> lista = [];
    for (var materia in widget.alumno!.materias) {
      for (var tarea in materia.tareas) {
        lista.add(TareaConMateria(tarea: tarea, materia: materia));
      }
    }
    return lista;
  }

  List<TareaConMateria> get _tareasPendientes {
    final pendientes = _todasLasTareas.where((item) => !item.tarea.completada).toList();
    pendientes.sort((a, b) => a.tarea.fechaEntrega.compareTo(b.tarea.fechaEntrega));
    return pendientes;
  }

  TareaConMateria? get _proximaTarea {
    final pendientes = _tareasPendientes;
    return pendientes.isNotEmpty ? pendientes.first : null;
  }

  List<TareaConMateria> _tareasPorDia(DateTime date) {
    return _todasLasTareas.where((item) {
      final f = item.tarea.fechaEntrega;
      return f.year == date.year && f.month == date.month && f.day == date.day;
    }).toList();
  }

  // --- NAVEGACIÓN ---

  void _previousMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    });
  }

  Future<void> _abrirPantallaMateriasYTareas() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MateriasTareasScreen()),
    );
    // Al regresar de la pantalla de tareas, actualiza el estado por si agregaron elementos
    setState(() {});
  }

  void _cerrarSesion() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _mostrarMensajeEnDesarrollo(String nombreSeccion) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('La sección "$nombreSeccion" está en desarrollo 🚀'),
        duration: const Duration(seconds: 2),
        backgroundColor: primaryTeal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // --- FORMATOS DE FECHA ---

  String _formatearFechaLarga(DateTime date) {
    final now = DateTime.now();
    final esHoy = date.year == now.year && date.month == now.month && date.day == now.day;
    final esManana = date.year == now.year && date.month == now.month && date.day == now.day + 1;
    final mesNombre = _months[date.month - 1].toLowerCase();

    if (esHoy) return 'Hoy, ${date.day} de $mesNombre';
    if (esManana) return 'Mañana, ${date.day} de $mesNombre';
    return '${date.day} de $mesNombre';
  }

  String _formatearHora(DateTime date) {
    final hora = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minutos = date.minute.toString().padLeft(2, '0');
    final periodo = date.hour >= 12 ? 'PM' : 'AM';
    return '$hora:$minutos $periodo';
  }

  @override
  Widget build(BuildContext context) {
    final nombreUsuario = widget.alumno?.nombre.isNotEmpty == true
        ? widget.alumno!.nombre
        : 'Estudiante';
    final correoUsuario = widget.correo ?? 'estudiante@email.com';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: primaryTeal, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.auto_stories_rounded, color: primaryTeal, size: 28),
            SizedBox(width: 8),
            Text(
              'Agenda',
              style: TextStyle(
                color: textDark,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none_rounded, color: primaryTeal, size: 28),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: primaryTeal,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () => _mostrarMensajeEnDesarrollo('Notificaciones'),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // --- MENÚ DESPLEGABLE COMPLETO COMO EN LA IMAGEN ---
      drawer: Drawer(
        backgroundColor: cardColor,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.auto_stories_rounded, color: primaryTeal, size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Agenda',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: primaryTeal.withOpacity(0.15),
                      child: const Icon(Icons.person_outline, size: 40, color: primaryTeal),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      nombreUsuario,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    Text(
                      correoUsuario,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  children: [
                    _buildDrawerOption(
                      icon: Icons.home_rounded,
                      title: 'Inicio',
                      isSelected: true,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerOption(
                      icon: Icons.person_outline_rounded,
                      title: 'Perfil',
                      onTap: () {
                        Navigator.pop(context);
                        _mostrarMensajeEnDesarrollo('Perfil');
                      },
                    ),
                    _buildDrawerOption(
                      icon: Icons.calendar_month_outlined,
                      title: 'Calendario',
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerOption(
                      icon: Icons.menu_book_rounded,
                      title: 'Materias',
                      onTap: () {
                        Navigator.pop(context);
                        _abrirPantallaMateriasYTareas();
                      },
                    ),
                    _buildDrawerOption(
                      icon: Icons.check_box_outlined,
                      title: 'Tareas',
                      onTap: () {
                        Navigator.pop(context);
                        _abrirPantallaMateriasYTareas();
                      },
                    ),
                    _buildDrawerOption(
                      icon: Icons.settings_outlined,
                      title: 'Configuración',
                      onTap: () {
                        Navigator.pop(context);
                        _mostrarMensajeEnDesarrollo('Configuración');
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildDrawerOption(
                  icon: Icons.logout_rounded,
                  title: 'Cerrar sesión',
                  isLogout: true,
                  onTap: () {
                    Navigator.pop(context);
                    _cerrarSesion();
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProximaTareaBanner(),
            const SizedBox(height: 20),
            _buildCalendarioMensual(),
            const SizedBox(height: 20),
            _buildSeccionTitulo('Accesos rápidos', onTapVerMas: () {}),
            const SizedBox(height: 10),
            _buildAccesosRapidosGrid(),
            const SizedBox(height: 20),
            _buildSeccionTitulo('Próximas actividades', onTapVerMas: _abrirPantallaMateriasYTareas),
            const SizedBox(height: 10),
            _buildListaProximasActividades(),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentBottomNavIndex,
          onTap: (index) {
            setState(() {
              _currentBottomNavIndex = index;
            });
            if (index == 1 || index == 2) {
              _abrirPantallaMateriasYTareas();
            } else if (index == 3) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: cardColor,
          selectedItemColor: primaryTeal,
          unselectedItemColor: Colors.grey.shade400,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Calendario',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box_outlined),
              label: 'Tareas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  // --- COMPONENTES VISUALES ---

  Widget _buildProximaTareaBanner() {
    final proxima = _proximaTarea;

    if (proxima == null) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: primaryTeal.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryTeal.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.task_alt_rounded, color: primaryTeal, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¡Estás al día!',
                    style: TextStyle(
                      color: primaryTeal,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'No tienes tareas pendientes',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Presiona en accesos rápidos para agregar una.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: _abrirPantallaMateriasYTareas,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: primaryTeal.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryTeal.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.article_outlined, color: primaryTeal, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Próxima tarea',
                    style: TextStyle(
                      color: primaryTeal,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    proxima.materia.nombre,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    proxima.tarea.titulo,
                    style: TextStyle(color: textDark.withOpacity(0.8), fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: primaryTeal),
                      const SizedBox(width: 4),
                      Text(
                        _formatearFechaLarga(proxima.tarea.fechaEntrega),
                        style: const TextStyle(fontSize: 12, color: textDark),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, size: 14, color: primaryTeal),
                      const SizedBox(width: 4),
                      Text(
                        _formatearHora(proxima.tarea.fechaEntrega),
                        style: const TextStyle(fontSize: 12, color: textDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: primaryTeal, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarioMensual() {
    final firstDayOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final firstWeekday = firstDayOfMonth.weekday;
    final totalCells = 35;
    final now = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_months[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, color: primaryTeal),
                    onPressed: _previousMonth,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded, color: primaryTeal),
                    onPressed: _nextMonth,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: _weekDays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalCells,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 44,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - (firstWeekday - 1) + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(_visibleMonth.year, _visibleMonth.month, dayNumber);
              final esHoy = date.year == now.year && date.month == now.month && date.day == now.day;
              final tareasDelDia = _tareasPorDia(date);
              final tieneTareas = tareasDelDia.isNotEmpty;

              return InkWell(
                onTap: _abrirPantallaMateriasYTareas,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: esHoy ? primaryTeal : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: TextStyle(
                          color: esHoy ? Colors.white : textDark,
                          fontWeight: esHoy ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      if (tieneTareas) ...[
                        const SizedBox(height: 2),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: esHoy ? Colors.white : primaryTeal,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionTitulo(String titulo, {required VoidCallback onTapVerMas}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 24),
          onPressed: onTapVerMas,
        ),
      ],
    );
  }

  Widget _buildAccesosRapidosGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: [
        _buildAccesoRapidoCard(
          icon: Icons.article_outlined,
          title: 'Agregar tarea',
          iconBgColor: const Color(0xFFE0F7FA),
          iconColor: primaryTeal,
          onTap: _abrirPantallaMateriasYTareas,
        ),
        _buildAccesoRapidoCard(
          icon: Icons.event_note_outlined,
          title: 'Ver pendientes',
          iconBgColor: const Color(0xFFEDE7F6),
          iconColor: Colors.deepPurple,
          onTap: _abrirPantallaMateriasYTareas,
        ),
        _buildAccesoRapidoCard(
          icon: Icons.menu_book_outlined,
          title: 'Materias',
          iconBgColor: const Color(0xFFE3F2FD),
          iconColor: Colors.blue,
          onTap: _abrirPantallaMateriasYTareas,
        ),
        _buildAccesoRapidoCard(
          icon: Icons.notifications_none_rounded,
          title: 'Recordatorios',
          iconBgColor: const Color(0xFFFCE4EC),
          iconColor: Colors.pink,
          onTap: () => _mostrarMensajeEnDesarrollo('Recordatorios'),
        ),
      ],
    );
  }

  Widget _buildAccesoRapidoCard({
    required IconData icon,
    required String title,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaProximasActividades() {
    final pendientes = _tareasPendientes;

    if (pendientes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Text(
            'No hay actividades agendadas',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      children: pendientes.take(3).map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            onTap: _abrirPantallaMateriasYTareas,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryTeal.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.article_outlined, color: primaryTeal, size: 22),
            ),
            title: Text(
              item.tarea.titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: textDark,
                fontSize: 14,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.materia.nombre, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(_formatearFechaLarga(item.tarea.fechaEntrega), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(_formatearHora(item.tarea.fechaEntrega), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDrawerOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    bool isLogout = false,
  }) {
    final colorText = isLogout ? Colors.red : (isSelected ? primaryTeal : textDark);
    final colorBg = isSelected ? primaryTeal.withOpacity(0.12) : Colors.transparent;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: colorBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        leading: Icon(icon, color: colorText, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: colorText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}