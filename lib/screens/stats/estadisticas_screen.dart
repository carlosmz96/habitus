import 'package:flutter/material.dart';
import 'package:habitus/constants/colores.dart';

class EstadisticasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor, // darkBlue
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: kAccentColor,
        title: const Text('Estadísticas'),
        iconTheme: IconThemeData(color: kAccentColor),
      ),
      drawer: Drawer(
        backgroundColor: kDrawerColor, // igual que habitos sugeridos
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: kPrimaryColor),
              child: Row(
                children: [
                  Icon(Icons.bar_chart, color: kAccentColor, size: 32),
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
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/estadisticas'),
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
      ),
    );
  }
}
