import 'dart:async';

import 'package:flutter/material.dart';
// Importa los colores personalizados
import 'package:habitus/constants/colores.dart';
import 'package:habitus/models/habito.dart';
import 'package:habitus/services/habito_service.dart';

class HabitosSugeridosScreen extends StatefulWidget {
  const HabitosSugeridosScreen({super.key});

  @override
  State<HabitosSugeridosScreen> createState() => _HabitosSugeridosScreenState();
}

class _HabitosSugeridosScreenState extends State<HabitosSugeridosScreen> {
  final HabitoService _service = HabitoService();
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  List<Habito> _resultados = [];
  List<Habito> _sugeridos = [];

  @override
  void initState() {
    super.initState();
    _cargarSugeridos();
  }

  /// Carga los hábitos sugeridos al iniciar la pantalla
  /// y los almacena en [_sugeridos].
  void _cargarSugeridos() async {
    final todos = await _service.listarHabitos();
    setState(() {
      _sugeridos = todos.where((h) => h.sugerido).toList();
    });
  }

  /// Realiza una búsqueda de hábitos que no están sugeridos
  /// y actualiza [_resultados] con los que coinciden.
  void _buscar(String query) async {
    if (query.length < 3) {
      setState(() {
        _resultados = [];
      });
      return;
    }

    final todos = await _service.listarHabitos();
    final sinSugerir = todos
        .where(
          (h) =>
              !h.sugerido &&
              h.nombre.toLowerCase().contains(query.toLowerCase()),
        )
        .take(5)
        .toList();

    setState(() {
      _resultados = sinSugerir;
    });
  }

  /// Maneja el cambio de texto en el campo de búsqueda,
  /// cancelando el debounce anterior si existe
  /// y programando una nueva búsqueda después de 300 ms.
  void _onTextChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _buscar(value));
  }

  /// Alterna el estado de sugerido de un hábito.
  void _toggleSugerido(Habito habito) async {
    final nuevoEstado = !habito.sugerido;

    setState(() {
      habito.sugerido = nuevoEstado;
      if (nuevoEstado) {
        if (!_sugeridos.any((h) => h.id == habito.id)) _sugeridos.add(habito);
      } else {
        _sugeridos.removeWhere((h) => h.id == habito.id);
      }
    });

    await _service.actualizarSugerido(habito.id!, nuevoEstado);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text('Buscar hábitos'),
        backgroundColor: kPrimaryColor,
        foregroundColor: kAccentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: TextStyle(color: kTextColor),
              decoration: InputDecoration(
                labelText: 'Buscar hábito...',
                labelStyle: TextStyle(color: kTextColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kAccentColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kAccentColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.clear, color: kAccentColor),
                        onPressed: () {
                          _controller.clear();
                          _onTextChanged('');
                        },
                      ),
              ),
              cursorColor: kAccentColor,
              onChanged: _onTextChanged,
            ),
            const SizedBox(height: 20),
            Text(
              'Resultados',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kAccentColor,
              ),
            ),
            ..._resultados.map(
              (h) => CheckboxListTile(
                title: Text(h.nombre, style: TextStyle(color: kTextColor)),
                activeColor: kAccentColor,
                checkColor: Colors.white,
                value: h.sugerido,
                onChanged: (val) => _toggleSugerido(h),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            const Divider(height: 32),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Hábitos sugeridos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kAccentColor,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: _sugeridos.map((habito) {
                  return CheckboxListTile(
                    value: habito.sugerido,
                    onChanged: (_) => _toggleSugerido(habito),
                    title: Text(
                      habito.nombre,
                      style: TextStyle(color: kTextColor),
                    ),
                    activeColor: kAccentColor,
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: kDrawerColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: kPrimaryColor),
              child: Text(
                'Habitus',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Mis hábitos', style: TextStyle(color: kTextColor)),
              onTap: () => Navigator.pushReplacementNamed(context, '/habitos'),
              leading: Icon(Icons.list, color: kAccentColor),
            ),
            ListTile(
              title: Text('Estadísticas', style: TextStyle(color: kTextColor)),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/estadisticas'),
              leading: Icon(Icons.bar_chart, color: kAccentColor),
            ),
            ListTile(
              title: Text('Ajustes', style: TextStyle(color: kTextColor)),
              onTap: () => Navigator.pushReplacementNamed(context, '/ajustes'),
              leading: Icon(Icons.settings, color: kAccentColor),
            ),
            ListTile(
              title: Text(
                'Hábitos sugeridos',
                style: TextStyle(color: kTextColor),
              ),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/habitos-sugeridos'),
              leading: Icon(Icons.star, color: kAccentColor),
            ),
          ],
        ),
      ),
    );
  }
}
