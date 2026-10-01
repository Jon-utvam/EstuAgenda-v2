import 'package:flutter/material.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color primaryTeal = Color(0xFF1D969F);
  static const Color bgColor = Color(0xFFEBF6F8);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF124B51);

  // Widget para crear cada opción de configuración con su propio color de ícono
  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: textDark,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: () {}, // Agregar la lógica futura aquí
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: const [
            Icon(Icons.menu_book_rounded, color: primaryTeal, size: 28),
            SizedBox(width: 8),
            Text(
              'Configuraciones',
              style: TextStyle(
                color: textDark,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingsOption(
              icon: Icons.volume_up_outlined,
              title: 'Sonido',
              iconColor: Colors.blue,
              iconBgColor: Colors.blue.withOpacity(0.15),
            ),
            _buildSettingsOption(
              icon: Icons.notifications_none_rounded,
              title: 'Notificaciones',
              iconColor: Colors.deepPurple,
              iconBgColor: Colors.deepPurple.withOpacity(0.15),
            ),
            _buildSettingsOption(
              icon: Icons.palette_outlined,
              title: 'Apariencia',
              iconColor: Colors.pink,
              iconBgColor: Colors.pink.withOpacity(0.15),
            ),
            _buildSettingsOption(
              icon: Icons.info_outline,
              title: 'Acerca de',
              iconColor: Colors.orange,
              iconBgColor: Colors.orange.withOpacity(0.15),
            ),
            
            const Spacer(), // Empuja el botón al final de la pantalla
            
            // Botón Cerrar Sesión
            TextButton.icon(
              onPressed: () {
                // Navegar al Login y limpiar todo el historial de navegación
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: primaryTeal),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: primaryTeal,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}