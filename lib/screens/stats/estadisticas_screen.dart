import 'package:flutter/material.dart';
import 'package:habitus/constants/colores.dart';
import 'package:habitus/models/estadisticas.dart';
import 'package:habitus/models/gamificacion.dart';
import 'package:habitus/services/estadisticas_service.dart';

class EstadisticasScreen extends StatelessWidget {
  final int usuarioId;

  const EstadisticasScreen({super.key, required this.usuarioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: kAccentColor,
        title: const Text('Estadísticas'),
        iconTheme: IconThemeData(color: kAccentColor),
      ),
      drawer: _buildDrawer(context),
      body: FutureBuilder<Estadisticas>(
        future: EstadisticasService().obtenerEstadisticas(usuarioId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No hay datos disponibles',
                style: TextStyle(color: kAccentColor),
              ),
            );
          } else {
            final stats = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildIndicador("Hábitos activos", stats.habitosActivos),
                    _buildIndicador(
                      "Hábitos completados",
                      stats.habitosCompletados,
                    ),
                    _buildIndicador(
                      "Racha actual",
                      stats.rachaActual,
                      icono: Icons.whatshot,
                    ),
                    _buildIndicador("Racha más larga", stats.rachaMaxima),
                    const SizedBox(height: 24),
                    Text(
                      "Cumplimiento semanal",
                      style: TextStyle(color: kAccentColor, fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    _buildSemana(stats.cumplimientoSemanal),
                    const SizedBox(height: 32),
                    if (stats.gamificacion != null)
                      _buildGamificacion(stats.gamificacion!),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildIndicador(
    String titulo,
    int valor, {
    IconData icono = Icons.check_circle,
  }) {
    return Card(
      color: kDrawerColor,
      child: ListTile(
        leading: Icon(icono, color: kAccentColor),
        title: Text(titulo, style: TextStyle(color: kTextColor)),
        trailing: Text(
          '$valor',
          style: TextStyle(color: kAccentColor, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildSemana(List<int> dias) {
    final diasSemana = ["L", "M", "X", "J", "V", "S", "D"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (i) {
        final completado = (i < dias.length && dias[i] == 1);
        return Column(
          children: [
            Text(diasSemana[i], style: TextStyle(color: kAccentColor)),
            const SizedBox(height: 6),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: completado ? Colors.greenAccent : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildGamificacion(Gamificacion gamificacion) {
    return Card(
      color: kDrawerColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gamificación',
              style: TextStyle(
                color: kAccentColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Nivel actual: ${gamificacion.nivelActual}',
              style: TextStyle(color: kTextColor, fontSize: 16),
            ),
            Text(
              'Experiencia total: ${gamificacion.experienciaTotal}',
              style: TextStyle(color: kTextColor, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'Logros desbloqueados:',
              style: TextStyle(
                color: kAccentColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (gamificacion.logrosDesbloqueados.isEmpty)
              Text(
                'No hay logros desbloqueados',
                style: TextStyle(color: kTextColor),
              )
            else
              ...gamificacion.logrosDesbloqueados.map(
                (logro) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('- $logro', style: TextStyle(color: kTextColor)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: kDrawerColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: kPrimaryColor),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Text(
                  'Habitus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Mis hábitos', style: TextStyle(color: kTextColor)),
            leading: Icon(Icons.list, color: kAccentColor),
            onTap: () => Navigator.pushReplacementNamed(context, '/habitos'),
          ),
          ListTile(
            title: Text('Estadísticas', style: TextStyle(color: kTextColor)),
            leading: Icon(Icons.bar_chart, color: kAccentColor),
            onTap: () => Navigator.pushReplacementNamed(
              context,
              '/estadisticas',
              arguments: {'usuarioId': usuarioId},
            ),
          ),
          ListTile(
            title: Text('Ajustes', style: TextStyle(color: kTextColor)),
            leading: Icon(Icons.settings, color: kAccentColor),
            onTap: () => Navigator.pushReplacementNamed(context, '/ajustes'),
          ),
          ListTile(
            title: Text(
              'Hábitos sugeridos',
              style: TextStyle(color: kTextColor),
            ),
            leading: Icon(Icons.star, color: kAccentColor),
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/habitos-sugeridos'),
          ),
        ],
      ),
    );
  }
}
