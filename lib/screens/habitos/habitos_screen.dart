import 'package:flutter/material.dart';
// Importa los colores personalizados
import 'package:habitus/constants/colores.dart';
import 'package:habitus/models/habito.dart';
import 'package:habitus/services/habito_service.dart';

class HabitosScreen extends StatefulWidget {
  @override
  _HabitosScreenState createState() => _HabitosScreenState();
}

class _HabitosScreenState extends State<HabitosScreen> {
  final HabitoService _service = HabitoService();
  List<Habito> _habitos = [];

  @override
  void initState() {
    super.initState();
    _cargarHabitos();
  }

  /// Carga la lista de hábitos desde el servicio y actualiza el estado.
  Future<void> _cargarHabitos() async {
    final lista = await _service.listarHabitos();
    setState(() {
      _habitos = lista.cast<Habito>();
    });
  }

  /// Crea un nuevo hábito manualmente a través de un diálogo de texto.
  Future<void> _crearManual() async {
    final nombre = await _dialogoTexto();
    if (nombre != null && nombre.isNotEmpty) {
      await _service.crearHabito(nombre);
      await _cargarHabitos();
    }
  }

  /// Muestra un diálogo para ingresar el nombre del nuevo hábito.
  Future<String?> _dialogoTexto() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kDrawerColor,
        title: Text('Nuevo hábito', style: TextStyle(color: kAccentColor)),
        content: TextField(
          controller: controller,
          style: TextStyle(color: kAccentColor),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kAccentColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kAccentColor, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: kAccentColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text('Crear', style: TextStyle(color: kAccentColor)),
          ),
        ],
      ),
    );
  }

  /// Cancela un hábito, eliminándolo de la lista y actualizando el estado.
  Future<void> _marcarCancelar(int index) async {
    final habito = _habitos[index];

    bool nuevoEstado = !habito.completadoHoy;

    if (nuevoEstado) {
      await _service.marcarComoHecho(habito.id!);
    } else {
      await _service.desmarcarComoHecho(
        habito.id!,
      ); // <-- Asegúrate que este método exista
    }

    setState(() {
      _habitos[index] = habito.copyWith(completadoHoy: nuevoEstado);
      _habitos = [..._habitos]; // Fuerza rebuild
    });
  }

  /// Añade un hábito sugerido a la lista de hábitos.
  void _addSugeridoToList() async {
    final habitoSugerido = await _service.obtenerSugerencia();

    if (habitoSugerido != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: kDrawerColor,
            title: Text(
              '¿Quieres añadir este hábito?',
              style: TextStyle(color: kAccentColor),
            ),
            content: Text(
              habitoSugerido.nombre,
              style: TextStyle(color: kAccentColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar', style: TextStyle(color: kAccentColor)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor,
                  foregroundColor: kPrimaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _habitos.add(habitoSugerido);
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Añadir'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No hay sugerencias disponibles')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: kAccentColor,
        title: const Text('Mis Hábitos'),
      ),
      body: _habitos.isEmpty
          ? Center(
              child: Text(
                '¿Aún sin hábitos? ¡Añade uno ahora!',
                style: TextStyle(color: kTextColor, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _habitos.length,
              itemBuilder: (_, i) => Theme(
                data: Theme.of(
                  context,
                ).copyWith(unselectedWidgetColor: kAccentColor),
                child: CheckboxListTile(
                  checkColor: kPrimaryColor,
                  activeColor: kAccentColor,
                  title: Text(
                    _habitos[i].nombre,
                    style: TextStyle(color: kTextColor),
                  ),
                  subtitle: _habitos[i].sugerido
                      ? Text('Sugerido', style: TextStyle(color: kAccentColor))
                      : null,
                  value: _habitos[i].completadoHoy,
                  onChanged: (_) => _marcarCancelar(i),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            backgroundColor: kAccentColor,
            foregroundColor: kPrimaryColor,
            heroTag: 'nuevo_habito',
            onPressed: _crearManual,
            label: Text('Nuevo hábito'),
            icon: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            backgroundColor: kAccentColor,
            foregroundColor: kPrimaryColor,
            heroTag: 'sugerencia_habito',
            onPressed: _addSugeridoToList,
            label: Text('Sugerencia'),
            icon: Icon(Icons.lightbulb),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: kDrawerColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: kPrimaryColor),
              child: Row(
                children: [
                  // Icon(Icons.bar_chart, color: kAccentColor, size: 32),
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
            _drawerItem('Mis hábitos', '/habitos', kAccentColor, Icons.list),
            _drawerItem(
              'Estadísticas',
              '/estadisticas',
              kAccentColor,
              Icons.bar_chart,
            ),
            _drawerItem('Ajustes', '/ajustes', kAccentColor, Icons.settings),
            _drawerItem(
              'Hábitos sugeridos',
              '/habitos-sugeridos',
              kAccentColor,
              Icons.star,
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(String title, String route, Color color, IconData icon) {
    return ListTile(
      title: Text(title, style: TextStyle(color: kTextColor)),
      leading: Icon(icon, color: color),
      onTap: () => Navigator.pushReplacementNamed(context, route),
    );
  }
}
