import 'package:flutter/material.dart';

class PantallaEncuesta extends StatefulWidget {
  const PantallaEncuesta({super.key});

  @override
  State<PantallaEncuesta> createState() => _PantallaEncuestaState();
}

class _PantallaEncuestaState extends State<PantallaEncuesta> {
  // Estado del Slider
  double _calificacion = 8.0;

  // Estado de los CheckboxListTile
  bool _velocidad = true;
  bool _amabilidad = true;
  bool _calidadProducto = false;

  // Estado del ChoiceChip (solo uno seleccionado a la vez)
  String _canalSeleccionado = 'Presencial';
  final List<String> _canales = ['Presencial', 'Virtual', 'Telefónico'];

  // Devuelve la lista de aspectos marcados, para el resumen
  List<String> get _aspectosMarcados {
    final lista = <String>[];
    if (_velocidad) lista.add('Velocidad');
    if (_amabilidad) lista.add('Amabilidad');
    if (_calidadProducto) lista.add('Calidad');
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encuesta de Satisfacción'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Slider de calificación ---
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'CALIFICACIÓN (1 - 10)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        Text(
                          _calificacion.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _calificacion,
                      min: 1.0,
                      max: 10.0,
                      divisions: 9,
                      activeColor: Colors.teal,
                      label: _calificacion.round().toString(),
                      onChanged: (double val) {
                        setState(() {
                          _calificacion = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- CheckboxListTile: aspectos destacados ---
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 12, left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ASPECTOS DESTACADOS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text('Buena Velocidad'),
                    value: _velocidad,
                    activeColor: Colors.teal,
                    onChanged: (valor) {
                      setState(() {
                        _velocidad = valor!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Amabilidad del Personal'),
                    value: _amabilidad,
                    activeColor: Colors.teal,
                    onChanged: (valor) {
                      setState(() {
                        _amabilidad = valor!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Calidad del Producto'),
                    value: _calidadProducto,
                    activeColor: Colors.teal,
                    onChanged: (valor) {
                      setState(() {
                        _calidadProducto = valor!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- ChoiceChip: canal de atención ---
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CANAL DE ATENCIÓN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: _canales.map((canal) {
                        final seleccionado = _canalSeleccionado == canal;
                        return ChoiceChip(
                          label: Text(canal),
                          selected: seleccionado,
                          selectedColor: Colors.teal,
                          labelStyle: TextStyle(
                            color: seleccionado ? Colors.white : Colors.black87,
                            fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (bool selected) {
                            setState(() {
                              _canalSeleccionado = canal;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Resumen en tiempo real ---
            Card(
              color: Colors.teal[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.teal, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'RESUMEN REGISTRADO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Calificación: ${_calificacion.round()}/10 • [${_aspectosMarcados.join(", ")}] • $_canalSeleccionado',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
